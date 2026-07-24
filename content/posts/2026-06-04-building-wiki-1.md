---
date: 2026-06-04T22:44:06+09:00
draft: false
title: 위키 사이트를 만들어보자! (1)-서버 구축과 Mediawiki 설치
type: posts
slug: building-wiki-1
categories: [mediawiki, dev]
tags: [mediawiki, vultr]
cover:
  image: /images/2026/06/mediawiki_logo.jpg
---
## 서론
그동안 연습했던 서버 세팅과, 웹페이지 호스팅 경험으로 쓸모있는 사이트를 만들어보려고 합니다. 
(지금 블로그가 쓸모 없는 것은 아니지만..)  
사람들이 많이 찾는 사이트는 뭘까 생각하다가, 문득 제가 나무위키를 자주 사용한다는 걸 깨달았습니다. 
검색해보니 나무위키 연 수입이 100억이 넘는다네요 ㄷㄷ..
대단하기도 하지만, 어쨌든 그말은 제가 암만 위키를 잘 꾸며봤자 사람들은 정보를 찾으러 나무위키로 
갈것이란 뜻이기도 합니다.  
그래서 모든 정보를 다루는 범용 위키보다는, 특정 주제만을 다뤄야겠다고 생각했습니다.
뭐가 좋을까 또 고민하다가 세대간 정보 불균형이 심하다고 생각되는 밈을 주제로, 그것도 한국 밈,
**K-meme wiki**를 만들기로 했습니다.

실제 위키를 구축하기 전에, 먼저 만들어진 meme관련 wiki가 없는지 찾아봤습니다.
영어권에는 실제로 **Know Your Meme**(<https://knowyourmeme.com>)이라는 wiki가 있더라구요.  
한국에도 뭔가 만들던 흔적은 있습니다. **미미키**라는 모바일앱과 밈위키 webpage가 있는데
지금은 서비스를 안하는 것 같네요. 취준생 프로젝트 팀에서 개발한 것으로 보입니다.

- 미미키 관련 링크들
  - 밈위키 웹사이트: <https://meme-wiki.net>
  - 미미키 github: <https://github.com/Nexters/meme-wiki-fe>
  - 개발자 brunch 글: <https://brunch.co.kr/magazine/meme-wiki>

그 외에는 이렇다할 wiki 사이트가 없어 보였습니다. 현재 서비스중인 **K-meme wiki**가 없다면 
바로 만들어야지요!  
**미미키**는 팀으로 만드신 것 같은데 제가 혼자할 수 있을까.. 걱정이 되지만,
지금은 대 LLM 시대고 저에겐 클로드가 있으니 어떻게든 되겠죠!

## 본론
서론이 길었는데, 여차저차해서 구축하기로 한 **K-meme wiki**의 개발 일지를 남겨보려 합니다.
먼저 저는 **Vultr VPS**에 **Mediawiki**를 설치하고 **nginx**를 통해 사이트를 배포했습니다.
혼자도 사이트 구축은 가능했으나, 알아야 할 내용이 많아 처음으로 연재글을 써보려 합니다.
이번 글에서는 VPS 서버 구축과 오픈소스 위키 엔진인 **Mediawiki** 설치 까지 다루겠습니다.

### ✅ 도메인 구매
**K-meme wiki** 구축을 구상하자마자 한 일은 도메인 구매입니다. 아무도 안뺏어 갈 것 같지만.. 
누군가는 나와 같은 생각을 하고 있을지도 모르잖아요?  
도메인은 나무위키와 동일하게 **.wiki** 주소를 사용해서 [**k-meme.wiki**](https://k-meme.wiki)로 정했습니다.
도메인 구매는 현재 블로그 주소를 구매했던 [가비아](https://www.gabia.com)에서 했습니다.  
  - 이전 포스팅 참조: {{< post-link "2023-08-20-purchased-own-domain.md" >}}

### ✅ 서버 구축
wiki 사이트를 호스팅 할 서버가 필요합니다. 이번에는 집에있는 홈서버가 아니라 VPS를 사용하기로 했습니다.
**VPS**는 Virtual Private Server의 약자로, VPS 서비스 업체에서 제공하는 서버를 비용을 지불하고 사용하는 것입니다.
보통 대규모 컴퓨팅 클라우드에서 리소스 일부를 대여하는 것이기 때문에, 나중에 확장하기가 용이합니다.
직접 물리적인 서버를 구축하면, 모든 외부 환경도 직접 설정해야하고, 확장이 필요해지면 서버를 통째로 갈아야 할지도 모르죠..
게다가 작은 사이즈의 VPS는 사용료가 저렴하기 때문에, 초기 비용을 많이 아낄 수 있습니다.
추후에 꼭 확장..이 필요하기를 기대해봅니다.

VPS로 가장 유명한건 Amazon에서 운영하는 AWS일텐데요, 유명한 만큼 가격이 비쌉니다.
저는 가성비가 좋다고 알려진 [**Vultr**](https://www.vultr.com/)('벌쳐'라고 읽습니다)의 서비스를 이용해보기로 했습니다.  
Vultr 서버 구축은 아래 블로그들을 참고했고, OS는 Ubuntu로 설치했습니다.
  - <https://study-easy-coding.tistory.com/156>
  - <https://velog.io/@yuja/Vultr로-VPS-배포하기>

서버를 구축하면 부여된 IP 주소를 잘 확인해둡니다. 이 IP로 ssh 접속하여 Mediawiki 설치 과정을 진행합니다.
그리고 위에서 구매한 도메인에 IP를 연결하여 구축할 사이트에 접속할 수 있습니다.
도메인을 구매하지 않았다면, IP 주소로 사이트에 접속할 수도 있습니다.

### ✅ LAMP stack 설치
이전에 WordPress를 설치할 때와 마찬가지로, Mediawiki 실행을 위해서도 선행 설치해야할 프로그램들이 있습니다.
  - WordPress 설치기 참조: {{< post-link "2023-08-20-install-wordpress.md" >}}

설치할 프로그램도 WordPress와 똑같습니다. *nginx*, *PHP*, *mariaDB*를 설치해줍니다.

#### NGINX 설치
- 참고: <https://yeopbox.com/우분투ubuntu-22-04-server-php-nginx-설치기/>

``` bash
sudo apt install -y nginx
```

#### PHP 설치
Mediawiki 사용을 위해서는 PHP 확장 모듈들을 함께 설치해줍니다.

``` bash
sudo apt install -y php8.3 php8.3-fpm php8.3-mysql php8.3-xml php8.3-mbstring \
  php8.3-curl php8.3-zip php8.3-intl php8.3-apcu php8.3-gd php8.3-cli
```

#### MariaDB 설치
``` bash
sudo apt install -y mariadb-server
sudo mysql_secure_installation
```

mariaDB 설치 후에는 Mediawiki에서 사용할 DB와 DB user를 생성하고 권한 설정을 해줍니다.

``` sql
sudo mysql -u root -p

CREATE DATABASE mediawiki CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'wikiuser'@'localhost' IDENTIFIED BY '강력한비밀번호';
GRANT ALL PRIVILEGES ON mediawiki.* TO 'wikiuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### ✅ Mediawiki 설치
드디어 wiki 사이트의 본체인 Mediawiki를 설치할 차례입니다.
**Mediawiki**는 [Wikipedia](https://ko.wikipedia.org/wiki/위키백과:대문)나
[리브레위키](https://librewiki.net/wiki/리브레_위키:현관)에서 사용하는 오픈소스 엔진입니다.  
오픈소스 wiki 엔진이 있어서 얼마나 다행인지요! 우리는 직접 wiki 시스템을 구축할 필요가 없습니다.
Mediawiki를 설치하고 설정만 해주면 나만의 wiki 사이트를 만들 수 있는거죠.  
참고로 나무위키는 Mediawiki를 사용하지 않고 자체 개발한 [**the seed**](https://namu.wiki/w/the%20seed)라는
엔진을 사용한다고 합니다.

Mediawiki 공식 주소로부터 파일을 다운받고 설치를 진행합니다.
``` bash
cd /tmp
wget https://releases.wikimedia.org/mediawiki/1.43/mediawiki-1.43.0.tar.gz
tar -xzf mediawiki-1.43.0.tar.gz
sudo mv mediawiki-1.43.0 /var/www/mediawiki
sudo chown -R www-data:www-data /var/www/mediawiki
sudo chmod -R 755 /var/www/mediawiki
```
설치한 Mediawiki 데이터들을 호스팅할 수 있도록 nginx를 설정해줍니다.

``` bash
sudo vim /etc/nginx/sites-available/mediawiki
```

아래 내용 붙여넣기
``` nginx
server {
    listen 80;
    server_name your-domain.com;   # 도메인 또는 서버 IP로 변경
        root /var/www/mediawiki;
    index index.php;

    client_max_body_size 100M;

    location / {
        try_files $uri $uri/ @rewrite;
    }

    location @rewrite {
        rewrite ^/(.*)$ /index.php?title=$1&$args;
    }

    location ^~ /maintenance/ {
        return 403;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires max;
        log_not_found off;
    }

    location = /robots.txt  { access_log off; log_not_found off; }
    location = /favicon.ico { access_log off; log_not_found off; }

    location ~ /\.(ht|git) {
        deny all;
    }
}
```

설정 활성화
``` bash
sudo ln -s /etc/nginx/sites-available/mediawiki /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### ✅ Medaiwiki 설정하기
nginx 설정을 잘 했다면, 설정된 도메인으로 서버에 설치한 Mediawiki 접속이 가능합니다.
접속을 해보면 바로 우리가 아는 wiki 페이지가 나타나는 것이 아니라, 설정을 진행하라는 안내 페이지가 나타납니다.
웹 페이지에서 설정을 마치고 나면 브라우저를 통해 **LocalSettings.php** 파일을 다운받을 수 있고,
이 파일을 Mediawiki를 설치한 서버에 업로드 해주면 비로소 내가 만든 wiki 사이트를 이용할 수 있습니다.

이번 글 내용을 통해 Mediawiki 설치는 완료했지만, 이 설정부터가 진정한 시작입니다 ㅎㅎ..  
K-meme wiki의 설정 과정은 다음 포스팅에서부터 진행 해보겠습니다. 안녕!!
