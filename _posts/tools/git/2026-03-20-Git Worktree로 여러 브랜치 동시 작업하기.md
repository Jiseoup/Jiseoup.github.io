---
title: "Git Worktree로 여러 브랜치 동시 작업하기"
slug: git-worktree
date: 2026-03-20 17:28:00 +09:00
last_modified_at: 2026-03-20 17:28:00 +09:00
categories: [Tools, Git]
tags: [git, command]
image: "/assets/img/title/tools/git/git_worktree.png"
---

개발을 하다 보면 `feature` 브랜치 작업 도중 긴급 버그 수정이나 PR 리뷰 요청이 들어오는 경우가 있습니다.  
이럴 때 `git stash`나 브랜치 전환으로 대응하다 보면 작업 흐름이 끊기고, 충돌이나 실수로 이어지기도 합니다.  
이번 포스팅에서는 이런 상황을 깔끔하게 해결해주는 **`Git Worktree`**의 개념과 사용법을 알아보겠습니다.  

> Git의 기본 명령어가 궁금하다면 [자주 쓰는 Git 명령어 총정리](/posts/git-commands/) 포스팅을 참고해주세요.  
{: .prompt-info }

## 1. Git Worktree란?
---
Git Worktree는 **하나의 로컬 레포지토리에서 여러 개의 작업 디렉토리(Working Tree)를 동시에 운용**할 수 있게 해주는 Git의 내장 기능입니다.  

일반적으로 Git 레포지토리는 하나의 작업 디렉토리와 연결되어 있어, 다른 브랜치로 이동하려면 현재 작업을 `commit`하거나 `stash` 해야 합니다.  
이때, Git Worktree를 사용하면 **동일한 `.git` 디렉토리를 공유하면서도 서로 다른 브랜치를 각각의 디렉토리에서 독립적으로 작업**할 수 있습니다.  

```text
my-project/          ← main 브랜치 (메인 작업 디렉토리)
my-project-hotfix/   ← hotfix/urgent-bug 브랜치 (추가된 Worktree)
my-project-review/   ← feature/new-feature 브랜치 (추가된 Worktree)
```

위처럼 각 디렉토리는 **서로 다른 브랜치를 체크아웃한 상태**로 완전히 독립적으로 동작합니다.  

> **하나의 브랜치는 동시에 하나의 Worktree에서만 체크아웃**할 수 있습니다.  
> 이미 체크아웃된 브랜치를 다른 Worktree에서 다시 체크아웃하려 하면 오류가 발생합니다.  
{: .prompt-warning }

## 2. 기본 명령어
---
아래는 Git Worktree를 관리하는 데 사용되는 주요 명령어들입니다.  

### 2-1. Worktree 추가 (add)
새로운 Worktree를 추가하는 명령어입니다.  
```bash
git worktree add <경로> <브랜치명>
```

아래는 `hotfix/urgent-bug` 브랜치를 `../my-project-hotfix` 경로에 체크아웃하는 예시입니다.  
```bash
git worktree add ../my-project-hotfix hotfix/urgent-bug
```

존재하지 않는 새 브랜치를 만들면서 동시에 Worktree를 추가하려면 `-b` 옵션을 사용합니다.  
```bash
git worktree add -b hotfix/urgent-bug ../my-project-hotfix main
```

> Worktree 경로는 현재 레포지토리 디렉토리 **바깥**에 지정하는 것이 권장됩니다.  
> 레포지토리 내부에 생성하면 Git이 새 디렉토리를 추적 대상으로 인식할 수 있습니다.  
{: .prompt-tip }

### 2-2. Worktree 목록 확인 (list)
현재 레포지토리에 연결된 모든 Worktree 목록을 확인하는 명령어입니다.  
```bash
git worktree list
```

실행하면 아래와 같이 각 Worktree의 경로, 커밋 해시, 브랜치 정보가 출력됩니다.  
```bash
/home/user/my-project           abc1234 [main]
/home/user/my-project-hotfix    def5678 [hotfix/urgent-bug]
/home/user/my-project-review    ghi9012 [feature/new-feature]
```

### 2-3. Worktree 삭제 (remove)
작업이 완료된 Worktree를 제거하는 명령어입니다.  
```bash
git worktree remove <경로>
```

아래는 앞서 추가한 `../my-project-hotfix` Worktree를 제거하는 예시입니다.  
```bash
git worktree remove ../my-project-hotfix
```

> `git worktree remove`는 **변경사항이 없는 깨끗한 Worktree만** 제거할 수 있습니다.  
> 미커밋 변경사항이 남아있는 경우 `--force` 옵션을 추가해야 하지만, 작업 내용이 사라지므로 주의가 필요합니다.  
{: .prompt-warning }

Worktree 디렉토리를 직접 삭제한 후 Git 내부 참조가 남아있다면 아래 명령어로 정리할 수 있습니다.  
```bash
git worktree prune
```

## 3. 실제 활용 사례
---
아래는 Git Worktree가 유용하게 활용되는 대표적인 상황들입니다.  

### 3-1. 기능 개발 중 긴급 버그 수정
`feature` 브랜치에서 작업하던 중 핫픽스가 필요한 상황의 예시입니다.  

```bash
# 1. 현재 main 브랜치 기반으로 핫픽스용 Worktree 생성
git worktree add -b hotfix/login-bug ../my-project-hotfix main

# 2. 핫픽스 디렉토리로 이동하여 버그 수정 진행
cd ../my-project-hotfix
# ... 버그 수정 작업 ...
git add .
git commit -m "fix: 로그인 버그 수정"
git push origin hotfix/login-bug

# 3. 작업 완료 후 Worktree 제거
git worktree remove ../my-project-hotfix
```

기존 `feature` 브랜치의 작업 내용은 **`stash` 없이 그대로 유지**됩니다.  

### 3-2. PR 리뷰 중 기능 개발 병행
현재 작업 중인 브랜치를 유지하면서 다른 팀원의 PR을 로컬에서 직접 확인하는 예시입니다.  

```bash
# 1. PR 브랜치를 별도 Worktree로 체크아웃
git fetch origin
git worktree add ../my-project-review feature/new-payment

# 2. 리뷰 디렉토리에서 서버 실행 및 동작 확인
cd ../my-project-review
# ... 서버 실행, 동작 확인, 코드 리뷰 ...

# 3. 리뷰 완료 후 Worktree 제거
git worktree remove ../my-project-review
```

두 디렉토리에서 **서버를 동시에 띄워 비교하는 것**도 가능합니다. (포트만 다르게 설정)  

### 3-3. 여러 버전 동시 비교
레거시 버전과 최신 버전의 동작을 나란히 비교해야 할 때도 유용합니다.  

```bash
# v1.0.0 태그를 별도 Worktree로 체크아웃
git worktree add ../my-project-v1 v1.0.0
```

## 4. 유사 기능 비교
---
Worktree가 항상 최선의 선택은 아닙니다. 상황에 따라 적절한 도구를 선택하는 것이 중요합니다.  

|구분|git stash|git checkout|git worktree|
|---|---|---|---|
|작업 디렉토리|한 개 (전환)|한 개 (전환)|여러 개 (독립적)|
|기존 작업 보존|임시 저장 후 전환|커밋 필요 또는 stash|그대로 유지|
|서버 동시 실행|불가|불가|가능|
|디스크 사용량|적음|적음|브랜치 수에 비례|
|전환 속도|빠름|빠름|최초 생성 시 다소 느림|
|적합한 상황|짧은 컨텍스트 전환|일반적인 브랜치 이동|장기 병행 작업, PR 리뷰|

> **짧고 간단한 컨텍스트 전환**이라면 `git stash`나 `git checkout`이 더 간결합니다.  
> **장시간 병행 작업**이나 **서버를 동시에 실행해야 하는 경우**라면 `git worktree`가 훨씬 유리합니다.  
{: .prompt-tip }

## 마무리
---
Git Worktree는 알고 있으면 꽤 강력한 도구이지만, 생각보다 잘 알려져 있지 않은 기능입니다.  
`git checkout`과 `git stash`에 의존하던 방식에서 벗어나, 병행 작업이 많은 환경에서는 `git worktree`를 적극 활용해보시길 권장합니다.  

감사합니다.  
