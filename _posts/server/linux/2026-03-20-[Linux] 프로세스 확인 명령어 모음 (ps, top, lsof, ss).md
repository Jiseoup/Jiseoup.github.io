---
title: "[Linux] 프로세스 확인 명령어 모음 (ps, top, lsof, ss)"
slug: linux-process-check
date: 2026-03-20 12:18:00 +09:00
last_modified_at: 2026-03-20 12:18:00 +09:00
categories: [Server, Linux]
tags: [linux, command, process]
image: "/assets/img/title/server/linux/logo_designed_4.png"
---

리눅스 서버를 운영하다 보면 현재 실행 중인 프로세스를 확인해야 하는 상황이 자주 발생합니다.  
이번 포스팅에서는 프로세스를 확인하는 명령어들을 용도별로 정리해보겠습니다.  

> 프로세스 종료 방법은 [[Linux] 프로세스 종료 명령어 모음 (kill, pkill, fuser)](/posts/linux-process-kill/) 포스팅을 참고해주세요.  
{: .prompt-info }

## 1. 프로세스 직접 조회
---
아래는 프로세스 이름이나 PID를 기준으로 직접 확인하는 명령어들입니다.  

### 1-1. ps
`ps`(Process Status)는 현재 실행 중인 프로세스의 스냅샷을 출력하는 명령어입니다.  
```bash
$ ps [옵션]
```

다음은 `ps` 명령어의 주요 옵션입니다.  

|Option|Description|
|---|------|
|-e|시스템의 모든 프로세스를 출력|
|-f|PID, PPID, 시작 시간 등의 상세 정보를 출력|
|-u|특정 사용자의 프로세스를 출력|
|aux|모든 사용자의 프로세스를 상세 정보와 함께 출력|

아래는 가장 많이 사용되는 조합으로, 모든 프로세스를 상세하게 출력합니다.  
```bash
$ ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1 169600 13312 ?        Ss   09:00   0:01 /sbin/init
ubuntu    1023  0.2  0.8 225600 65536 ?        S    09:03   0:05 python3 app.py
www-data  1234  0.5  1.2 512340 102400 ?       S    09:05   0:10 nginx: worker process
```

특정 프로세스를 이름으로 필터링할 때는 `grep`과 조합하여 사용합니다.
```bash
$ ps aux | grep nginx
www-data  1234  0.5  1.2 512340 102400 ?       S    09:05   0:10 nginx: worker process
```

### 1-2. pgrep
`pgrep`은 프로세스 이름을 기반으로 PID만 빠르게 조회하는 명령어입니다.  
`ps | grep` 조합보다 간결하게 사용할 수 있습니다.  
```bash
$ pgrep [프로세스 이름]
```

아래는 `nginx` 프로세스의 PID를 조회하는 예시입니다.  
```bash
$ pgrep nginx
1234
5678
```

`-l` 옵션을 사용하면 PID와 함께 프로세스 이름도 출력됩니다.  
```bash
$ pgrep -l nginx
1234 nginx
5678 nginx
```

### 1-3. top
`top`은 실시간으로 시스템의 프로세스 현황과 리소스 사용량을 모니터링하는 명령어입니다.  
```bash
$ top
```

CPU, 메모리 사용률이 높은 프로세스를 찾을 때 유용하며, `q`를 누르면 종료됩니다.  

> `top`의 개선된 버전으로 `htop`이 있으며, 더 직관적인 UI와 마우스 인터랙션을 지원합니다.  
> `sudo apt install htop` 명령어로 설치할 수 있습니다.  
{: .prompt-tip }

## 2. 포트 기반 프로세스 조회
---
특정 포트를 사용 중인 프로세스를 확인해야 하는 경우, 아래 명령어들을 활용할 수 있습니다.  

### 2-1. lsof
`lsof`(List Open Files)는 현재 열려 있는 파일 및 네트워크 소켓 정보를 출력하는 명령어입니다.  
리눅스에서는 네트워크 소켓도 파일로 취급되기 때문에, 포트를 점유한 프로세스를 찾는 데 유용하게 활용됩니다.  

```bash
$ lsof -i :[포트번호]
```

아래는 8000번 포트를 사용 중인 프로세스를 조회하는 예시입니다.  

```bash
$ lsof -i :8000
COMMAND   PID   USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
python3  1234  ubuntu   3u  IPv4  12345      0t0  TCP *:8000 (LISTEN)
```

출력 결과에서 `PID` 컬럼의 값이 해당 포트를 점유한 프로세스의 ID입니다.  

> 다른 사용자가 실행한 프로세스는 권한 없이 조회되지 않으므로, `sudo` 권한으로 실행해야 합니다.  
{: .prompt-warning }

> `lsof`가 설치되어 있지 않다면 `sudo apt install lsof` 명령어로 설치할 수 있습니다.  
{: .prompt-tip }

### 2-2. ss
`ss`(Socket Statistics)는 네트워크 소켓 정보를 조회하는 명령어로, 기존의 `netstat`을 대체하는 최신 도구입니다.  
```bash
$ ss -tulnp | grep [포트번호]
```

다음은 `ss` 명령어의 주요 옵션입니다.  

|Option|Description|
|---|------|
|-t|TCP 소켓 정보 출력|
|-u|UDP 소켓 정보 출력|
|-l|현재 LISTEN 상태인 소켓만 출력|
|-n|호스트명, 포트명을 숫자로 출력|
|-p|소켓을 사용 중인 프로세스 정보 출력|

아래는 8000번 포트를 사용 중인 프로세스를 조회하는 예시입니다.  
```bash
$ ss -tulnp | grep 8000
tcp   LISTEN 0  5  0.0.0.0:8000  0.0.0.0:*  users:(("python3",pid=1234,fd=3))
```

### 2-3. netstat
`netstat`은 네트워크 연결 상태 및 소켓 정보를 출력하는 명령어입니다.  
`ss`와 유사한 역할을 하며, 오래된 환경이나 익숙한 도구를 선호하는 경우에 사용합니다.  

```bash
$ netstat -tulnp | grep [포트번호]
```

아래는 8000번 포트를 사용 중인 프로세스를 조회하는 예시입니다.

```bash
$ netstat -tulnp | grep 8000
tcp  0  0  0.0.0.0:8000  0.0.0.0:*  LISTEN  1234/python3
```

> 최신 리눅스 배포판에서는 `netstat`이 기본으로 포함되지 않을 수 있습니다.  
> `sudo apt install net-tools` 명령어로 설치할 수 있습니다.  
{: .prompt-tip }

## 3. 명령어 비교
---

|명령어|용도|특징|
|---|---|------|
|ps|프로세스 전체 조회|스냅샷 방식, `grep`과 조합하여 필터링|
|pgrep|이름으로 PID 조회|간결하고 빠름|
|top|실시간 모니터링|CPU, 메모리 기준 정렬|
|lsof|포트 기반 프로세스 조회|PID, 사용자 등 상세 정보 출력|
|ss|포트/소켓 정보 조회|`netstat`의 최신 대체 도구|
|netstat|포트/소켓 정보 조회|레거시 환경에서 사용|
