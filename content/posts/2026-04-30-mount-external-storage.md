---
title: Ubuntu 서버에 외장 SSD를 mount 하고 sftp로 접근하기
slug: mount-external-storage
author: rammie
type: posts
date: 2026-04-30T17:23:15+00:00
#url: /dev/206/
cover:
  image: /images/2026/05/이미지-2026.-5.-1.-오전-2.21.png
categories: dev
tags: [mount, sftp, ssd, ubuntu]
---

Ubuntu 서버의 USB 3.0 포트에 외장 SSD 연결 후, 인식 상태를 확인하기 위해 아래 명령어를 입력한다.

```
> sudo fdisk -l
```

![fdisk캡쳐](/images/2026/05/image.png)

정상적으로 인식되었다면 위와 같이 연결 위치와 포맷 정보가 나타난다.  
USB 3.0 포트에 연결했을 때 정상적인 인식이 되지 않고, USB 2.0 포트에서는 된다면, Ubuntu가 USB 포트 절전기능을 사용하고 있지 않은지 의심해본다.  
USB 3.0은 전력 소모가 크므로, 충분한 전력이 공급되지 않으면 정상적으로 동작하지 않는다.

커널 파라미터를 수정하여 절전기능을 끌 수 있다.

```
> sudo vim /etc/default/grub
```

```
GRUB_CMDLINE_LINUX_DEFAULT=""
# 위 line을 아래와 같이 수정
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash usbcore.autosuspend=-1"
```

수정 후에 설정이 적용되도록 update하고 서버를 재시작한다.  
재시작 할 때에는 연결했던 외장 SSD를 제거하는 것을 주의한다.

```
> sudo update-grub
> sudo reboot now
```

재시작 후 다시 외장 SSD를 연결하여 정상 인식되는지 확인한다.

정상 인식이 되었다면 fdisk에서 확인한 장치 주소를 이용해 빈 directory에 mount한다.

```
> sudo mkdir /mnt/ext_ssd
> sudo mount /dev/sdb1 /mnt/ext_ssd
```

mount된 directory로 가면 외장 SSD에 있는 파일을 확인할 수 있다.

mount된 장치는 기본적으로 소유자가 root로 되어있다. 경우에 따라 sftp로 접속한 유저가 해당 위치에 접근하지 못할 수도 있다. chown -R 명령을 이용해 mount된 directory의 소유자를 변경할 수 있지만, 서버를 재시작하거나 SSD를 제거했다가 다시 연결하면 소유자 정보는 초기화된다.

영구적으로 외장 SSD의 소유자를 변경하고 싶다면, fstab 설정을 추가할 수 있다.  
먼저 외장 SSD의 UUID를 확인한다.

```
> sudo blkid
```

위에서 확인한 /dev/sdb1 장치의 UUID 및 포맷 정보가 나타난다.  
확인된 UUID를 이용해서 fstab 설정을 추가한다.

```
> sudo vim /etc/fstab
```

```
# 아래 line 추가
UUID=외장하드UUID /mnt/ext_ssd auto nosuid,nodev,nofail,uid=1000,gid=1000,dmask=007,fmask=117 0 0
```

uid와 gid는 원하는 사용자의 정보를 확인하여 수정한다.  
`dmask=007,fmask=117`은 폴더는 `770`, 파일은 `660` 권한을 주어 소유자와 그룹이 접근 가능하게 한다.

fstab 설정을 적용하기 위해 daemon을 재시작하고 새로 mount를 시도한다.

```
> sudo systemctl daemon-reload
> sudo mount -a
```

외장 SSD가 원하는 위치에 자동 mount되고 소유자가 잘 적용되었는지 확인한다.

마지막으로 sftp user도 home directory를 가지는데, SSD의 mount 위치가 home 외부라면 접근이 불가능할 수 있다. 이럴 때는 mount bind를 이용할 수 있다.  
mount bind도 fstab 파일을 수정하여 영구적용한다.

```
# sftpuser의 home에 mount point 생성
> mkdir /home/sftpuser/ext_bind
> sudo vim /etc/fstab
```

```
# 아래 line 추가
/mnt/ext_ssd  /home/sftpuser/ext_bind none bind 0 0
```

마찬가지로 daemon을 재시작하고 다시 mount를 시도한다.

```
> sudo systemctl daemon-reload
> sudo mount -a
```

sftp 접속을 해서 외장 SSD의 내용이 잘 보이는지 확인한다.  
이렇게 하면 sftp user의 home을 격리하면서 mount된 장치를 사용할 수 있다.
