---
title: "Google Search Console과 Google Analytics 연결하기"
slug: google-search-console-analytics
date: 2026-03-27 21:58:00 +09:00
last_modified_at: 2026-03-27 21:58:00 +09:00
categories: [Blog, Google]
tags: [github-blog, seo, analytics, google]
image: "/assets/img/title/blog/google/google_search_console_analytics.png"
---

## 1. 연결하면 무엇이 좋을까?
---
**Google Search Console**과 **Google Analytics**는 각각 독립적으로도 유용한 도구입니다.  
하지만, **두 도구를 연결하게되면 검색 데이터와 사이트 분석 데이터를 하나의 화면에서 통합적으로 확인**할 수 있어 더욱 깊이 있는 분석이 가능해집니다.  

연결 이후에는 Google Analytics에서 아래와 같은 Google Search Console 데이터를 직접 조회할 수 있게 됩니다.  

- **검색 키워드:** 어떤 키워드로 내 블로그가 검색되었는지 확인할 수 있습니다.  
- **노출 수:** 검색 결과에 내 페이지가 얼마나 노출되었는지 파악할 수 있습니다.  
- **클릭 수 및 클릭률(CTR):** 노출 대비 실제로 얼마나 클릭이 발생했는지 확인할 수 있습니다.  
- **평균 게재순위:** 특정 키워드에 대한 내 페이지의 평균 검색 순위를 알 수 있습니다.  

이러한 데이터를 Google Analytics의 사용자 행동 데이터와 함께 분석하면, **어떤 키워드로 유입된 사용자가 실제로 어떤 행동을 하는지**까지 파악할 수 있어 콘텐츠 전략 수립에 큰 도움이 됩니다.  

> Google Search Console과 Google Analytics의 설정 방법은 아래 게시글을 참고하면 좋습니다.  
> - [Google Search Console과 GitHub 블로그 연동하기](/posts/google-search-console/)  
> - [Google Analytics와 GitHub 블로그 연동하기](/posts/google-analytics/)  
{: .prompt-info }

## 2. Google Search Console에서 연결하기
---
[Google Search Console](https://search.google.com/search-console/)에 접속하여 Google Analytics와 연결하고자하는 속성(도메인)을 선택합니다.  
이후 좌측 메뉴 하단의 **`설정`** 탭을 클릭하고, 나타나는 화면에서 **`연결`** 항목을 찾아 클릭합니다.  

![settings](/assets/img/posts/blog/google/google_search_console_analytics/settings.png)  

**`연결`** 버튼을 클릭하면 연결할 서비스를 선택하는 화면이 나타납니다.  
여기서 **`Google Analytics`** 를 선택합니다.  

![select_service](/assets/img/posts/blog/google/google_search_console_analytics/select_service.png)  

마지막으로, 연결할 Google Analytics 데이터 스트림을 선택한 후 **`계속`** 버튼을 눌러 과정을 이어나갑니다.  

![select_stream](/assets/img/posts/blog/google/google_search_console_analytics/select_stream.png)  

아래와 같이 연결된 서비스에 본인의 Google Analytics 데이터 스트림이 나타난다면 연결 성공입니다.  

![connected](/assets/img/posts/blog/google/google_search_console_analytics/connected.png)  

## 3. Google Analytics에서 연결 확인하기
---
이제 Google Analytics에서 데이터가 정상적으로 연결되었는지 확인할 차례입니다.  
[Google Analytics](https://analytics.google.com/)에 접속한 뒤, 좌측 메뉴에서 **`보고서`** → **`Search Console`** 항목을 확인합니다.  

![analytics_search_console](/assets/img/posts/blog/google/google_search_console_analytics/analytics_search_console.png)  

**`Search Console`** 메뉴 아래에 **`쿼리`**와 **`Google 자연 검색 트래픽`** 항목이 나타나면 연결이 정상적으로 완료된 것입니다.  
- **쿼리:** 사용자가 어떤 검색어를 통해 내 사이트에 유입되었는지 확인할 수 있습니다.  
- **Google 자연 검색 트래픽:** 검색을 통해 방문한 사용자의 랜딩 페이지별 성과를 확인할 수 있습니다.  

> 연결 직후에는 데이터가 바로 표시되지 않을 수 있습니다.  
> Search Console 데이터가 Analytics에 반영되기까지 **최대 48시간**이 소요될 수 있으니, 하루 정도 여유를 두고 확인해보시기 바랍니다.  
{: .prompt-info }
