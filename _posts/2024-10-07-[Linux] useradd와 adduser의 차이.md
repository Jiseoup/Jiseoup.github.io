---
title: "[Linux] useradd와 adduser의 차이"
date: 2024-10-07 23:32:00 +09:00
last_modified_at: 2024-10-07 23:32:00 +09:00
categories: [Linux, Ubuntu]
tags:
  [
    linux,
    ubuntu,
    cli,
    command,
    command line,
    adduser,
    useradd,
    리눅스,
    우분투,
    커맨드,
    명령어,
    우분투 유저 생성,
  ]
---

매우 유사해 보이지만, 서로 다른 기능을 제공하는 useradd와 adduser 명령어에 대해 알아보겠습니다.  
들어가기 앞서, 필자는 **Ubuntu**를 기본 환경으로 사용합니다.  

간단히 결론부터 말씀드리자면 두 가지 기능의 큰 차이는 아래와 같습니다.  

|useradd|사용자의 홈 디렉토리를 자동으로 생성하지 않는다.|
|adduser|사용자의 홈 디렉토리를 자동으로 생성한다.|

## 1. useradd
---
useradd는 저수준 명령어로, 사용자를 추가하는 최소한의 작업만 수행합니다.  
사용자를 추가할 때 필요한 모든 옵션을 수동으로 명시해야만 합니다.
```shell
$ useradd [사용자 이름]
```
아래 사진과 같이, useradd는 다른 옵션을 명시하지 않은 경우, 그저 사용자만 추가하는 모습을 볼 수 있습니다.  

<p align="center" style="color:gray">
  <img src="https://github.com/user-attachments/assets/942ee5c5-72f2-442d-b912-5a59c9abeb8c" alt="useradd_1" />
  옵션 없이 useradd 명령어 수행
</p>

<p align="center" style="color:gray">
  <img src="https://github.com/user-attachments/assets/c0bc52f9-c040-44ec-b41e-654e9c2a93d8" alt="useradd_2" />
  홈 디렉토리가 존재하지 않는 모습
</p>

ℹ️ useradd 옵션에 대한 자세한 설명은 `useradd -h` 명령어를 통해 확인할 수 있습니다.  

## 2. adduser
---
adduser는 useradd 명령어를 기반으로 한 Perl 스크립트 입니다.  
별다른 옵션 없이 명령어를 수행하더라도 홈 디렉토리 생성, 암호 설정 등의 기능을 기본으로 제공합니다.  
```shell
$ adduser [사용자 이름]
```
아래 사진과 같이, adduser는 별다른 옵션 없이 사용자 생성 및 다른 여러가지 기능을 제공합니다.  

<p align="center" style="color:gray">
  <img src="https://github.com/user-attachments/assets/ca0c66a1-4ce3-41cd-88fb-8041184d0da8" alt="adduser_1" />
  adduser 명령어 실행과 함께 제공되는 인터페이스
</p>

<p align="center" style="color:gray">
  <img src="https://github.com/user-attachments/assets/77d20f4c-42c3-4955-9e49-aadab3dd3e9a" alt="adduser_2" />
  홈 디렉토리가 존재하는 모습
</p>

## 마무리
---
사용자에 대해 심도있는 설정이 필요한 경우에는 useradd를 사용하는 것이 유리할 수 있습니다.  
하지만, 간단한 방법으로는 adduser를 사용하는 것이 편리하며, 필자도 해당 명령어를 애용하고 있습니다.  
감사합니다.  
