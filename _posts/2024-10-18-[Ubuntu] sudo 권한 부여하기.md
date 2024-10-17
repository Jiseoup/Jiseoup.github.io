---
title: "[Ubuntu] sudo 권한 부여하기"
date: 2024-10-18 00:03:00 +09:00
last_modified_at: 2024-10-18 00:03:00 +09:00
categories: [Linux, Ubuntu]
tags:
  [
    linux,
    ubuntu,
    cli,
    command,
    command line,
    sudo,
    superuser,
    permission,
    리눅스,
    우분투,
    커맨드,
    명령어,
    수도,
    수도권한,
    슈퍼유저,
    퍼미션,
    권한,
  ]
---

Ubuntu에서 유저에게 sudo 권한을 부여하는 방법은 매우 간단합니다.  
> *sudo 권한을 부여하기 위해서는, 먼저 sudo 권한이 있는 계정으로의 접근이 필요합니다.*  

### 1. sudo 권한 부여
유저를 sudo 그룹에 추가하여 sudo 권한을 부여합니다.  
```shell
$ sudo usermod -aG sudo {$user}
```

### 2. 유저 권한 확인 방법
유저가 속한 그룹을 확인하여, sudo 그룹이 포함되어있는지 확인합니다.  
```shell
$ groups {$user}
```

감사합니다.  
