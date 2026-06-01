---
title: '[ttyd] Web browser에서 접속 가능한 terminal을 만들자!'
slug: terminal-on-web-browser
author: rammie
type: posts
date: 2025-11-21T14:33:19+00:00
#url: /dev/199/
cover:
  image: /images/2025/11/ttyd.png
categories: dev
tags: [ssh, terminal, ttyd, wetty]
---

내 서버를 외부에서 접속하려면 터미널 앱에서 ssh 명령을 통해 접속해야한다. ssh 접속을 하려면 22번 포트(또는 host가 정한 다른 포트)가 열려있어야 하는데, 22번 포트가 열려있지 않거나 적절한 터미널이 없는 환경에서는 서버 접속이 불가능한걸까?

인터넷 접속이 가능한 환경이라면 http(80), https(443) 포트는 열려 있을테니, 웹 브라우저를 통해 서버에 접속할 수 있지 않을까 생각하게 됐다. Host에서는 웹 페이지 하나를 띄워주고, 해당 페이지에 터미널 앱을 올려놓는 것이다.

방법으로는 xterm.js 라이브러리를 이용해서 terminal 기능과 hosting 기능을 기초부터 구현할 수도 있고, wetty나 ttyd 같이 이미 구현된 web 기반 terminal 앱을 이용할 수도 있다. 나는 이미 nginx를 통해 블로그를 hosting 하고 있고, 직접 terminal 기능을 구현할 생각이 없으니 당연히 후자의 방법을 택했다. 아래는 chatGPT가 비교한 wetty와 ttyd의 특징이다.

|  | **Wetty** | **ttyd** |
|---|---|---|
| 언어 / 구현 | Node.js 기반 npm 패키지로 배포됨. | C 언어 기반 + libwebsockets 사용. |
| 프론트엔드 | xterm.js 사용. | 역시 xterm.js 사용. |
| 접속 방식 | 기본적으로 SSH 백엔드: 웹에서 SSH로 서버에 접속하는 구조 (ssh-host 옵션 있음). | CLI 명령 실행(예: ttyd bash)로 웹 터미널을 띄움. |
| SSL / 보안 | SSL 키 / 인증서 지정 가능. | SSL 지원 + 기본 인증(basic auth) 가능. |
| 인증 | SSH 로그인 방식 (사용자 이름/비밀번호 또는 키) 가능 | 기본 인증, 사용자 지정 명령 실행 등 옵션이 다양함. |
| 퍼포먼스 / 경량성 | Node.js 기반이라 프로세스가 있을 수 있음. | C 기반이라 더 가볍고 빠를 수 있음. |
| 플랫폼 지원 | Node 환경이 가능한 곳이면 설치 가능 | 리눅스, macOS, Windows, OpenWrt 등 다양한 OS 지원. |

내 서버는 미니PC기 때문에 무조건 가벼운게 최고다. 당연히 ttyd를 선택했다. 아래 순서대로 ttyd hosting 환경을 구축했다.

```
# ttyd 설치
bash> sudo apt install ttyd
```

내 서버에 아무나 접속하면 안되니까 기본적인 보안도 적용했다.

```
bash> sudo apt install apache2-utils
bash> sudo htpasswd -c /etc/nginx/.terminal_passwd myuser
```

기존에 nginx가 hosting 중인 사이트 config에 terminal을 위한 주소와 설정을 추가한다.

```
# /etc/nginx/sites-available/yourblog.conf

location /terminal/ {
    auth_basic "Restricted";
    auth_basic_user_file /etc/nginx/.terminal_passwd; #basic auth 적용

    proxy_pass http://127.0.0.1:7681/; # 7681은 port 예시
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
}
```

수정된 .conf 파일을 적용하기 위해 nginx를 reload하고, ttyd를 실행시킨다. ttyd를 실행할때는 .conf 파일에서 선언한 port 번호와 일치하도록 --port 인자를 넣어줘야한다.

```
# nginx test & reload
bash> sudo nginx -t
bash> sudo systemctl reload nginx

# ttyd 실행
bash> ttyd --port 7681 bash
```

이제 브라우저에서 사이트 주소 뒤에 /terminal/ 을 붙여서 접속하면 서버 터미널에 접속할 수 있다. htpasswd에서 설정한 login 정보를 입력하면 terminal 화면이 뜬다!

![web터미널](/images/2025/11/accessed.png)

특징은 서버 user 로그인을 하지 않아도 ttyd를 실행한 user로 이미 로그인된 터미널이 떠버린다. 보안상 상당히 위험해 보이니 ttyd 옵션을 찾아보거나, 보안 인증을 추가하는게 좋을 것 같다. chatGPT는 Clouldflare를 이용한 추가 인증을 추천하고 있어서 나중에 적용해봐야겠다.

![ChatGPT답변](/images/2025/11/ttyd_Ex.png)
