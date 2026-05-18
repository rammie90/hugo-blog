---
date: {{ .Date }}
draft: true
title: {{ replace .File.ContentBaseName "-" " " | title }}
type: posts
slug: {{ .File.ContentBaseName }}
categories:
---
