---
title: "[Windows 11] WSL2 설치와 VSCode 연동"
date: 2025-04-04 03:34:00 +09:00
last_modified_at: 2025-04-04 03:34:00 +09:00
categories: [Server, Windows]
tags:
  [
    wsl,
    wsl2,
    vscode,
    windows,
    windows 11,
    linux,
    ubuntu,
    ubuntu 24.04,
    ubuntu 24.04 lts,
    wsl 설치,
    wsl2 설치,
    윈도우,
    윈도우 11,
    리눅스,
    우분투,
    우분투 24.04,
  ]
image: "/assets/img/title/server/windows/wsl_design.png"
---

이번 포스팅에서는 WSL2를 사용해 Windows 환경에 Linux 환경을 구축하는 방법을 소개합니다.  
포스팅은 Windows 11을 기준으로 작성되었습니다.  

## 1. Windows 기능 활성화
---
WSL 설치에 앞서, 몇 가지지 Windows 기능을 활성화야 합니다.  
`Windows 기능 켜기/끄기` 도구를 열고 아래 두 개의 기능을 활성화 합니다.  
* Linux용 Windows 하위 시스템
* Virtual Machine Platform

![windows_function](/assets/img/posts/server/windows/windows_function.png)  

Powershell(관리자 권한)과 커맨드를 사용하여 보다 간편한 활성화도 가능합니다.  
```bash
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Windows 기능 활성화 이후에는 **시스템을 재부팅하는 것을 추천드립니다.**  

## 2. WSL2 설치
---
Windows 11부터는 WSL 설치가 매우 간단해졌습니다.  
Powershell을 관리자 권한으로 열고, 아래 명령어를 순서대로 실행해주세요.  
```bash
wsl.exe --install
wsl.exe --update
wsl.exe --set-default-version 2
```

WSL 설치가 끝났다면, Linux 배포판을 설치할 차례입니다.  
설치 가능한 배포판 목록은 아래 명령어로 확인하실 수 있습니다.  
```bash
wsl.exe --list --online
```

실행 예시:  
```bash
다음은 설치할 수 있는 유효한 배포판 목록입니다.
'wsl.exe --install <Distro>'를 사용하여 설치합니다.

NAME                            FRIENDLY NAME
AlmaLinux-8                     AlmaLinux OS 8
AlmaLinux-9                     AlmaLinux OS 9
AlmaLinux-Kitten-10             AlmaLinux OS Kitten 10
Debian                          Debian GNU/Linux
SUSE-Linux-Enterprise-15-SP5    SUSE Linux Enterprise 15 SP5
SUSE-Linux-Enterprise-15-SP6    SUSE Linux Enterprise 15 SP6
Ubuntu                          Ubuntu
Ubuntu-24.04                    Ubuntu 24.04 LTS
kali-linux                      Kali Linux Rolling
openSUSE-Tumbleweed             openSUSE Tumbleweed
openSUSE-Leap-15.6              openSUSE Leap 15.6
Ubuntu-18.04                    Ubuntu 18.04 LTS
Ubuntu-20.04                    Ubuntu 20.04 LTS
Ubuntu-22.04                    Ubuntu 22.04 LTS
OracleLinux_7_9                 Oracle Linux 7.9
OracleLinux_8_7                 Oracle Linux 8.7
OracleLinux_9_1                 Oracle Linux 9.1
```

목록에서 원하는 배포판을 골랐다면, 아래와 같이 명령어를 입력해 설치를 진행합니다.  
아래는 Ubuntu 24.04 LTS 버전의 설치 예시입니다.  
```bash
wsl.exe --install Ubuntu-24.04
```

설치가 완료된 후, 간단한 계정 설정을 마치면 Linux 환경이 준비됩니다.  

## 3. WSL2 메모리 제한
---
기본 설정의 WSL2는 시스템 메모리를 동적적으로 할당받기 때문에, 과도하게 리소스를 점유할 수 있습니다.  
따라서, 이를 방지하기 위해 **WSL2 메모리 사용량을 제한하는 것을 추천드립니다.**  

먼저 Windows의 `C:\Users\<사용자명>` 디렉토리로 이동합니다.  
다음으로 `.wslconfig` 파일을 생성하고, 아래와 같은 내용을 채워넣습니다.  
```ini
[wsl2]
memory=16GB
swap=4GB
```

> 본인 컴퓨터 스펙에 알맞게 주 메모리와 스왑 메모리를 적절히 조절해주세요.  
{: .prompt-tip }

## 4. VSCode 연동
---
마지막으로, WSL2 환경을 VSCode와 연동하기 위해 아래의 Extension을 설치합니다.  
![vscode_wsl_extension](/assets/img/posts/server/windows/vscode_wsl_extension.png)  

Extension 설치가 완료되었다면, 좌측 하단의 버튼을 통해 WSL 연결을 시도합니다.  
![vscode_wsl_connection_1](/assets/img/posts/server/windows/vscode_wsl_connection_1.png)  

WSL에 잘 연결되었다면, 리눅스 시스템 상의 원하는 디렉토리를 자유롭게 열고 사용할 수 있습니다.  
![vscode_wsl_connection_2](/assets/img/posts/server/windows/vscode_wsl_connection_2.png)  

## 마무리
---
지금까지 WSL2 설치부터 환경 구성, 그리고 VSCode 연동까지의 과정을 정리해보았습니다.  
이번 글이 Windows에서도 손쉽게 Linux 개발 환경을 구축하고 활용하는 데 도움이 되었기를 바랍니다.  

읽어주셔서 감사합니다.  
