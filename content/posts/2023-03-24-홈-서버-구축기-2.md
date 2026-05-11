---
title: 홈 서버 구축기
slug: building-home-server
author: rammie
type: posts
date: 2023-03-24T12:52:09+00:00
#url: /dev/65/
cover:
  image: /images/2023/03/D8826C3F-6427-45F2-B403-27B871CF5C33-scaled-e1679578251210.jpeg
categories: dev
tags: [linux]
---
## 0. 홈 서버 용 하드웨어 준비

- 당근으로 미니PC 구매
  - Intel Core i3-4130T 2.9GHz CPU
  - 16GB RAM
  - 512GB SSD
- 집에서 사용중인 공유기에 유선으로 연결
  - 공유기 : NETGEAR R6350
    - <https://www.netgear.com/kr/home/wifi/routers/r6350/>

## 1. Linux OS 설치

- <https://nitr0.tistory.com/324>
- Ubuntu Server 22.04.2 LTS
  - <https://ubuntu.com/download/server>
- **중간에 생성하는 username과 password 기억해놓기** (ssh 접속을 위해 사용)
- System update

```
  $ sudo apt-get update
  $ sudo apt-get upgrade
```

- LAN card logical name 확인
- Local IP 확인

```
  $ sudo lshw -c network
  $ ip a
```

## 2. ssh 연결

- server에 접속할 기기를 server가 연결된 공유기 network 에 연결
- Window PC에서는 WSL 이용
  - WSL 설치: <https://blog.naver.com/yul1214/222661248678>
  - WSL 터미널에서 ssh 명령으로 server에 접속

```
  $ ssh <username>@<ip>
```

- iPad, iPhone 등 apple 기기에서는 Termius 이용
  - <https://johncom.tistory.com/45>
- **이제 서버 에 연결된 모니터와 키보드를 제거해도 ssh 접속으로 서버를 제어할 수 있다.**

## 3. Ubuntu 보안 강화

- ssh port 변경
  - <https://nitr0.tistory.com/327?category=836159>
  - <http://yeopbox.com/우분투ubuntu-22-04-server-ssh-포트-변경-및-적용기/>
  - 변경된 port 번호 적용하여 ssh 연결

```
  $ ssh <username>@<ip> -p <port>
```

- service 이름(ssh)에 mapping된 port 번호 수정

```
  $ sudo vi /etc/services
```

- 설정 적용을 위한 재시작

```
  $ service ssh restart
  $ sudo reboot
```

- 방화벽 활성화
  - <https://nitr0.tistory.com/326>
  - ufw 설치 (Ubuntu 설치 시, 기본으로 포함되어있을 수 있음)
  - 활성화 하지 않음면 기본으로 꺼져있음

```
  $ sudo apt-get install ufw
```

- 수정된 port를 허용하고 기본 ssh port인 22번을 제한
- ssh 서비스 허용

```
  $ sudo ufw allow <port>
  $ sudo ufw allow ssh
  $ sudo ufw deny 22
```

- ufw 활성화

```
  $ sudo ufw enable
```

- fail2ban 설치
  - <https://nitr0.tistory.com/328>

## 4. 외부로 port 열기 (port fowarding)

**※ 주의: port fowarding을 적용하면 즉시 서버가 외부에 노출되므로 반드시 보안강화를 먼저 진행한 후 port를 열어준다.**

- 우리집 공인 IP 확인
  - Server와 같은 공유기에 연결된 PC에서 네이버 접속
    - 네이버 검색창에 내 아이피 검색
    - 또는 Ubuntu server에서 아래의 명령어 입력

```
  $ curl ifconfig.me
```

- 공유기 설정에서 port forwarding
  - NETGEAR 제품의 경우 설정 주소는 **192.168.1.1**
  - 고급 설정에서 포트포워딩 설정 가능

![](/images/2023/03/netgear1.png)

- 서비스 이름은 단순 구분을 위한 이름이므로 아무거나 선택
- 내부 IP 주소에 server의 local IP를 입력하고 추가 버튼 클릭
- 추가된 항목 선택하여 세부 설정

![](/images/2023/03/netgear2.png)

- 서비스 종류는 TCP 선택
- 외부와 내부 동일한 포트 범위 사용을 선택하고, ssh용으로 변경한 포트번호 입력
- **이제 공인 IP를 통해 어디서든 집에 있는 server에 접속할 수 있다.**

```
  $ ssh <username>@<공인ip> -p <port>
```

## 99. Ubuntu 추가설정(optional)

- Timezone 설정
  - <http://yeopbox.com/우분투ubuntu-22-04-server-타임존timezone-설정하기/>
- NTP 시간 동기화
  - <https://webdir.tistory.com/208>
- Locale 설정
  - <http://yeopbox.com/우분투ubuntu-22-04-server-로케일locale-설정하기/>
- Kernel version upgrade
  - <https://codechacha.com/ko/ubuntu-update-kerenl/>
