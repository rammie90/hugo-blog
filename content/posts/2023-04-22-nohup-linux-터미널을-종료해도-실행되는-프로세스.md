---
title: nohup, linux 터미널을 종료해도 실행되는 프로세스
slug: using-nohup
author: rammie
type: posts
date: 2023-04-22T07:16:14+00:00
#url: /dev/71/
categories: dev
tags: [linux]
---
Script를 짜는 이유는, 내가 하기 귀찮은 일을 실행시켜놓고 다른 일을 하기 위해서다. 일반적으로 script를 돌려놓자면 터미널을 열어놓은 상태여야 하는데, 해당 터미널을 종료하면 거기서 실행했던 프로세스들도 함께 종료되는 문제가 있다. 특히 나는 애플 device에서 termius로 서버에 접속할 때가 많은데, termius 무료 버전은 termius가 background로 들어갈 때 열려있던 터미널을 닫아버린다. 그래서 터미널을 종료해도 서버가 켜져있다면 프로세스를 유지할 수 있는 방법을 찾아보았다. 몇 가지 방법이 있지만, 그 중 nohup 명령어를 사용하는게 가장 간편한 듯 하여 소개하고자 한다.

"nohup"은 No hangup의 약자이고 사용은 아래와 같이 할 수 있다.

```
nohup [process] &
```

nohup 명령어 뒤에 실행할 프로세스를 입력한 후 &를 붙여 background로 실행 시킨다. nohup으로 실행한 프로세스는 표준 출력을 터미널에 표시하지 않고, 프로세스 종료 후 실행 위치에 nohup.out 파일을 생성해서 출력내용을 저장한다. 파일 출력을 원하지 않거나, 출력 파일 이름을 변경하려면 아래와 같이 실행한다.

```
# 출력이름 변경
nohup [process] > [파일이름] &
# 파일 생성 금지
nohup [process] > /dev/null &
```

이렇게 실행한 process는 터미널을 종료해도 꺼지지 않고 실행 중인 상태로 남아있는다. nohup을 실행한 터미널이 열려 있다면 job 명령어로 프로세스가 실행 중임을 확인할 수 있는데, 해당 터미널을 종료하고 새 터미널을 열면 job 명령에도 nohup 프로세스가 보이지 않는다. 이 때는 ps 명령어로 프로세스 실행을 확인할 수 있다.

```
ps -ef | grep [process]
```

실행중인 nohup 프로세스를 종료하고 싶다면, 위 명령어로 프로세스 id를 찾아 kill 하면 된다.

```
kill [process id]
```

위 방법으로 python 스크립트 등을 실행시켜 놓고, 터미널 실행여부와 상관 없이 다른 일을 하다가 나중에 실행 결과를 확인하는 방법으로 편하게 일을 처리할 수 있다.

- 참고
  - <https://gracefulprograming.tistory.com/128>
  - <https://joonyon.tistory.com/entry/쉽게-설명한-nohup-과-백그라운드-명령어-사용법>
