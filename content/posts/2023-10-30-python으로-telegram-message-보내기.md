---
title: python으로 telegram message 보내기
slug: python-telegram-message
author: rammie
type: posts
date: 2023-10-30T13:51:50+00:00
#excerpt: 지난 글에서도 얘기했듯이, 나는 귀찮은 일은 프로그램으로 돌려놓고 다른일을 하기 위해 script를 작성한다. script 실행 후에는 계속 모니터를 체크하지 않지만, 원하는 조건이 되면 알림을 받기를 원할 때가 있다. 스마트폰은 계속 손에 들고 있으니까 폰으..
#url: /dev/83/
cover:
  image: /images/2023/10/telegram_icon-e1699109457493.png
categories: dev
tags: [bot, message, python, telegram]
---
지난&nbsp;글에서도&nbsp;얘기했듯이,&nbsp;나는&nbsp;귀찮은&nbsp;일은&nbsp;프로그램으로&nbsp;돌려놓고&nbsp;다른일을&nbsp;하기&nbsp;위해&nbsp;script를&nbsp;작성한다. script&nbsp;실행&nbsp;후에는&nbsp;계속&nbsp;모니터를&nbsp;체크하지&nbsp;않지만,&nbsp;원하는&nbsp;조건이&nbsp;되면&nbsp;알림을&nbsp;받기를&nbsp;원할&nbsp;때가&nbsp;있다.&nbsp;스마트폰은&nbsp;계속&nbsp;손에&nbsp;들고&nbsp;있으니까&nbsp;폰으로&nbsp;알림을&nbsp;받으면&nbsp;좋겠다&nbsp;싶었는데,&nbsp;스마트폰&nbsp;알림을&nbsp;받는&nbsp;방법도&nbsp;여러가지가&nbsp;있다.

단순하게는&nbsp;SMS메세지로&nbsp;알림을 보내면&nbsp;되겠다&nbsp;생각했는데,&nbsp;일단&nbsp;국내에서는&nbsp;무료로&nbsp;Web발신&nbsp;SMS를&nbsp;보낼&nbsp;방법이&nbsp;없다(통장&nbsp;입출금&nbsp;내역을&nbsp;SMS로&nbsp;받는건&nbsp;유료고,&nbsp;은행&nbsp;어플&nbsp;push&nbsp;알림으로&nbsp;받는건&nbsp;무료인데는&nbsp;다&nbsp;이유가&nbsp;있었다.).

또&nbsp;다른&nbsp;방법으로는&nbsp;script가&nbsp;메일을&nbsp;보내고&nbsp;메일&nbsp;수신&nbsp;알림을&nbsp;등록해놓는&nbsp;방법이&nbsp;있는데,&nbsp;단순&nbsp;알림이&nbsp;메일함에&nbsp;쌓이는것도&nbsp;싫고,&nbsp;메일&nbsp;계정에서&nbsp;해줘야하는&nbsp;설정&nbsp;등&nbsp;번거로움이&nbsp;있어서&nbsp;하지&nbsp;않았다.

마지막&nbsp;방법은&nbsp;메신저&nbsp;발신이다.&nbsp;메신저도&nbsp;카톡,&nbsp;라인&nbsp;등&nbsp;여러&nbsp;종류가&nbsp;있지만, telegram을&nbsp;이용하는&nbsp;방법이&nbsp;가장&nbsp;단순한듯&nbsp;하여&nbsp;사용해보고&nbsp;소개를&nbsp;한다.

<ul class="wp-block-list">
  <li>
    Python 텔레그램 알림, 메세지 보내는 방법 (초보자용 5분컷) <ul class="wp-block-list">
      <li>
        <a href="https://jsp-dev.tistory.com/313">https://jsp-dev.tistory.com/313</a>
      </li>
    </ul>
  </li>
</ul>

대략적인&nbsp;내용은&nbsp;다른&nbsp;블로그에서&nbsp;자세히&nbsp;알려주고&nbsp;있다.&nbsp;요약하자면&nbsp;텔레그램을&nbsp;설치해서&nbsp;가입하고,&nbsp;전용&nbsp;bot을&nbsp;생성해서&nbsp;해당&nbsp;bot&nbsp;이름으로&nbsp;python이&nbsp;메세지를&nbsp;보낼&nbsp;수&nbsp;있게&nbsp;하는&nbsp;것이다.&nbsp;다만&nbsp;최신버전에서는&nbsp;위&nbsp;블로그&nbsp;설명대로만&nbsp;하면 실행되지&nbsp;않는&nbsp;부분들이&nbsp;있으므로,&nbsp;여기서는&nbsp;troubleshooting&nbsp;위주로&nbsp;설명하겠다.

<p class="has-large-font-size">
  Chat ID 얻기
</p>

기존 예제들에서는 getUpdate() 함수를 직접 호출하지만, 어느 시점부터는 직접 호출을 허용하지 않는 듯하다. 대신 asyncio를 통해 비동기식 호출을 사용해야한다. 따라서 chat ID를 얻는 코드는 다음과 같이 작성할 수 있다.

<pre class="wp-block-code"><code>import telegram
import asyncio

token = "***personal token***"
chat = telegram.Bot(token)
updates = &lt;strong>asyncio.run(chat.getUpdates())&lt;/strong>
print(updates&#91;-1].message.chat_id)</code></pre>

<p class="has-large-font-size">
  Message 전송하기
</p>

Message 전송 함수( send_message() )역시 직접 호출이 불가능하다. asyncio를 이용해서 다음과 같이 사용해야 한다.

<pre class="wp-block-code"><code>import telegram
import asyncio

token = "***personal token***"
chat_id = "id number"
chat = telegram.Bot(token)
&lt;strong>asyncio.run(chat.send_message(chat_id=chat_id, text="MESSAGE"))&lt;/strong></code></pre>

<p class="has-large-font-size">
  Message 전송 전 수시로 Bot 호출
</p>

telegram.Bot(token)을 통해 Bot을 불러오는데, 코드 진행 중 일정 시간이 지나면 Bot과의 연결이 끊어진다. Message 전송 시 error 발생을 막으려면 전송 마다 Bot을 새로 호출해주는 것이 좋다.
