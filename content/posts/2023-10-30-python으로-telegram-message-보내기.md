---
title: python으로 telegram message 보내기
slug: python-telegram-message
author: rammie
type: posts
date: 2023-10-30T13:51:50+00:00
#excerpt: 지난 글에서도 얘기했듯이, 나는 귀찮은 일은 프로그램으로 돌려놓고 다른일을 하기 위해 script를 작성한다. script 실행 후에는 계속 모니터를 체크하지 않지만, 원하는 조건이 되면 알림을 받기를 원할 때가 있다. 스마트폰은 계속 손에 들고 있으니까 폰으..
#url: /dev/83/
cover:
  image: /images/2023/10/telegram_icon-e1699109457493.png
categories: dev
tags: [bot, message, python, telegram]
---
지난 글에서도 얘기했듯이, 나는 귀찮은 일은 프로그램으로 돌려놓고 다른일을 하기 위해 script를 작성한다. script 실행 후에는 계속 모니터를 체크하지 않지만, 원하는 조건이 되면 알림을 받기를 원할 때가 있다. 스마트폰은 계속 손에 들고 있으니까 폰으로 알림을 받으면 좋겠다 싶었는데, 스마트폰 알림을 받는 방법도 여러가지가 있다.

단순하게는 SMS메세지로 알림을 보내면 되겠다 생각했는데, 일단 국내에서는 무료로 Web발신 SMS를 보낼 방법이 없다(통장 입출금 내역을 SMS로 받는건 유료고, 은행 어플 push 알림으로 받는건 무료인데는 다 이유가 있었다.).

또 다른 방법으로는 script가 메일을 보내고 메일 수신 알림을 등록해놓는 방법이 있는데, 단순 알림이 메일함에 쌓이는것도 싫고, 메일 계정에서 해줘야하는 설정 등 번거로움이 있어서 하지 않았다.

마지막 방법은 메신저 발신이다. 메신저도 카톡, 라인 등 여러 종류가 있지만, telegram을 이용하는 방법이 가장 단순한듯 하여 사용해보고 소개를 한다.

- Python 텔레그램 알림, 메세지 보내는 방법 (초보자용 5분컷)
  - <https://jsp-dev.tistory.com/313>

대략적인 내용은 다른 블로그에서 자세히 알려주고 있다. 요약하자면 텔레그램을 설치해서 가입하고, 전용 bot을 생성해서 해당 bot 이름으로 python이 메세지를 보낼 수 있게 하는 것이다. 다만 최신버전에서는 위 블로그 설명대로만 하면 실행되지 않는 부분들이 있으므로, 여기서는 troubleshooting 위주로 설명하겠다.

### Chat ID 얻기

기존 예제들에서는 getUpdate() 함수를 직접 호출하지만, 어느 시점부터는 직접 호출을 허용하지 않는 듯하다. 대신 asyncio를 통해 비동기식 호출을 사용해야한다. 따라서 chat ID를 얻는 코드는 다음과 같이 작성할 수 있다.

```python
import telegram
import asyncio

token = "***personal token***"
chat = telegram.Bot(token)
updates = asyncio.run(chat.getUpdates())
print(updates[-1].message.chat_id)
```

### Message 전송하기

Message 전송 함수( send_message() )역시 직접 호출이 불가능하다. asyncio를 이용해서 다음과 같이 사용해야 한다.

```python
import telegram
import asyncio

token = "***personal token***"
chat_id = "id number"
chat = telegram.Bot(token)
asyncio.run(chat.send_message(chat_id=chat_id, text="MESSAGE"))
```

### Message 전송 전 수시로 Bot 호출

telegram.Bot(token)을 통해 Bot을 불러오는데, 코드 진행 중 일정 시간이 지나면 Bot과의 연결이 끊어진다. Message 전송 시 error 발생을 막으려면 전송 마다 Bot을 새로 호출해주는 것이 좋다.
