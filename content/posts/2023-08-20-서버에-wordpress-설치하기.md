---
title: 서버에 WordPress 설치하기
slug: install-wordpress
author: rammie
type: posts
date: 2023-08-20T08:56:51+00:00
#url: /dev/92/
cover:
  image: /images/2023/08/wordpress-e1699109372198.png
categories: dev
tags: [blog, linux, server, wordpress]
---
요즘은 많은 홈페이지와 블로그들이 WordPress를 통해서 만들어진다고 한다. WordPress를 설치형 블로그라고 하는데, 페이지 모양을 구성해주는 일종의 템플릿이다.

- <https://namu.wiki/w/워드프레스>

서버 구축 이후, WordPress 설치와 사용을 위해서는 선행해야 할 작업들이 있다.

- NGINX 설치
  - <https://yeopbox.com/우분투ubuntu-22-04-server-php-nginx-설치기/>
- PHP 설치
  - <https://yeopbox.com/우분투ubuntu-22-04-server-php-nginx-설치기/>
- MariaDB 설치
  - <https://yeopbox.com/우분투ubuntu-22-04-server-mariadb-설치-및-기본-설정/>

위 프로그램 들은 왜 필요한 것일까?

[NGINX][1]는 웹 서버 프로그램이다. 웹 서버 프로그램에 대해 설명한 글 중 가장 이해하기 쉬웠던 것은, 웹 서버 프로그램이 웹 브라우저의 반대 역할을 하는 프로그램이라는 것이다. 서버는 NGINX를 통해 웹 페이지를 제공하고, 클라이언트는 Chrome, Safari등을 통해 이 웹 페이지를 볼 수 있다. 대표적은 웹 서버 프로그램으로는 [Apache HTTP server][2]가 있는데, 현재 사용률이 가장 높지만 무겁다는 단점이 있다. 나는 저사양의 미니PC로 서버를 만들었기 때문에, 무조건 가벼운 NGINX를 사용하기로 했다.

[PHP][3]와 [MariaDB][4]는 WordPress를 구동하기 위해 사용되는데, WordPress가 PHP언어로 만들어졌기 때문에 PHP가 필요하고, WordPress의 database관리를 위해 MariaDB를 사용한다. 꼭 MariaDB가 아니라 다른 database 관리 프로그램이어도 상관없을 듯 하다.

PHP 설치 단계에서 간단한 page를 만들어 브라우저로 접속해보는 test를 해볼 수 있고, 위 과정이 모두 완료되면 드디어 WordPress를 설치하고 사용할 수 있다.

- WordPress 설치
  - <https://yeopbox.com/우분투ubuntu-22-04-server-워드프레스wordpress-설치기/>

WordPress 설치 이후 서버 IP를 통해 WordPress page에 접속할 수 있고, 여러가지 설정을 할 수 있다. 다음으로는 IP주소가 아니라 다른 홈페이지들처럼 domain 주소를 통해 내 WordPress 페이지에 접속할 수 있도록 내 domain 만들기에 대해 알아보겠다.

- 추가 참고
  - nginx / nginx 환경설정 및 도메인(domain) 변경 방법
    - <https://growing-nyang.tistory.com/75?category=879817>
  - 가상 호스트 – server 블록(nginx로 여러개 사이트 운영)
    - <https://opentutorials.org/module/384/4529>
  - 워드프레스 사용을 위한 PHP 모듈, 익스텐션 설치하기
    - <https://swiftcoding.org/php-modules-for-wordpress>

 [1]: https://namu.wiki/w/NGINX
 [2]: https://namu.wiki/w/%EC%95%84%ED%8C%8C%EC%B9%98%20HTTP%20%EC%84%9C%EB%B2%84
 [3]: https://namu.wiki/w/PHP
 [4]: https://namu.wiki/w/MariaDB
