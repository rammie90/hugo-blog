---
date: 2024-03-17
draft: false
title: Ubuntu에 할당된 저장공간 확장
type: posts
slug: storage-extension
tags: [ssd, ubuntu, storage]
categories: dev
---
Ubuntu를 설치한 server를 사용하면서 simulatior를 몇개 받았더니 금방 용량이 다 차 버렸다.
사용하는 server의 SSD 용량은 512GB인데 이상하다 싶어 확인을 해보니 Ubuntu에 할당된 저장공간은 100GB 밖에 되지 않았다.
찾아보니 Ubuntu는 설치 시 초기에 100GB를 할당하고, 추가 저장공간이 필요하면 확장해서 사용해야 한다는 것을 알게되었다.
lvextend 명령어를 이용하여 Ubuntu의 저장공간을 확장할 수 있다.

<https://aeong-dev.tistory.com/6>

