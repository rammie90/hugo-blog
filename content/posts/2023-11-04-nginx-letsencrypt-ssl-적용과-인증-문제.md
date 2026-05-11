---
title: Nginx letsencrypt SSL 적용과 인증 문제
slug: nginx-ssl-troubleshooting
author: rammie
type: posts
date: 2023-11-04T14:39:47+00:00
#url: /dev/86/
cover:
  image: /images/2023/11/ssl.jpg
categories: dev
tags: [https, letsencrypt, linux, nginx, server, ssl, security]
---
서버를 구축하고, WordPress를 설치하고, 내 domain을 구매해서 이제 어디서나 domain 주소로 내 블로그에 접속할 수 있게 되었다. 하지만 이 상태로 블로그를 사용하면 보안이 취약해서 블로그 관리를 위한 로그인 정보 등이 해킹 당할 위험이 있다. 보안을 강화하기 위해서 SSL을 적용할 수 있다.

<ul class="wp-block-list">
  <li>
    웹사이트 보안을 위한 방법, SSL이란? <ul class="wp-block-list">
      <li>
        <a href="https://blog.naver.com/skinfosec2000/222135874222">https://blog.naver.com/skinfosec2000/222135874222</a>
      </li>
    </ul>
  </li>
</ul>

내 domain 주소에 SSL을 적용하는 방법도 여러 블로그에 잘 설명되어 있다.

<ul class="wp-block-list">
  <li>
    Nginx letsencrypt SSL 적용기 <ul class="wp-block-list">
      <li>
        <a href="https://yeopbox.com/우분투ubuntu-22-04-server-워드프레스-nginx-letsencrypt-ssl-적용기/">https://yeopbox.com/우분투ubuntu-22-04-server-워드프레스-nginx-letsencrypt-ssl-적용기/</a>
      </li>
    </ul>
  </li>
</ul>

그대로 따라하면 SSL 적용은 어렵지 않다. SSL을 적용하기 위해서는 인증서가 사용되는데, 이 인증서는 일정 주기(3개월)마다 갱신해줘야 한다. 위 블로그에서 인증서 자동 갱신을 적용하는 방법까지 설명되어 있지만, 나는 이 갱신이 수행되는 부분에서 문제가 발생했다.

<ul class="wp-block-list">
  <li>
    Let&#8217;s Encrypt SSL 인증서 자동 갱신 설정 방법 <ul class="wp-block-list">
      <li>
        <a href="https://devlog.jwgo.kr/2019/04/16/how-to-lets-encrypt-ssl-renew/">https://devlog.jwgo.kr/2019/04/16/how-to-lets-encrypt-ssl-renew/</a>
      </li>
    </ul>
  </li>
</ul>

자동 인증서 갱신이 실행되지 않아서, 수동으로 renew를 시도 했으나 아래와 같이 &#8220;check that a DNS record exists for this domain&#8221; error가 발생했다.

<pre class="wp-block-code"><code>Certbot failed to authenticate some domains (authenticator: nginx). The Certificate Authority reported these problems:
  Domain: www.rammie-blog.xyz
  Type:   dns
  Detail: DNS problem: NXDOMAIN looking up A for www.rammie-blog.xyz - check that a DNS record exists for this domain; DNS problem: NXDOMAIN looking up AAAA for www.rammie-blog.xyz - check that a DNS record exists for this domain</code></pre>

Error message를 보면 알 수 있지만, 문제는 domain 앞에 www. 가 붙는 주소에서만 발생했고, www. 가 없는 주소에 대한 갱신은 정상적으로 수행되었다. www 주소를 이용하지 않을 것이라면 nginx site config 파일을 수정하여 www 주소를 제거하면 되고, www 주소까지 사용할 것이라면 domain을 구입한 사이트에서 www 주소도 추가해주면 문제가 해결된다.

<ul class="wp-block-list">
  <li>
    SSL 인증 이슈 <ul class="wp-block-list">
      <li>
        <a href="https://happist.com/579208/ssl-%EC%9D%B8%EC%A6%9D-%EC%9D%B4%EC%8A%88-dns-problem">https://happist.com/579208/ssl-인증-이슈-dns-problem</a>
      </li>
    </ul>
  </li>
</ul>

나는 domain을 구매했던 가비아에서 www 주소도 추가했고, 다시 인증서 갱신을 시도하니 error 없이 수행되었다.

<ul class="wp-block-list">
  <li>
    추가 참고 <ul class="wp-block-list">
      <li>
        Let’s Encrypt 인증서로 NGINX SSL 설정하기(상세) <ul class="wp-block-list">
          <li>
            <a href="https://nginxstore.com/blog/nginx/lets-encrypt-인증서로-nginx-ssl-설정하기/">https://nginxstore.com/blog/nginx/lets-encrypt-인증서로-nginx-ssl-설정하기/</a>
          </li>
        </ul>
      </li>
      
      <li>
        CertBot Let&#8217;s encrypt 인증서 삭제하기 <ul class="wp-block-list">
          <li>
            <a href="https://osg.kr/archives/660">https://osg.kr/archives/660</a>
          </li>
        </ul>
      </li>
    </ul>
  </li>
</ul>
