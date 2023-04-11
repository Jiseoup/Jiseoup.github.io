---
title: PostgreSQL의 장점 소개 및 설치
date: 2023-04-11 10:06:00 +09:00
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
    포스트그레스,
    포스트그레에스큐엘,
    포스트그레스큐엘,
    포스그레,
    데이터베이스,
    디비,
    관계형데이터베이스,
    관계형디비,
    라이선스,
    Postgresql Licensce,
    Postgresql 라이선스,
  ]
---

![postgresql](https://user-images.githubusercontent.com/104547731/231174985-833349e1-6e53-4963-aec9-0309e0c74cc7.png)  
오늘은 관계형 데이터베이스(RDBMS)의 선두 주자 **Postgresql**의 **장점**과 **설치 방법**에 대해 알아보겠습니다.  

**Postgresql**은 RDBMS의 **여러가지 기능을 제공**함과 동시에 **성능도 우수**하며,  
데이터베이스 트랜잭션의 **ACID 속성도 모두 준수**하는 매우 강력한 **오픈소스 데이터베이스**입니다.  

많은것을 제공하면서도, 오픈소스로 제공하기 때문에 **무료로 상업적/비상업적인 사용이 가능**하다는 것이 매우 큰 강점입니다. 
라이선스는 자체적으로 만든 ***`PostgreSQL License`***를 사용하고 있으며, 이는 ***`BSD`***, ***`MIT`*** 라이선스와 비슷한 형태를 띄고있기에, 더욱 편안하게 사용할 수 있습니다.  

아래는 2023년도 4월에 수집한 데이터베이스 엔진의 순위입니다.  
> 출처: [DB-Engines Ranking](https://db-engines.com/en/ranking)
> ![chart](https://user-images.githubusercontent.com/104547731/231175579-f8201cbb-fa4a-4ce5-922d-1db8196313a7.png)  

## 1. PostgreSQL 다운로드
---
이제 본격적으로 설치에 앞서, PostgreSQL을 다운로드 해보도록 하겠습니다.  
설치 방법은 Windows 환경 기준으로 소개합니다.  

다운로는 [PostgreSQL 공식 사이트](https://www.postgresql.org/)에서 진행할 수 있습니다.  
Download 버튼을 클릭하여 아래 페이지로 이동해 줍니다.  
![download](https://user-images.githubusercontent.com/104547731/231184283-87cbbb3a-2520-495f-9b88-5b2ef6584fff.png)  
저희는 Windows 환경에서 다운로드할 것이기 때문에, 당연하게 Windows를 선택하여 다음 화면으로 넘어갑니다.  

![download2](https://user-images.githubusercontent.com/104547731/231184833-d58eb4a1-dc59-4ff0-ba5d-026652fea5e9.png)  
맨 상단의 Download the installer를 선택하여 다운로드 페이지로 이동합니다.  

![download3](https://user-images.githubusercontent.com/104547731/231185440-1537bef6-df45-4d8c-8f82-978889964897.png)  
위 페이지에는 현재 PostgreSQL에 대한 **Stable Version**들이 나열됩니다.  
현 시점에서 가장 **최신 버전인 15.2 버전의 Windows x86-64를 선택하여 다운로드** 합니다.  

## 2. PostgreSQL 설치
---
다운로드가 완료되었다면, ***`postgresql-15.2-2-windows-x64.exe`*** 파일을 실행하여 설치를 진행합니다.  

![path](https://user-images.githubusercontent.com/104547731/231187764-e05c4ea7-b9d1-4e73-b62c-bb113524147f.png)  

초기 화면에서 Next를 누르고 나면, 설치 경로를 지정하는 설정이 나옵니다. 건들지 않고 넘어가도록 하겠습니다.  

![tools](https://user-images.githubusercontent.com/104547731/231189171-cb8df95a-ce0b-4ea2-bedb-d820a9084594.png)  

다음으로 PostgreSQL과 함께 설치할 도구를 선택해봅시다. 각 도구의 설명은 다음과 같습니다.
* **PostgreSQL Server**  
  PostgreSQL의 서버입니다. 필수적으로 설치해야 합니다.
* **pgAdmin4**  
  PostgreSQL을 관리할 수 있는 GUI 애플리케이션 입니다.  
  개인적으로 사용하시는 것을 권장합니다.
* **Stack Builder**  
  PostgreSQL의 다양한 도구와 확장 기능을 설치하고 관리하는데 도움을 주는 GUI 도구 입니다.  
* **Command Line Tools**  
  PostgreSQL의 psql 명령어를 사용할 수 있는 Command Line 도구 입니다.  
  개인적으로 사용하시는 것을 권장합니다.

원하는 도구에 체크 표시를 누른 후, 아래 화면이 나올 때 까지 Next 버튼을 클릭합니다.  

![passwd](https://user-images.githubusercontent.com/104547731/231191655-b8f1e2b7-5518-4674-8a8a-d151fd284d3c.png)  

이제 PostgreSQL을 설치할 때, 기본으로 제공되는 superuser **`postgres`**의 비밀번호를 설정해 봅시다.  
비밀번호는 기억하시기 좋은 번호로 설정하시면 됩니다.  

![port](https://user-images.githubusercontent.com/104547731/231192504-6f6f6d26-8a60-4012-8f5d-04cdb356c4fc.png)  

다음으로 포트 설정입니다. PostgreSQL은 **5432** 포트를 default로 지정합니다.  
굳이 변경하지 않고 넘어가도록 하겠습니다.  

![locale](https://user-images.githubusercontent.com/104547731/231192880-266bf1b8-c6d7-475c-aaa8-eb71b5267a87.png)  

데이터베이스의 지역을 설정하는 부분입니다. 데이터베이스를 사용하고자 하는 국가를 선택해주시면 됩니다.  
저는 `Korean, Korea`를 선택하고 넘어가도록 하겠습니다.  

![install](https://user-images.githubusercontent.com/104547731/231193728-e0f7c9db-e2ba-40c7-9618-86a597317755.png)  

이제 Next 버튼을 이어서 선택후, 기다려주시면 설치가 완료됩니다.  

![complete](https://user-images.githubusercontent.com/104547731/231196819-ef02dfc2-d149-4ee7-872f-2bd30261bb2c.png)  

## 마무리
---
이로써 PostgreSQL의 장점과 함께, Windows 환경에서의 설치 방법을 함께 알아보았습니다.  
다음에는 PostgreSQL 사용법과 관련된 포스팅을 올려보도록 하겠습니다.  
감사합니다!