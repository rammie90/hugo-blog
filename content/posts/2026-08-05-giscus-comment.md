---
date: 2026-08-05T00:28:43+09:00
draft: false
title: Giscus를 이용한 Hugo blog 댓글 기능 구현
type: posts
slug: giscus-comment
categories: [dev, 블로그 운영]
tags: [hugo, blog, giscus]
cover:
  image: /images/2026/08/giscus-profile.png
---
## 서론
블로그를 찾아주는 사람은 거의 없는 것 같지만.. 댓글 기능도 언젠간 넣어야지 벼르고 있었습니다. [hugo 블로그로 변경](/posts/migration-wp-to-hugo)하기 전 WordPress 블로그를 사용할 때에는, 댓글 기능이 기본으로 들어가 있어서 기능 구현을 신경쓰지는 않았습니다. 다만 WordPress 댓글은 별도의 인증 없이 아무나 쓸 수 있다보니, 광고 봇들을 막기 위해 관리자 승인을 거쳐야 노출되도록 설정하는 등의 번거로움이 있었습니다. 찾아주는 사람 없는 블로그인데도 광고 게시 시도는 하루에도 수백건씩 오더라구요..

아무튼 지금은 hugo 블로그를 사용중이고, hugo는 정적 사이트 생성기이기 때문에 자체적으로 댓글을 지원하는 옵션은 없습니다. 그렇다고 댓글을 아예 못쓰는건 아니고, 페이지에 외부 댓글 시스템을 붙여넣으면 구현할 수가 있습니다. 댓글을 구현해주는 시스템은 giscus, uterrances, Disqus 등 여러가지가 있어서 뭘 선택해야 좋을지 또 찾아봐야 하는데요, 다행히 비슷한 고민을 하신 선배 개발자분들이 있어 저는 고민하는 시간을 줄일 수 있었습니다.

<details>
<summary>댓글 시스템 비교</summary>

|서비스  |로그인 방식 |비용    |특징|
|--|--|--|--|
|Giscus  |GitHub 계정 |무료    |GitHub Discussions 기반, 개발자 블로그에 최적, 광고 없음|
|Utterances  |GitHub 계정 |무료    |GitHub Issues 기반, 더 단순하지만 스레드/반응 기능 약함|
|Disqus  |Google/Facebook/Twitter 등  |무료(광고)/유료 |범용적, 로그인 폭이 넓지만 무거움 + 광고 붙음|
|Waline  |GitHub/Google/QQ 등 |무료(자체 호스팅)   |서버(Vercel 등) 필요, 이메일 알림·이모지 반응 지원|
</details>

---

참고한 블로그 중에 [minyeamer](https://minyeamer.github.io)님이 올리신 내용이 딱 제가 생각한 목적과 일치해서 많이 참고를 했습니다.
* minyeamer님 포스팅: <https://minyeamer.github.io/blog/giscus-comment/>

위 블로그 내용과 동일하게 [giscus](https://github.com/giscus/giscus)를 선택했습니다. 설치 및 구현방법도 여러 블로그에 나와 있지만, 제 식대로도 설명해보겠습니다.

## giscus 댓글 시스템 구현
giscus는 github의 discussions 기능을 활용하는 방식입니다. 실제 데이터는 github repository의 discussions에 있지만, 내용과 작성 창을 블로그에 표시해 줄 뿐인거죠. 그래서 giscus 댓글 구현을 위해서는 공개된 github repository가 필요하고, 댓글 작성자는 github 계정이 있어야합니다.  
구현 방법을 요약하면 repo 생성 -> discussions 활성화 -> giscus app 설치 -> hugo 소스에 스크립트 붙여넣기 입니다.

### 공개된 repository 생성, discussions 활성화
다행히 저는 이 블로그 source code를 관리하는 repository가 public으로 공개되어있습니다. 그래서 별도의 repo 생성은 생략했고, 해당 repo에 discussions 기능을 활성화했습니다. 활성화 하면 repository 페이지에 **Discussions** tab이 생깁니다.  
Discussion를 활성화해서 들어가보면 여러개의 category가 만들어져있습니다. 실제로 discussions를 활용할 가능성은 매우 낮겠지만, giscus 댓글 데이터와 다른 category 내용이 섞이는건 좋지 않으므로 별도의 category를 생성해줍니다. Category 속성은 **Announcement**로 해주면 혹시나 다른 사람이 이 category에 직접 글을 작성하는 일을 방지할 수 있습니다.

### giscus application 설치
이번에 처음 사용해 본 기능인데, github 내에서도 plug-in 처럼 여러가지 application 들을 설치할 수 있더라구요. 왼쪽 상단 메뉴를 열고 **Marketplace**에 들어가면 app이름으로 검색할 수 있습니다.

![github-marketplace](/images/2026/08/giscus-01-marketplace.png)
giscus를 검색하고 설치 페이지로 들어가면 결재 창으로 넘어갑니다. giscus는 opensource기 때문에 실제로 비용이 들지는 않습니다.

![giscus-install-config](/images/2026/08/giscus-02-install.png)
설치 페이지에서 접근할 repository를 선택할 수 있습니다. 위에서 Discussions를 활성화해준 public repository를 선택해줍니다.  
이렇게 discus app을 설치하면 giscus가 내 repo에 접근해서 discussions에 글을 남길 수 있게 됩니다.

### html script 생성
repo에는 giscus가 설치 되었으니, 이번엔 블로그 쪽에 giscus를 연결해줘야합니다. <https://giscus.app/ko> 페이지에서 옵션을 선택해주면 블로그에 붙여넣을 수 있는 html script를 자동 생성해줍니다.

![giscus-script-config](/images/2026/08/giscus-04-gen-repo-path.png)
언어를 선택하고, giscus가 설치된 repo 위치를 넣어줍니다. giscus app이 설치가 되었는지 확인이 되면 초록색으로 표시가 됩니다.  
Discussions에서 사용할 제목을 선택하게 되는데, 저는 기본 선택되어있는 path를 기준으로 생성하도록 했습니다. 페이지 url에서 메인 도메인 주소를 제외한 뒷부분이 사용됩니다.

![giscus-script-config](/images/2026/08/giscus-05-gen-category-theme.png)
giscus가 접근할 category로 아까 Discussions에 새로 생성한 category를 선택해줍니다.  
추가 기능으로는 느리게 불러오기를 선택했습니다. 해당 옵션을 선택하면 댓글 시스템을 불러오느라 블로그 페이지를 표시하는 속도가 느려지는 것을 막을 수 있습니다. 실제 댓글 시스템 호출은 스크롤을 내려 댓글 부분이 보일때에 일어나도록 합니다.  
마지막으로 블로그와 어울리는 테마를 선택할 수 있는데, **Preferred color scheme**을 선택하면 블로그의 Light/Dark 테마에 맞춰 댓글 테마도 바뀌도록 만들 수 있습니다.

### 블로그에 html script 끼워넣기
옵션 선택을 마치면 아래에 생성된 html 스크립트가 보입니다.

``` html
<script src="https://giscus.app/client.js"
    data-repo="rammie90/hugo-blog"
    data-repo-id="R_kgDOSgyzHA"
    data-category="giscus database"
    data-category-id="DIC_kwDOSgyzHM4DCqGm"
    data-mapping="pathname"
    data-strict="0"
    data-reactions-enabled="1"
    data-emit-metadata="0"
    data-input-position="bottom"
    data-theme="preferred_color_scheme"
    data-lang="ko"
    data-loading="lazy"
    crossorigin="anonymous"
    async>
</script>
```

이제 이 내용을 블로그 sourcecode가 있는 곳에 끼워넣어야 하는데요, hugo papermod 테마를 사용하는 경우에는 **layout/patials/comments.html** 파일을 생성해서 위 내용을 넣어주면 됩니다. papermod 테마의 post 들은 **single.html** 파일을 layout으로 사용하는데, 해당 파일에서 comments.html을 불러옵니다.

그리고 papermod 테마의 Light/Dark 모드 토글과 giscus 테마를 일치시키려면 내용을 더 추가해야 합니다. giscus의 **Preferred color scheme**은 OS의 Light/Dark 테마를 따라가기 때문에, 블로그 테마의 토글과 다를 수 있습니다. **comments.html** 파일에 아래 내용을 추가해주면 블로그의 토글을 따라가도록 만들 수 있습니다.

``` html
<script>
    function setGiscusTheme(theme) {
        const iframe = document.querySelector('iframe.giscus-frame');
        if (!iframe) return;
        iframe.contentWindow.postMessage(
                { giscus: { setConfig: { theme: theme === 'dark' ? 'dark' : 'light' } } },
                'https://giscus.app'
                );
    }

    // PaperMod는 <html data-theme="dark|light">로 테마를 저장
    const observer = new MutationObserver(() => {
            setGiscusTheme(document.documentElement.getAttribute('data-theme'));
            });
    observer.observe(document.documentElement, { attributes: true, attributeFilter: ['data-theme'] });

    window.addEventListener('load', () => {
            setTimeout(() => setGiscusTheme(document.documentElement.getAttribute('data-theme')), 1000);
            });
</script>
```

### 확인
code 삽입을 마치고 hugo 재배포를 실행하면 블로그 포스팅에 댓글창이 추가된 것을 확인할 수 있습니다.

![](/images/2026/08/giscus-06-test.png)

블로그에서 댓글을 써보고 giscus가 연결된 repo의 Discussions 페이지를 들어가보면 새로운 토론이 생성돼있는것도 볼 수 있습니다.

![](/images/2026/08/giscus-07-github.png)

## 마치며
실제로 giscus를 이용해서 댓글을 구현하는데는 몇분 걸리지도 않은 것 같습니다. 제 블로그에도 다시 댓글창이 생긴걸 보니 뿌듯하네요. 아쉬운점이 있다면 위에서 giscus 기능 옵션 중에 느리게 불러오기를 선택했는데, 생각보다 댓글창 표시가 많이 느리네요. 스크롤을 휙휙 내려버리면 댓글 기능이 있는걸 못보고 넘어갈 수도 있을 것 같습니다. 그래도 댓글창이 있는걸 발견하신다면 아무말이라도 써봐주세요 ㅎㅎ. 읽어주셔서 감사합니다!
