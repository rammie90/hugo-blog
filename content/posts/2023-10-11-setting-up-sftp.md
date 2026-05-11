---
title: Setting up sftp
slug: setting-up-sftp
author: rammie
type: posts
date: 2023-10-11T15:07:43+00:00
#url: /dev/106/
cover:
  image: /images/2023/10/sftp.png
categories: dev
tags: [ftp, linux, server, sftp, ssh]
---
sFTP란 ssh File Transfer Protocol의 약자로, ssh 포트를 통해 파일을 주고 받을 수 있는 규약이다. FTP의 보안이 강화된 버전이라고 볼 수 있다.

원격으로 파일을 전송할 때, 간단히 scp로도 전송할 수 있다. 하지만 전송해야 할 파일이 많거나, 용량이 크거나, 서버 간 다른 플랫폼을 사용하고 있다면 전송이 어려울 수 있다.

```
scp -p [port] [file_path] [user_name]@[ip_address]:[target_path]
```

- SCP vs SFTP
  - <https://parkadd.tistory.com/129>

나는 Windows에서 Ubuntu 서버로 file을 옮기는 작업을 주로 하기 때문에, sFTP를 setup하고 FileZila를 이용해서 전송을 한다.

- 리눅스 SFTP 구축하기, FileZila로 SFTP 접속하기
  - <https://ansan-survivor.tistory.com/424>

이미 터미널을 통해 ssh접속을 사용중이라면, 몇 가지 설정만 해주면 sFTP 접속이 가능하다.

sftp group 생성 및 sftp 접속용 user 생성

```
sudo addgroup --system sftp_users
sudo adduser -s /sbin/nologin username
sudo passwd username
sudo usermod -G sftp_users username
```

sftp 접속 시 보여질 root directory 생성, sftp user directory 생성, 권한 설정

```
sudo mkdir -p /home/sftp_users/username
sudo chown root:sftp_users /home/sftp_users
sudo chown username:sftp_users /home/sftp_users/username
```

sshd config 설정 변경

```
# ssh config file 편집 열기
sudo vim /etc/ssh/sshd_config

Subsystem sftp /usr/lib/openssh/sftp-server
# 위 line을 찾아 아래 내용으로 수정
Subsystem sftp internal-sftp

# 파일 밑에 아래 라인들 추가
Match Group sftp_users
    ForceCommand internal-sftp
    ChrootDirectory /home/sftp_users
    X11Forwarding no
    AllowTcpForwarding no
```

수정된 config file을 저장하고 설정 reload

```
sudo service ssh reload
```

주의할 점은 directory 권한이다. 대부분의 접속 문제가 여기서 발생하는 것 같다. sftp의 root가 되는 directory는 root권한으로만 쓰기가 가능해야 하며, sftp group은 읽기가 가능해야 한다. user directory는 접속한 user로 쓰기가 가능해야 접속 시 문제 없이 파일 전송을 할 수 있다.
