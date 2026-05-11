---
title: WSL로 GUI 프로그램 실행하기(wslg)
slug: gui-on-wsl
author: rammie
type: posts
date: 2024-03-27T14:39:09+00:00
#url: /dev/165/
cover:
  image: /images/2024/03/xeyes.png
categories: dev
tags: [gui, linux, wsl, wslg, x11]
---
굳이 그럴 필요는 없지만, 나는 내 서버를 사용하기 위해 Windows 노트북에서 WSL을 통해 Linux를 실행하고, 그 위에서 ssh 접속을 한다. WSL(Windows Subsystem for Linux)은 Windows 환경에서 별도의 VM 프로그램 없이 Linux OS를 이용할 수 있게 해준다.

<div class="vlp-link-container vlp-template-default wp-block-visual-link-preview-link">
  <a href="https://learn.microsoft.com/ko-kr/windows/wsl/install" class="vlp-link" title="WSL 설치" rel="nofollow" target="_blank"></a> 
  
  <div class="vlp-link-image-container">
    <div class="vlp-link-image">
      <img decoding="async" src="https://learn.microsoft.com/en-us/media/open-graph-image.png" style="max-width: 150px; max-height: 150px" />
    </div>
  </div>
  
  <div class="vlp-link-text-container">
    <div class="vlp-link-title">
      WSL 설치
    </div>
    
    <div class="vlp-link-summary">
      wsl &#8211;install 명령을 사용하여 Linux용 Windows 하위 시스템을 설치합니다.
    </div>
  </div>
</div>

기존에는 CLI로만 서버를 제어하는 것으로 충분했는데, 최근에는 gui 프로그램 실행도 필요하게 되었다. 그런데 기존 WSL1에서는 gui를 지원하지 않는다. WSL의 gui(wslg)는 WSL2부터 지원한다(※ 아래 링크에서 WSL2 실행 조건 확인).

<div class="vlp-link-container vlp-template-default wp-block-visual-link-preview-link">
  <a href="https://learn.microsoft.com/ko-kr/windows/wsl/tutorials/gui-apps" class="vlp-link" title="WSL으로 Linux GUI 앱 실행" rel="nofollow" target="_blank"></a> 
  
  <div class="vlp-link-image-container">
    <div class="vlp-link-image">
      <img decoding="async" src="https://learn.microsoft.com/en-us/media/open-graph-image.png" style="max-width: 150px; max-height: 150px" />
    </div>
  </div>
  
  <div class="vlp-link-text-container">
    <div class="vlp-link-title">
      WSL으로 Linux GUI 앱 실행
    </div>
    
    <div class="vlp-link-summary">
      WSL이 Linux GUI 앱 실행을 지원하는 방법을 알아봅니다.
    </div>
  </div>
</div>

WSL1을 사용 중이라면 Power shell(관리자 모드로 실행)에서 다음과 같이 WSL2로 update 할 수 있다.

<pre class="wp-block-code"><code>PS&gt; wsl --update
PS&gt; wsl --shutdown
PS&gt; wsl --set-version Ubuntu 2
PS&gt; wsl -l -v</code></pre>

Version 변경은 시간이 상당히 걸린다. 마지막 명령 실행 후 아래와 같이 VERSION이 2로 나온다면 성공이다.

<div class="wp-block-image">
  <figure class="aligncenter size-full"><img loading="lazy" decoding="async" width="332" height="57" src="https://rammie-blog.xyz/images/2024/03/wsl_version.png" alt="" class="wp-image-160" srcset="https://rammie-blog.xyz/images/2024/03/wsl_version.png 332w, https://rammie-blog.xyz/images/2024/03/wsl_version-300x52.png 300w" sizes="auto, (max-width: 332px) 100vw, 332px" /></figure>
</div>

WSL2에서 환경변수 $DISPLAY의 값을 확인해보면 :0과 같은 값으로 표시되는 것을 확인 할 수 있다.

<pre class="wp-block-code"><code>Ubuntu&gt; echo $DISPLAY
:0</code></pre>

gui 프로그램을 실행해보고 싶다면 x11-apps를 설치하여 xeyes나 xclock 같은 app으로 테스트 가능하다. x11은 이후 ssh 접속에서 gui를 열 때에도 이용된다.

<pre class="wp-block-code"><code>Ubuntu&gt; sudo apt install x11-apps -y
Ubuntu&gt; xeyes</code></pre>

<div class="wp-block-image">
  <figure class="aligncenter size-full"><img loading="lazy" decoding="async" width="297" height="221" src="https://rammie-blog.xyz/images/2024/03/xeyes.png" alt="" class="wp-image-168" /></figure>
</div>
