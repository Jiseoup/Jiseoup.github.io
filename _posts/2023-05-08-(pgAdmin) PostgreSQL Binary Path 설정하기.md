---
title: (pgAdmin) PostgreSQL Binary Path 설정하기
date: 2023-05-08 23:51:00 +09:00
categories: [database, postgresql]
tags:
  [
    database,
    postgresql,
    psql,
    db,
    rdb,
    rdbms,
    dbms,
    postgres,
    pgadmin,
    포스트그레스,
    포스트그레에스큐엘,
    포스트그레스큐엘,
    포스그레,
    데이터베이스,
    디비,
    관계형데이터베이스,
    관계형디비,
  ]
---

pgAdmin에서 **`Please configure the PostgreSQL Binary Path in the Preferences dialog.`** 에러가 발생했을 때, PostgreSQL Binary Path를 설정하는 방법을 알아보겠습니다.  

![image](https://user-images.githubusercontent.com/104547731/236857575-6c830620-f520-48bd-a1e5-2110d1a90433.png)  

먼저 **`File - Preferences`**로 들어가줍니다.  

![image](https://user-images.githubusercontent.com/104547731/236858297-b36b24ee-5c26-48e1-bdd1-d19a509f2486.png)  

다음으로 **`Paths - Binary paths`**로 들어가 **PostgreSQL Binary Path** 부분에 자신의 PostgreSQL 버전에 알맞는 경로를 설정해주고, 체크 박스를 선택한 후에 Save 버튼을 누릅니다. 저는 15 버전을 사용하고 있어서 15 버전 Path를 설정해주었습니다.  

PostgreSQL을 기본 경로로 설치하셨다면, ***`C:\Program Files\PostgreSQL\{$version}\bin`*** 디렉토리로 설정해주시면 됩니다.  

![image](https://user-images.githubusercontent.com/104547731/236860742-54aad2b6-2768-40d4-aa15-8a46bc21963c.png)  

위의 간단한 과정을 끝내고 나면, pgAdmin에 있는 psql 등의 기능에 접근이 가능해집니다.  
감사합니다.