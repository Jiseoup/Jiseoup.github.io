---
title: LF will be replaced by CRLF 경고 해결
date: 2023-04-11 01:37:00 +09:00
categories: [git, warning]
tags:
  [
    git,
    github,
    git warning,
    git warning message,
    git 경고,
    git 경고 메시지,
    LF,
    CRLF,
    LF will be replaced by CRLF,
  ]
---

모든 작업을 마치고 git으로 저장소에 파일을 업로드하려고 하는데... 어랏?  
**`git add`** 명령어 도중에 아래와 같은 경고 메시지가 발생했습니다!  
```shell
warning: in the working copy of 'mypage.html', 
LF will be replaced by CRLF the next time Git touches it
```

이 경고 메시지는 git이 파일을 업데이트 할 때, **LF(Line Feed)** 줄바꿈 문자가  
**CRLF(Carriage Return Line Feed)** 줄바꿈 문자로 대체될 것임을 나타내는 경고입니다.  

주로 Windows 운영체제에서 나타나는 경고인데요, 아주 간단하게 해결 할 수 있습니다!  
바로 git이 **CRLF** 대신 **LF**를 사용하도록 강제로 설정을 변경해주는 것 입니다.  

아래의 명령어을 적용 후, 다시 **`git add`**를 수행하면 문제없이 파일 업로드를 수행할 수 있습니다.
```shell
$ git config --global core.autocrlf true
```

감사합니다!