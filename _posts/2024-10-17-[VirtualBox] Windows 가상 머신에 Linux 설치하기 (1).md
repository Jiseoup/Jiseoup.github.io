---
title: "[VirtualBox] Windows 가상 머신에 Linux 설치하기 (1)"
date: 2024-10-17 22:43:00 +09:00
last_modified_at: 2024-10-17 22:43:00 +09:00
categories: [Tools, VirtualBox]
tags:
  [
    virtual machine,
    vm,
    windows,
    linux,
    ubuntu,
    macos,
    virtualbox,
    vmware,
    가상머신,
    윈도우,
    리눅스,
    우분투,
    맥os,
    버추얼박스,
    브이엠웨어,
  ]
---

가상머신(Virtual Machine, VM)은 하나의 운영체제에서 다른 운영체제를 동시에 실행할 수 있는 유용한 도구입니다. 이를 통해 윈도우 환경에서 리눅스, macOS 등을 실행하거나, 반대로 리눅스 등 다른 운영체제에서 윈도우를 실행할 수 있습니다.  

대표적인 가상머신 소프트웨어로는 **VirtualBox**와 **VMware**가 있습니다.  
1. VirtualBox (완전 무료) - [https://www.virtualbox.org/](https://www.virtualbox.org)
2. VMware (상업용 유료/비상업용 무료) - [https://www.vmware.com/](https://www.vmware.com)

필자는 과거 VMware를 애용했으나, 회사가 인수되며 생긴 여러가지 불편사항과, 라이선스에 대한 불안감으로  
이제는 VirtualBox를 사용하고자 합니다.  


## 1. VirtualBox 다운로드
---
VirtualBox는 오픈소스 소프트웨어답게 매우 간편한 다운로드를 제공합니다.  
먼저, [다운로드 페이지](https://www.virtualbox.org/wiki/Downloads)에 접속후, 자신이 현재 사용중인 운영체제에 알맞은 패키지를 다운로드 합니다.  

![download](https://github.com/user-attachments/assets/dc1147f6-c24c-4fa8-9e9a-45942bd96756)  

필자는 윈도우를 사용하고 있기 때문에, 윈도우 패키지 기반으로 설명을 이어가겠습니다.  


## 2. VirtualBox 설치
---
설치는 거의 Next 버튼만 누르면 끝나는 수준이라, 중요한 부분만 캡쳐해서 업로드하도록 하겠습니다.  

![install-1](https://github.com/user-attachments/assets/0c6e7e5f-3cf6-4dd0-b018-0d0555ae3d0b)  

설치 경로 설정 및 함께 설치할 패키지를 선택하는 화면입니다.  
딱히 건들지 않고 넘기도록 하겠습니다.  

![install-2](https://github.com/user-attachments/assets/cee2a0f5-2dbd-4279-9bdc-7b476a3b0723)  

일시적으로 네트워크가 끊길 수 있다는 경고인데, 그냥 넘기셔도 무방합니다.  

![install-3](https://github.com/user-attachments/assets/77abc25f-55d9-4fb5-9347-5e1f266a1ce2)  

Python으로 VirtualBox를 제어하실 분이 아니라면, 무시하고 넘기셔도 좋습니다.  
경고가 불편하시다면 Python과 win32api를 설치하시면 됩니다.  

![install-4](https://github.com/user-attachments/assets/e13d7803-c1dc-477c-957b-60adb57142ad)  

설치를 진행하시다가, 이렇게 Finish 버튼이 나타나면 VirtualBox가 설치 완료 됩니다.  

![virtualbox](https://github.com/user-attachments/assets/eed9fc2e-5dac-464c-8d07-e00782349cf5)  

## 마무리
---
다음 포스팅에서는 VirtualBox에 Linux 환경을 구성하는 방법에 대해 알아보도록 하겠습니다.  

감사합니다.  

#### **다음 포스팅**  
> [[VirtualBox] Windows 가상 머신에 Linux 설치하기 (2)](https://devpro.kr/posts/VirtualBox-Windows-%EA%B0%80%EC%83%81-%EB%A8%B8%EC%8B%A0%EC%97%90-Linux-%EC%84%A4%EC%B9%98%ED%95%98%EA%B8%B0-(2)/)  
