---
date: 2026-08-30T00:53:58+09:00
draft: true
title: React Native로 앱 개발하기
type: posts
slug: dev-react-native
categories: dev
tags: [React-Native, Expo]
---

### Node.js 설치
``` bash
# nvm 설치
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# 터미널 재시작 또는
source ~/.bashrc

# LTS 버전 Node 설치
nvm install --lts
nvm use --lts

# 설치 확인
node -v
npm -v
```

### Expo 프로젝트 생성
``` bash
npx create-expo-app DCA-app
cd DCA-app
```
