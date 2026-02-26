---
title: "Django runserver 포트 변경과 외부 접속 허용"
slug: django-runserver
date: 2025-04-10 02:04:00 +09:00
last_modified_at: 2025-04-10 02:04:00 +09:00
categories: [Framework, Django]
tags: [django, troubleshooting]
image: "/assets/img/title/framework/django/logo_designed_3.png"
---

Django 개발 서버는 기본적으로 8000번 포트를 사용합니다.  
하지만 개발 편의나 네트워크 환경에 따라 포트와 IP 주소를 변경하여 실행할 수도 있습니다.  

**🔀 포트 변경**  
예를 들어, 8080번 포트를 사용하고 싶다면 다음과 같이 실행하면 됩니다.  
```bash
python manage.py runserver 8080
```
이 경우, Django 서버는 `http://localhost:8080`에서 실행되며, 브라우저에서도 해당 주소로 접속할 수 있습니다.  

**🌐 외부 접속 허용**  
다른 기기에서도 서버에 접속할 수 있도록 하려면, 아래와 같이 IP 주소를 `0.0.0.0`으로 지정하면 됩니다.  
```bash
python manage.py runserver 0.0.0.0:8080
```
이 경우, 서버가 외부의 모든 요청을 수신하도록 설정됩니다.  
> ⚠️ 보안상 주의가 필요하며, 개발 환경에서만 사용하는 것을 권장합니다.  

또한, 아래와 같이 특정 IP에 대해서만 접근을 허용하는 방법도 있습니다.  
```bash
python manage.py runserver 192.168.0.10:8080
```
이 경우, 지정한 IP 주소(192.168.0.10)에서만 서버에 접근할 수 있게 됩니다.  
> ℹ️ 네트워크 환경에 따라 포트포워딩이나 방화벽 등의 추가 설정이 필요할 수 있습니다.  

감사합니다.  
