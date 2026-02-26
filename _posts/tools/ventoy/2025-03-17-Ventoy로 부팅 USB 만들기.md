---
title: "Ventoy로 부팅 USB 만들기"
slug: ventoy-bootable-usb
date: 2025-03-17 17:16:00 +09:00
last_modified_at: 2025-03-17 17:16:00 +09:00
categories: [Tools, Ventoy]
tags: [ventoy, setup]
image: "/assets/img/title/tools/ventoy/logo.png"
---

오늘은 Windows 10, Windows 11, Ubuntu 24.04 등, **여러 운영체제를 하나의 부팅 USB에서 설치할 수 있는 방법**에 대해 이야기해보려고 합니다. 사용할 프로그램은 **`Ventoy`** 라는 프로그램으로, 아주 간편하게 부팅 USB를 만들 수 있도록 도와줍니다.  

## 1. Ventoy 다운로드
---
먼저 [Ventoy 다운로드 사이트](https://www.ventoy.net/en/download.html)로 이동하여 설치 파일을 다운로드 합니다.  

![ventoy_download](/assets/img/posts/tools/ventoy/ventoy_download.png)  

운영체제에 알맞는 압축 파일을 선택하여 다운로드 후 압축 해제 해주시면 됩니다.  

## 2. Ventoy 설치
---
압축 파일을 해제하면 다음과 같은 파일들이 포함되어 있습니다.  

![ventoy_directory_1](/assets/img/posts/tools/ventoy/ventoy_directory_1.png)  

이제 부팅 USB로 만들 디바이스를 연결하고, `Ventoy2Disk.exe` 파일을 실행합니다.  
이후 Device 항목에서 Ventoy를 설치하고자 하는 USB를 선택하고, Install 버튼을 눌러주시면 설치가 진행됩니다.  

> 설치를 진행할 경우 USB 디바이스가 완전히 초기화 됩니다.
{: .prompt-warning }

![ventoy_install](/assets/img/posts/tools/ventoy/ventoy_install.png)  

설치가 완료되면 Ventoy In Device 부분에 버전 정보가 표시됩니다.  

## 3. ISO 파일 업로드
---
Ventoy가 설치된 USB 디바이스는 이름이 Ventoy로 변경됩니다.  

![ventoy_directory_2](/assets/img/posts/tools/ventoy/ventoy_directory_2.png)  

마지막으로, 준비한 ISO 파일을 USB에 그대로 넣어주기만 하면 모든 과정이 끝이 납니다.  

![ventoy_directory_3](/assets/img/posts/tools/ventoy/ventoy_directory_3.png)  

이제 USB를 부팅하면 아래와 같이 업로드한 ISO 파일의 목록이 나오고, 원하는 운영체제를 선택하여 설치할 수 있습니다.  

![ventoy_boot](/assets/img/posts/tools/ventoy/ventoy_boot.png)  

## 마무리
---
부팅 USB는 한번 만들어놓으면 굉장히 유용하게 사용됩니다.  
이번 포스팅을 참고하여 직접 부팅 USB를 만들어 활용해 보시는 것을 추천드립니다.  

감사합니다.  
