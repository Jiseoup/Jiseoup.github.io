---
title: "[PyPI] Python pip 패키지 만들기"
date: 2024-12-02 23:02:00 +09:00
last_modified_at: 2024-12-02 23:02:00 +09:00
categories: [Programming, Python]
tags:
  [
    python,
    pypi,
    python package index,
    python package,
    python module,
    pip,
    pip module,
    pip package,
    pip install,
    module,
    library,
    package,
    파이썬,
    파이썬 패키지,
    파이썬 모듈,
    모듈,
    라이브러리,
    패키지,
  ]
image: "/assets/img/title/pypi_logo_designed.png"
---

모두들 Python 개발을 하면서 `pip install`을 통해 패키지를 설치하고 사용한 경험이 있으실 겁니다.  
오늘은 이러한 Python 패키지를 직접 만들고, 전 세계적으로 배포할 수 있는 방법에 대해 알아보겠습니다.  

## 1. PyPI 회원 가입
---
PyPI(Python Package Index)는 Python 패키지를 공유하고, 관리할 수 있는 패키지 저장소 입니다.  
Python 프로젝트를 패키지로 배포하기 위해서는, 먼저 [PyPI 사이트](https://pypi.org)에 회원 가입을 해야합니다.  
회원 가입 과정은 굉장히 쉬우니 넘기도록 하겠습니다.  

## 2. 패키지 배포를 위한 의존성 설치
---
손수 만든 Python 프로젝트를 배포하기 위한 몇가지 의존성 패키지가 존재합니다.  
이후 손쉽게 배포하기 위해, 먼저 의존성을 설치해 줍니다.  
```bash
pip install setuptools
pip install wheel
pip install twine
```

## 3. 프로젝트 구성
---
### 3-1. 디렉토리 구성
프로젝트는 기본적으로 아래와 같은 형태로 구성합니다.  
```bash
project/
├── package/
│   ├── __init__.py
│   └── module.py
├── README.md
└── setup.py
```

|Name|Description|
|------|------|
|project|프로젝트 root 디렉토리 입니다.|
|package|프로젝트의 핵심 디렉토리 입니다. 일반적으로 패키지의 이름과 동일하게 지정합니다.|
|\__init__.py|패키지를 모듈로 인식하게 만드는 파일입니다. 패키지가 import될 때 실행됩니다.|
|module.py|패키지에서 제공하는 기능들이 정의된 Python 모듈 파일입니다. <br> 여러 개의 모듈로 구성할 수도 있으며, 기능별로 파일을 나눌 수 있습니다.|
|README.md|프로젝트의 설명 파일입니다.|
|setup.py|PIP 배포를 위한 설정 파일입니다.|

이제부터는 프로젝트의 핵심 파일을 구성하는 방법에 대해 본격적으로 알아보겠습니다.  

### 3-2. module.py
먼저 모듈 파일부터 구성해보도록 하겠습니다.  
모듈 파일에는 패키지로 만들고자 하는 기능이 담긴 함수를 정의해주시면 됩니다.  
> 파일명은 원하는대로 수정해주세요.
{: .prompt-tip }

아래는 `module.py` 파일에 두 수의 합을 반환하는 모듈을 작성한 예시입니다.
```python
def sum(a: int, b: int) -> int:
  return a + b
```

### 3-3. \__init__.py
다음으로 `__init__.py` 파일을 작성해보도록 하겠습니다.  
해당 파일에서는 배포하고자 하는 모듈 파일의 함수를 import 하고, 버전 정보등을 작성합니다.  
```python
from .module import sum

__all__ = ['sum'] # 패키지로 배포할 함수명 작성

__version__ = '0.0.1' # 권장 선택사항
__author__ = 'author name' # 선택사항
__email__ = 'author email' # 선택사항
```

### 3-4. setup.py
마지막으로 패키지 배포에 있어, 가장 중요한 `setup.py` 파일을 작성합니다.  
```python
from setuptools import setup

# README.md 파일을 불러오는 기능
with open('README.md', encoding='utf-8') as f:
  long_description = f.read()

setup(
  name='project', # 등록할 패키지 이름 (PyPI에 등록되는 이름)
  version='0.0.1', # 패키지 버전
  description='This is my Python Package.', # 패키지의 짧은 설명
  long_description=long_description, # 패키지의 상세 설명
  long_description_content_type = 'text/markdown', # long_description의 형식
  author='author name', # 패키지 작성자 이름
  author_email='author email', # 패키지 작성자 이메일
  url='https://example.com', # 프로젝트의 공식 URL
  license='MIT', # 패키지의 라이선스 정보
  python_requires='>=3.7', # 패키지가 지원하는 Python 버전
  install_requires=[], # 패키지가 의존하는 외부 라이브러리 목록
  packages=['package'], # 포함할 Python 패키지 목록
  package_data={}, # 패키지에 포함할 추가 데이터 목록
  keywords=[], # 패키지 검색 키워드
  classifiers=[
    'Development Status :: 4 - Beta',
    'Intended Audience :: Developers',
    'Programming Language :: Python :: 3',
    'Operating System :: OS Independent',
    'License :: OSI Approved :: MIT License',
  ] # 패키지 분류
)
```

대부분의 파라미터는 선택사항이지만, license 정보를 제외하고는 모두 작성하는것을 권장합니다.  

> Classifiers의 자세한 정보는 [PyPI Classifiers](https://pypi.org/classifiers/)를 참고하시길 바랍니다.
{: .prompt-info }

## 4. 패키지 배포
---
모든 준비가 끝났다면, 이제 패키지를 배포할 시간입니다.  
프로젝트의 root 디렉토리로 이동하여 아래 명령어를 실행해 줍니다.  
```bash
python setup.py bdist_wheel
```

명령어를 실행하면 프로젝트를 패키지화한 파일들이 생성됩니다.  
이를 아래 명령어를 통해 PyPI로 배포해보도록 하겠습니다.  
```bash
python -m twine upload dist/{배포할 패키지 파일}
```

명령어를 실행하면 아래와 같이 API 토큰을 입력하라고 합니다.  
API 토큰은 PyPI 사이트에 로그인한 후, `Account settings`에서 발급받을 수 있습니다.  
```bash
Uploading distributions to https://upload.pypi.org/legacy/
Enter your API token: 
```
이후 올바른 API 토큰을 입력하면 배포가 시작되고, 패키지가 등록됩니다.  

## 마무리
---
이번 포스팅에서는 Python 패키지를 만들고 배포하는 방법에 대해 알아보았습니다.  
만약 패키지에 새로운 기능을 추가하거나 버그를 수정하게 된다면, 버전을 업데이트하여 다시 배포하면 됩니다.  

제가 간단한 패키지를 배포한 코드를 참고하시고 싶다면, [하이퍼링크](https://github.com/Jiseoup/iso-container)를 확인해주시길 바랍니다.  

긴 글 읽어주셔서 감사합니다.  
