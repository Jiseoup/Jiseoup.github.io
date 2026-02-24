---
published: false  # TODO: 퍼블리싱 임시 중지
title: "[Django REST Framework 개발부터 배포까지] (1) 프로젝트 준비"
# slug: drf-project-setup-guide
date: 2025-04-10 03:35:00 +09:00
last_modified_at: 2025-04-10 03:35:00 +09:00
categories: [Framework, Django REST Framework]
# tags: [django, drf, python, backend]
image: "/assets/img/title/framework/django_rest_framework/drf_project/lesson_1.png"
---

이번 시리즈에서는 **`Django REST Framework(DRF)`**를 활용한 백엔드 프로젝트 개발 과정을 정리해보려고 합니다.  

단순한 게시판 API 구현을 최종 목표로, 프로젝트 초기 환경 구성부터 데이터베이스 연동, Swagger를 통한 API 문서화, 그리고 Nginx + Gunicorn을 활용한 서버 배포까지 **백엔드 개발의 전반적인 과정을 다뤄보고자 합니다.**  

백엔드 개발에 관심이 있는 분들이나 DRF를 처음 접하는 분들도 부담 없이 따라오실 수 있도록 구성하고자 하니, 많은 관심 가져주시면 감사하겠습니다.  

이 시리즈가 저에게는 기술을 정리하는 기회가 되고, 여러분께는 실전 백엔드 프로젝트의 흐름을 익히는 데 도움이 되는 자료가 되기를 바랍니다.  

그럼 지금부터 시작합니다!  

{% include drf-project.html %}

## 1. Django REST Framework(DRF) 란?
---
Django REST Framework(DRF)는 **Django 기반의 웹 애플리케이션에서 REST API를 쉽게 개발할 수 있도록 도와주는 강력한 라이브러리입니다.** 기존 Django는 HTML 중심의 웹 페이지 렌더링에 특화되어 있지만, DRF는 JSON 형태로 데이터를 주고받는 API 서버 구축에 최적화되어 있습니다.  

> [REST API가 궁금하다면? 여기를 클릭하세요.](https://devpro.kr/posts/REST,-RESTful-API%EB%9E%80-%EA%B0%9C%EB%85%90-%EC%82%B4%ED%8E%B4%EB%B3%B4%EA%B8%B0/)  
{: .prompt-tip }

즉, Django에서 REST API를 만들고자 한다면 DRF는 사실상 표준 라이브러리라고 할 수 있습니다.  

## 2. 개발 환경 구성
---
이제 본격적으로 프로젝트를 시작하기에 앞서, 개발 환경 구성을 진행하겠습니다.  
본 시리즈는 **WSL2 기반 Ubuntu 24.04 LTS 환경에서 개발을 진행**하며, **최종적으로는 Ubuntu 서버에 배포하는 것을 목표**로 합니다.  

> [WSL2를 사용하고 싶다면? 여기를 클릭하세요.](https://devpro.kr/posts/Windows-11-WSL2-%EC%84%A4%EC%B9%98%EC%99%80-VSCode-%EC%97%B0%EB%8F%99/)  
{: .prompt-tip }

### 2-1. Git 저장소 구성
프로젝트의 진행 상황을 체계적으로 관리하고, 추후 서버 배포까지 원활하게 이어가기 위해서는 Git 저장소 구성은 필수입니다. 반드시 Git 저장소를 구성하고 프로젝트를 진행해주세요.  

> 📌 본 시리즈의 실습에 사용된 소스 코드는 아래 GitHub 저장소에서 확인할 수 있습니다.  
> [https://github.com/Jiseoup/DRF-Practice](https://github.com/Jiseoup/DRF-Practice)

### 2-2. 패키지 설치
먼저 Django 프로젝트를 구성하기 위해 필요한 기본 패키지를 설치합니다.  
```bash
sudo apt-get install python3-pip
sudo apt-get install python3-venv
sudo apt-get install python-is-python3
sudo apt-get install python3-dev  # 필요한 경우 설치
```

### 2-3. 가상 환경 구성
다음 단계로, 프로젝트를 위한 Python 가상 환경을 구성합니다.  
가상 환경을 만들고자 하는 디렉토리에서 아래 명령어를 실행합니다.  
```bash
python -m venv venv
```

가상 환경 디렉토리(`venv`)가 생성되었다면, 아래 명령어로 가상 환경을 활성화 합니다.  
```bash
source venv/bin/activate      # Linux/macOS
source venv/Scripts/activate  # Windows
```

마지막으로 가상 환경이 활성화된 상태에서, 아래 명령어로 Django를 설치합니다.  
```bash
pip install django
```

## 3. Django 프로젝트 생성 및 실행
---
이제 Django 프로젝트를 생성하고, 로컬 서버가 정상적으로 실행되는지 확인해보겠습니다.  
먼저, 프로젝트를 위한 디렉토리(`project`)를 생성한 뒤 해당 디렉토리로 이동합니다.  
```bash
mkdir project
cd project
```

이제 `project` 디렉토리 안에서 아래 명령어를 실행하여 Django 프로젝트를 시작합니다.  
이 디렉토리는 프로젝트의 설정 및 구성을 담당하는 파일들을 모아둘 공간으로 활용할 예정이므로, 이름은 `conf`로 지정하였습니다.  
```bash
django-admin startproject conf .
```

이로써 Django 초기 프로젝트 구성이 완료되었습니다.  
이제 아래 명령어로 로컬 서버를 실행해봅니다.  
```bash
python manage.py runserver
```

브라우저에서 [http://localhost:8000](http://localhost:8000)에 접속하면 Django 기본 화면을 확인할 수 있습니다.  

![django_install_successfully](/assets/img/posts/framework/django_rest_framework/django_install_successfully.png)  

위와 같이 `The install worked successfully!` 메시지가 출력된다면, 프로젝트가 정상적으로 생성된 것입니다.  

## 마무리
---
이번 포스팅에서는 기본적인 Django 프로젝트의 구성과 실행 방법에 대해 알아보았습니다.  
아직 DRF는 직접적으로 사용하지 않았지만, 본격적인 DRF 개발을 위한 준비 단계라고 할 수 있습니다.  

다음 포스팅에서는 로컬 데이터베이스를 구성하고 Django 프로젝트와 연결하는 방법을 다룰 예정입니다.  
감사합니다.  
