---
title: "GoatCounter를 이용한 페이지 조회수 기능 추가"
date: 2024-11-20 23:44:00 +09:00
last_modified_at: 2024-11-20 23:44:00 +09:00
categories: [Blog, Github Blog]
tags:
  [
    github,
    github blog,
    blog,
    views,
    blog views,
    github blog views,
    goatcounter,
    깃허브,
    깃허브 블로그,
    블로그,
    조회수,
    조회수 기능,
    블로그 조회수,
    깃허브 블로그 조회수,
    고트카운터,
    velog,
    tistory,
    jekyll,
    chirpy,
    jekyll-theme-chirpy,
  ]
image: "/assets/img/title/goatcounter_logo_white.png"
---

GoatCounter는 간단한 설정만으로 페이지 조회수를 추적할 수 있는 경량화된 웹 분석 도구입니다.  
Github 블로그와 연동하면 페이지 조회수를 손쉽게 카운팅할 수 있으며, 제공되는 대시보드를 통해 직관적으로 데이터를 확인할 수도 있습니다.  

현재 Jekyll Chirpy 테마에서는 페이지 조회수 기능으로 GoatCounter만을 제공하기 때문에, 이를 간편하게 설정하는 방법에 대해 알아보겠습니다.  

## 1. GoatCounter 설정하기
먼저 [GoatCounter 홈페이지](https://www.goatcounter.com)로 이동하여, 홈에 바로 보이는 `Sign up` 버튼을 통해 회원 가입을 해줍니다.  

![goatcounter_home](/assets/img/posts/blog/github_blog/goatcounter_home.png)  

간단한 정보만 입력하면, 회원 가입을 마칠 수 있습니다.
> ***Code:** 원하시는 서브 도메인을 입력하시면 됩니다. GoatCounter 대시보드 및 블로그 연동에 활용됩니다.*  
> ***Site domain:** 연동할 블로그 도메인을 입력하시면 됩니다.*  
> ***Email address:** 이메일 주소를 입력하시면 됩니다*.  
> ***Password:** 비밀번호를 입력하시면 됩니다*.  
> ***Fill in 9 here:** 간단한 검증입니다. 9를 입력하시면 됩니다.*  

![goatcounter_signup](/assets/img/posts/blog/github_blog/goatcounter_signup.png)  

회원 가입을 마치면 메인 대시보드로 이동하게 될텐데, 우측 상단의 `Settings` 페이지로 이동합니다.  
마지막으로 `Allow adding visitor counts on your website` 체크박스를 선택하여 설정을 마칩니다.  

![goatcounter_settings](/assets/img/posts/blog/github_blog/goatcounter_settings.png)  

## 2. 블로그에 연동하기
Jekyll Chirpy 테마에서는 GoatCounter를 잘 지원하기 때문에, 아주 간편하게 연동할 수 있습니다.  
`_config.yml` 파일에서 아래와 같이 설정만하면 끝입니다.  
```yaml
# Web Analytics Settings
analytics:
  google:
    id: # fill in your Google Analytics ID
  goatcounter:
    id: {$ Your GoatCounter Code} # fill in your GoatCounter ID
  .
  .
  .
# Page views settings
pageviews:
  provider: goatcounter # now only supports 'goatcounter'
```

## 마무리
---
드디어 제 블로그에도 페이지 조회수 기능이 생겼습니다.  
모두 GoatCounter를 활용해 간편하게 페이지 조회수 기능을 추가하고, 대시보드를 통해 방문자 수 시각화 및  
콘텐츠 인기도 분석에 활용하실 수 있기를 바랍니다.  

감사합니다.  
