---
title: "WordPress에서 Hugo로 갈아타기 by Claude"
slug: migration-wp-to-hugo
date: 2026-05-11
tags: ["hugo", "wordpress", "blog", "migration", "nginx"]
categories: ["dev"]
description: "MariaDB와 WordPress로 운영하던 블로그를 Hugo 정적 사이트로 마이그레이션한 과정"
---

## 왜 Hugo인가?

WordPress는 강력하지만 무겁다. PHP, MariaDB, 각종 플러그인이 맞물려 동작하는 구조는 단순한 블로그를 운영하기엔 오버스펙이다. 특히 코드 스니펫과 기술 글 위주의 블로그라면 더욱 그렇다.

Hugo로 갈아탄 이유는 크게 세 가지다.

- **속도**: DB 조회와 PHP 실행이 없다. nginx가 정적 HTML 파일만 서빙한다
- **단순함**: MariaDB, PHP 없이 서버 구성이 훨씬 가벼워진다
- **SEO**: 빠른 로딩 속도는 Core Web Vitals 점수에 직접 영향을 준다

### WordPress vs Hugo 요청 흐름 비교

WordPress 요청 흐름은 다음과 같다.

```
브라우저 → nginx → PHP → MariaDB → PHP → nginx → 브라우저
```

Hugo 요청 흐름은 이렇게 단순해진다.

```
브라우저 → nginx → HTML 파일
```

### 코드 블로그에 Hugo가 잘 맞는 이유

Hugo는 Chroma라는 문법 하이라이터를 빌트인으로 지원한다. 별도 플러그인 없이 200개 이상의 언어를 지원하고, 빌드 시 정적 HTML로 변환되기 때문에 Prism.js 같은 JS 라이브러리도 필요 없다.

```toml
# hugo.toml
[markup.highlight]
style = "monokai"
```

마크다운 코드블록을 그대로 쓰면 자동으로 하이라이팅이 적용된다.

---

## 마이그레이션 8단계

### 1단계. Hugo 설치

```bash
sudo apt update
sudo snap install hugo

# 버전 확인
hugo version
```

새 사이트를 생성한다.

```bash
cd ~
hugo new site myblog
cd myblog
```

생성된 디렉토리 구조는 다음과 같다.

```
myblog/
├── content/       # 글이 들어갈 곳
├── static/        # 이미지 등 정적 파일
├── themes/        # 테마
├── layouts/       # 커스터마이징
└── hugo.toml      # 설정 파일
```

### 2단계. 테마 설치

기술 블로그에 가장 많이 쓰이는 PaperMod 테마를 기준으로 설명한다.

```bash
cd ~/myblog
git init
git submodule add https://github.com/adityatelange/hugo-PaperMod themes/PaperMod
```

`hugo.toml` 기본 설정이다.

```toml
defaultContentLanguage = "ko"
title = "내 블로그"
theme = "PaperMod"

[languages.ko]
languageName = "한국어"
locale = "ko-KR"
title = "내 블로그"

[params]
ShowReadingTime = true
ShowCodeCopyButtons = true   # 코드 복사 버튼 자동 추가
ShowToc = true               # 목차 자동 생성
mainSections = ["posts"]

[markup.highlight]
style = "monokai"

[markup.goldmark.renderer]
unsafe = true                # 변환된 md 파일의 HTML 태그 렌더링
```

### 3단계. WordPress 글 마이그레이션

wordpress-to-hugo-exporter plugin을 이용해서 WordPress 글을 내보낸다.

```
# 플러그인 다운로드
cd /var/www/wordpress/wp-content/plugins/
sudo git clone https://github.com/SchumacherFM/wordpress-to-hugo-exporter

# WP 관리자에서 플러그인 활성화 후
# Tools → Export to Hugo → 다운로드
```

변환된 파일을 Hugo content 폴더로 복사한다.

```bash
cp -r build/ ~/myblog/content/
```

### 4단계. 이미지 마이그레이션

WordPress는 이미지를 업로드하면 크기별로 여러 파일을 생성한다.

```
photo.jpg             # 원본
photo-150x150.jpg     # 썸네일
photo-300x200.jpg     # 미디엄
photo-1024x683.jpg    # 라지
```

Hugo에서는 원본 파일만 있으면 되므로 리사이징된 파일을 정리한다.

```bash
# -숫자x숫자. 패턴 파일 삭제
find ./uploads -regex '.*-[0-9]+x[0-9]+\..*' -delete
```

원본 이미지를 Hugo static 폴더로 복사한다.

```bash
cp -r ./uploads/* ~/myblog/static/images/
```

마크다운에서 이미지 경로는 `static/` 폴더를 기준으로 절대경로로 작성한다.

```markdown
![설명](/images/photo.jpg)
```

### 5단계. 로컬 미리보기

```bash
cd ~/myblog
hugo server
```

같은 네트워크의 다른 PC에서 확인하려면 다음과 같이 실행한다.

```bash
hugo server --bind 0.0.0.0 --baseURL http://서버IP/
```

이때 ufw에서 포트를 허용해야 한다.

```bash
sudo ufw allow 1313

# 테스트 후 닫기
sudo ufw delete allow 1313
```

브라우저에서 `http://서버IP:1313` 으로 접속해 확인한다.

### 6단계. 빌드 및 배포

```bash
# 정적 파일 빌드
hugo build

# 서버에 rsync로 동기화
rsync -avz --delete ~/myblog/public/ /var/www/blog/

# 소유자 변경 (nginx가 www-data로 실행되므로)
sudo chown -R www-data:www-data /var/www/blog/
```

매번 입력하기 번거로우므로 alias로 등록해 둔다.

```bash
# ~/.bashrc에 추가
alias blogdeploy='cd ~/myblog && hugo build && \
rsync -avz --delete public/ /var/www/blog/ && \
sudo chown -R www-data:www-data /var/www/blog/'
```

이후 배포는 한 줄로 끝난다.

```bash
blogdeploy
```

### 7단계. nginx 설정 변경

WordPress용 설정을 Hugo용으로 교체한다.

```nginx
server {
listen 80;
server_name yourblog.com;

root /var/www/blog;
index index.html;

location / {
    try_files $uri $uri/ =404;
}

# 정적 파일 캐시
location ~* \.(jpg|jpeg|png|gif|css|js)$ {
    expires 30d;
    add_header Cache-Control "public";
}
}
```

```bash
sudo nginx -t
sudo systemctl reload nginx
```

HTTPS는 기존 certbot 설정을 그대로 사용한다.

### 8단계. 구글 서치 콘솔 업데이트

Hugo는 빌드 시 `sitemap.xml`을 자동으로 생성한다. 구글 서치 콘솔에 등록한다.

```
구글 서치 콘솔 → Sitemaps → 새 sitemap 추가
https://yourblog.com/sitemap.xml
```

---

## MariaDB 정리

마이그레이션이 완료되면 WordPress와 MariaDB를 정리할 수 있다.

```bash
# DB 백업
mysqldump -u root -p wordpress > wordpress_backup.sql

# DB 삭제
mysql -u root -p -e "DROP DATABASE wordpress;"

# MariaDB 중지
sudo systemctl stop mariadb
sudo systemctl disable mariadb
```

MariaDB와 PHP가 빠지면 서버 메모리와 CPU 사용량이 눈에 띄게 줄어든다.

---

## 이후 글쓰기 워크플로우

```bash
# 새 글 작성
hugo new content/posts/new-post.md
vim content/posts/new-post.md

# 로컬 미리보기
hugo server

# 배포
blogdeploy
```

Front Matter 기본 구조는 다음과 같다.

```yaml
---
title: "글 제목"
date: 2025-01-01
tags: ["태그1", "태그2"]
categories: ["dev"]
description: "글 요약"
slug: "post-url-slug"
---
```

어디서든 ssh로 접속해 작업할 수 있으므로 Hugo가 설치된 환경에 묶일 필요가 없다.
