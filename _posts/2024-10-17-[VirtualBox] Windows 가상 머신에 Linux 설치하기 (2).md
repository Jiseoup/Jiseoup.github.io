---
title: "[VirtualBox] Windows 가상 머신에 Linux 설치하기 (2)"
date: 2024-10-17 23:32:00 +09:00
last_modified_at: 2024-10-17 23:32:00 +09:00
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
image: "/assets/img/title/virtualbox_logo_white.png"
---

> 이번 포스팅에서는 VirtualBox에 Linux 환경을 구성하는 방법에 대해 알아보겠습니다.  
> VirtualBox 설치를 완료하지 않은 분든을 이전 포스팅을 확인해주세요.  
> > [[VirtualBox] Windows 가상 머신에 Linux 설치하기 (1)](https://devpro.kr/posts/VirtualBox-Windows-%EA%B0%80%EC%83%81-%EB%A8%B8%EC%8B%A0%EC%97%90-Linux-%EC%84%A4%EC%B9%98%ED%95%98%EA%B8%B0-(1)/)  


## 1. Ubuntu ISO 이미지 다운로드
---
본 포스팅에서는 Linux 계열 운영 체제 중 하나인 Ubuntu를 가상 머신에 설치해보는 과정을 가지고자 합니다.  
현재 시점에서 가장 최신 버전인 Ubuntu 24.04.1 LTS의 ISO 이미지 파일을 다운로드 해보겠습니다.  

[***Ubuntu 다운로드 링크***](https://ubuntu.com/download/desktop#)  

![download_ubuntu_iso_1](/assets/img/posts/tools/virtualbox/download_ubuntu_iso_1.png)  

`Download 24.04.1 LTS` 버튼을 클릭하면 아래 페이지로 이동하는데, Subscribe 안하셔도 알아서 다운로드 됩니다.  

![download_ubuntu_iso_2](/assets/img/posts/tools/virtualbox/download_ubuntu_iso_2.png)  


## 2. 가상 머신 생성 및 설정
---
이제 VirtualBox를 실행하고 새로운 가상 머신을 생성해보겠습니다.  
가상 머신 설정은 이후 수정이 가능하므로, 잘 모르시겠다면 기본값으로 사용하시는 것을 추천합니다.  

![vbox_settings_1](/assets/img/posts/tools/virtualbox/vbox_settings_1.png)  

먼저, 새로 만들기 버튼을 클릭하여 새로운 가상 머신을 생성합니다.  

![vbox_settings_2](/assets/img/posts/tools/virtualbox/vbox_settings_2.png)  

가상 머신의 이름, VM 파일 저장 경로를 자유롭게 설정하고 다운로드한 ISO 이미지를 선택해주세요.  

![vbox_settings_3](/assets/img/posts/tools/virtualbox/vbox_settings_3.png)  

가상 머신을 완전히 개인적으로 사용할 것이기 때문에, 무인 게스트 OS 설치는 적당히 넘겨줍니다.  

![vbox_settings_4](/assets/img/posts/tools/virtualbox/vbox_settings_4.png)  

하드웨어 또한 적당히 설정해주시면 됩니다.  
저는 기본값 보다 약간 늘려 4GB RAM에 2vCPU로 설정하였습니다.  

![vbox_settings_5](/assets/img/posts/tools/virtualbox/vbox_settings_5.png)  

가볍게 사용할 VM이기 때문에, 하드 디스크는 기본 값으로 설정합니다.  

![vbox_settings_6](/assets/img/posts/tools/virtualbox/vbox_settings_6.png)  

마지막으로, 전체 설정 정보와 함께 가상 머신 생성을 완료할 수 있습니다.  


## 3. 가상 머신에 Ubuntu 설치
---
이제 본격적으로 생성한 가상 머신을 시작하고, Ubuntu를 설치하는 과정을 가져보겠습니다.  
가상 머신 생성을 완료하면 자동으로 실행이 되며, 아래와 같은 화면을 확인하실 수 있습니다.  
만약 자동으로 실행되지 않는다면, 메인 화면에서 가상 머신을 선택하고 시작 버튼을 눌러주세요.  

![install_ubuntu_vbox_1](/assets/img/posts/tools/virtualbox/install_ubuntu_vbox_1.png)  

아마 자동으로 넘어가게 될텐데, 넘어가지 않는다면 `Try or Install Ubuntu` 선택해주시면 됩니다.  

![install_ubuntu_vbox_2](/assets/img/posts/tools/virtualbox/install_ubuntu_vbox_2.png)  

처음 VM 부팅이 완료되면, 위 사진과 같은 화면을 마주하실 수 있습니다.  
사진에는 나오지 않았지만, `Install Ubuntu`와 같은 버튼을 통해 자동 설치를 진행해주시면 됩니다.  

![install_ubuntu_vbox_3](/assets/img/posts/tools/virtualbox/install_ubuntu_vbox_3.png)  

설치가 완료되면 VM 설정 때, 생성한 유저 패스워드를 통해 로그인이 가능합니다.  

![install_ubuntu_vbox_4](/assets/img/posts/tools/virtualbox/install_ubuntu_vbox_4.png)  

자, 이렇게 간단하게 Ubuntu 설치가 완료되었습니다.  
이제 Windows 환경에서도 VM을 사용하여 Ubuntu의 사용이 가능합니다.  

## 마무리
---
이번 포스팅을 통해 가상 머신 VirtualBox 설치 방법과, VM 생성, Ubuntu를 설치하는 과정까지 알아보았습니다.  
가상 머신을 통해, 서로 다른 OS 환경을 하나의 PC에서 간편하게 사용할 수 있다는 점이 참 좋은 것 같습니다.  

모두 자신에게 알맞는 VM 환경을 구축하고, 유용하게 사용하실 수 있는 기회가 되었다면 좋겠습니다.  

지금까지 긴 글 읽어주셔서 감사합니다.  
