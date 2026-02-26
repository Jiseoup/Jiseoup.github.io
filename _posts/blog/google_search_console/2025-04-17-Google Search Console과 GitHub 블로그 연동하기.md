---
title: "Google Search Console과 GitHub 블로그 연동하기"
slug: google-search-console
date: 2025-04-17 23:37:00 +09:00
last_modified_at: 2025-04-17 23:37:00 +09:00
categories: [Blog, Google Search Console]
tags: [google-search-console, github-blog, seo]
image: "/assets/img/title/blog/google_search_console/logo.png"
---

요즘 들어 블로그 포스팅의 노출 빈도가 눈에 띄게 줄어든 것 같아 **Google Search Console**을 등록하게 되었습니다.  
저처럼 처음 설정하시는 분들께도 도움이 되었으면 하는 마음에, 등록부터 블로그 연동, 사이트맵 제출까지의 과정을 정리해 이 포스팅에 담아보았습니다.  

## 1. Google Search Console 이란?
---
**Google Search Console은 내 웹사이트가 Google 검색에 어떻게 노출되고 있는지 확인하고 최적화할 수 있는 무료 도구**입니다. 사이트에 발생한 오류나 문제를 진단하고, 어떤 키워드로 방문자가 유입되고 있는지 파악할 수 있는 **검색 엔진 최적화(SEO)의 핵심 도구**라고 할 수 있습니다. 특히, **포스팅한 글을 검색 결과에 잘 노출시키기 위해**서는 반드시 활용해야 할 필수 도구입니다.  

## 2. Google Search Console 시작하기
---
먼저 [Google Search Console](https://search.google.com/search-console/about) 사이트에 접속하여 **`시작하기`** 버튼을 눌러줍니다.  

![gsc_main](/assets/img/posts/blog/google_search_console/gsc_main.png)  

다음으로 본인 블로그와 맞는 속성 유형을 선택해 정보를 입력합니다.  
저는 개인 도메인을 사용중이기 때문에, 도메인 속성 유형으로 정보를 입력해주었습니다.  

![gsc_start](/assets/img/posts/blog/google_search_console/gsc_start.png)  

이제 DNS 레코드를 통해 도메인 소유권을 확인할 차례입니다.  
DNS 레코드를 복사하고, 도메인 제공업체에 로그인하여 DNS 설정에 반영합니다.  

![gsc_dns_record](/assets/img/posts/blog/google_search_console/gsc_dns_record.png)  

DNS 설정 반영 후 **`확인`** 버튼을 클릭하면, Google에서 소유권 인증 절차를 밟습니다.  
DNS를 올바르게 설정하였다면, 아래와 같이 소유권이 확인되었다는 메시지를 확인하실 수 있습니다.  

![gsc_success](/assets/img/posts/blog/google_search_console/gsc_success.png)  

모든 인증이 끝나면 아래처럼 Google Search Console 대시보드에 접속할 수 있게 됩니다.  
데이터는 보통 24~48시간 내에 반영되기 시작하니, 다음 날까지 여유롭게 기다리시면 됩니다.  

![gsc_dashboard](/assets/img/posts/blog/google_search_console/gsc_dashboard.png)  

## 3. 사이트맵(Sitemap) 등록
---
사이트 등록이 완료되었다면, 이제는 **사이트맵(Sitemap)** 을 등록할 차례입니다.  
사이트맵은 내 사이트의 전체 구조를 검색 엔진에게 알려주는 XML 파일로, **페이지를 더 빠르고 정확하게 크롤링할 수 있도록 도와주는 역할**을 합니다.  

GitHub 블로그와 같은 정적 사이트는 별도의 내비게이션이 없기 때문에, **사이트맵 제출을 통해 검색 엔진이 블로그 전체를 빠짐없이 인식할 수 있도록 하는 과정이 중요**합니다.  

### 3-1. 사이트맵 생성
GitHub 블로그와 같은 Jekyll 기반의 사이트는 플러그인을 통해 자동으로 사이트맵을 생성할 수 있습니다.  
아래와 같이 `_config.yml` 파일에 `jekyll-sitemap` 플러그인을 추가해줍니다.  
```yml
# Plugin settings
plugins:
  - jekyll-sitemap
```

위 설정을 추가한 뒤 수정 내역을 커밋하고 배포하면, Jekyll이 자동으로 사이트맵을 생성하게 됩니다.  

![sitemap](/assets/img/posts/blog/google_search_console/sitemap.png)  

사이트맵은 아래 경로에서 확인할 수 있습니다.  
```
https://도메인/sitemap.xml
```

### 3-2. 사이트맵 제출
사이트맵이 성공적으로 생성되었다면, 마지막으로 Google Search Console에 제출할 차례입니다.  
Google Search Console 대시보드의 `Sitemaps` 탭으로 이동하여 본인의 사이트맵 주소를 등록합니다.  

![gsc_add_sitemap](/assets/img/posts/blog/google_search_console/gsc_add_sitemap.png)  

사이트맵이 성공적으로 등록되면 위와 같이 제출된 사이트맵 리스트에 성공 상태로 나타나게 됩니다.  

## 마무리
---
이번 포스팅에서는 Google Search Console 등록 방법부터, GitHub 블로그와의 연동 및 사이트맵 제출까지 전 과정을 정리해보았습니다.  

검색 엔진에 내 사이트를 잘 노출시키고 싶다면, Google Search Console는 더 이상 선택이 아닌 필수라고 생각합니다.  
특히 정적 사이트를 운영하는 경우, 사이트맵을 통한 색인 최적화는 검색 유입을 높이는 데 큰 도움이 됩니다.  

이 글이 저처럼 처음 시작하시는 분들께 실질적인 도움이 되었으면 좋겠습니다.  

감사합니다.  
