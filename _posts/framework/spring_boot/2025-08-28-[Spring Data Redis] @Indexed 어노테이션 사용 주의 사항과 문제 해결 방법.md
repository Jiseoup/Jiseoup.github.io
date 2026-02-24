---
title: "[Spring Data Redis] @Indexed 어노테이션 사용 주의 사항과 문제 해결 방법"
# slug: spring-data-redis-indexed-annotation
date: 2025-08-28 22:00:00 +09:00
last_modified_at: 2025-08-28 22:00:00 +09:00
categories: [Framework, Spring Boot]
# tags: [spring, redis, annotation, troubleshooting]
image: "/assets/img/title/framework/spring_boot/spring_data_redis_indexed.png"
---

**[Spring Data Redis](https://spring.io/projects/spring-data-redis)**는 엔터티를 Redis에 매핑할 때, 일반적으로 **`@Id`로 지정된 키를 기준으로만 `findById()`와 같은 JPA 스타일의 CRUD 메서드를 지원**합니다.  
그러나 개발을 하다 보면 종종 `findByEmail()`과 같이 **특정 필드를 조건으로 조회가 필요할 때**가 있습니다.  
이때 유용하게 활용할 수 있는 기능이 바로 **`@Indexed` 어노테이션** 입니다.  

`@Indexed` 어노테이션은 **지정된 필드 값을 기준으로 보조 인덱스를 생성**하여, 마치 **JPA에서 파생 쿼리 메서드를 쓰듯 `findBy<Field>()` 형태의 조회를 가능하게 해줍니다.**  
덕분에 Redis를 단순 Key-Value 저장소 그 이상으로 활용할 수 있게 되지만, 여기에는 **커다란 주의 사항**이 있습니다.  

따라서, 이번 포스팅에서는 `@Indexed` 어노테이션 사용에 따라 **어떤 차이가 발생**하는지, 그 과정에서 나타나는 **문제점**은 무엇인지, 그리고 이를 어떻게 **해결할 수 있는지**까지 차례대로 살펴보겠습니다.  

## 1. Indexed 어노테이션 사용에 따른 차이점
---
먼저, 다음과 같은 데이터를 Redis에 저장한다고 가정해 보겠습니다.  
```java
User("karina", "karina@gmail.com", 300) // User(String id, String email, long ttl)
```

> Redis에서 **TTL(Time-To-Live)은 초(seconds)단위로 계산**되며, 위 예시의 `ttl=300`은 **5분**을 의미합니다.  
{: .prompt-tip }

### 1-1. 어노테이션을 사용하지 않는 경우
아래는 `@Indexed` 어노테이션이 없는 기본 엔터티 정의입니다.  
```java
@RedisHash(value = "User")
public class User implements Serializable {
    @Id
    private String id;

    private String email;

    @TimeToLive
    private long ttl;
}
```

위 엔터티를 저장하면, Redis 내부에는 다음과 같은 Key-Value 구조가 생성됩니다.  
```bash
redis> KEYS *
1) "User"
2) "User:karina"
```
```bash
redis> HGETALL "User:karina"
1) "_class"
2) "com.example.entities.Users"
3) "email"
4) "karina@gmail.com"
5) "id"
6) "karina"
7) "ttl"
8) "300"
```

즉, `@Id`로 지정된 값인 **`karina`가 주요 키로 사용**되며, **`email` 필드는 단순히 해시 구조의 속성**으로만 저장됩니다.  
따라서 이 경우에는 **`findById("karina")`는 가능**하지만, **`findByEmail("karina@gmail.com")`과 같은 쿼리는 수행할 수 없습니다.**  

### 1-2. 어노테이션을 사용하는 경우
이번에는 `email` 필드에 `@Indexed` 어노테이션을 추가하여 엔터티를 정의해 보겠습니다.  
```java
@RedisHash(value = "User")
public class User implements Serializable {
    @Id
    private String id;

    @Indexed
    private String email;

    @TimeToLive
    private long ttl;
}
```

이 상태에서 동일한 데이터를 저장하면, Redis에는 아래와 같이 **추가적인 인덱스 관련 키들이 생성**됩니다.  
```bash
redis> KEYS *
1) "User"
2) "User:karina"
3) "User:karina:idx"
4) "User:email:karina@gmail.com"
```

* **`"User:email:karina@gmail.com"`** 키는 내부적으로 **set 구조**를 가지며, `email` 값과 연결된 `id`를 담고 있습니다.  
```bash
redis> SMEMBERS "User:email:karina@gmail.com"
1) "karina"
```

* **`"User:karina:idx"`** 키는 해당하는 엔터티가 어떤 인덱스에 연결되어 있는지 추적하는 **역참조용 set**입니다.  
```bash
redis> SMEMBERS "User:karina:idx"
1) "User:email:karina@gmail.com"
```

즉, `@Indexed` 어노테이션을 사용하면 **`findByEmail("karina@gmail.com")`과 같은 메서드 호출이 가능**해집니다.  

## 2. Indexed 어노테이션 사용 시 주의 사항
---
앞서 설명해 드린 바와 같이, `@Indexed` 어노테이션을 사용하면 **`@Id` 키 외에도 다른 필드를 기준으로 JPA 스타일의 CRUD 메서드를 활용할 수 있다는 장점**이 있습니다.  

하지만, 여기에는 반드시 짚고 넘어가야 할 **중요한 주의 사항**이 있습니다.  
앞서 `@Indexed` 어노테이션과 함께 생성한 `"User:karina"` 키는 TTL(300초)이 설정되어 5분 후 자동으로 삭제됩니다.  
반면에, `"User:email:karina@gmail.com"`, `"User:karina:idx"` 같은 **인덱스 관련 키에는 TTL이 적용되지 않아, 엔터티 키와 함께 삭제되지 않습니다.**  
```bash
redis> KEYS *
1) "User"
2) "User:karina:idx"
3) "User:email:karina@gmail.com"
```

이는 만료된 엔터티 키를 참조하는 **불필요한 고아 데이터(Orphan Data)를 누적**시켜, **잘못된 조회 결과와 불필요한 쿼리 비용**을 유발하며, 장기적으로는 **Redis 메모리 낭비와 성능 저하**로 이어집니다.  

따라서 `@Indexed` 어노테이션은 **TTL과 함께 사용할 때 특히 주의**해야 하며, 이러한 문제를 해결하기 위한 **적절한 대처 전략이 반드시 필요**합니다.  

## 3. 문제 해결 방안
---
Spring Data Redis는 Redis의 **`Keyspace Notifications` 기능**을 지원합니다.  
이를 활성화하면 **엔터티 키의 TTL이 만료되는 순간 이벤트를 수신**하여, 해당 엔터티와 **연결된 보조 인덱스를 삭제**할 수 있습니다.  
```java
@Configuration
@EnableRedisRepositories(
        enableKeyspaceEvents = RedisKeyValueAdapter.EnableKeyspaceEvents.ON_STARTUP)
public class RedisConfig {
}
```
위와 같이 Redis Configuration 클래스를 생성하고 **`enableKeyspaceEvents` 옵션을 `ON_STARTUP`으로 활성화**하면, **애플리케이션이 시작될 때부터 Redis의 키 만료 이벤트를 수신**할 수 있습니다.  

실제로 애플리케이션을 실행한 뒤 Redis 서버 설정을 확인해 보면, **`Keyspace Notifications`가 자동으로 활성화**된 것을 확인할 수 있습니다.  
```bash
$ redis-cli CONFIG GET notify-keyspace-events
1) "notify-keyspace-events"
2) "xE"
```
여기서 **`x`는 만료(expired) 이벤트**를 의미하고, **`E`는 Keyevent 채널을 통해 이벤트를 발행**한다는 뜻입니다.  
즉, **`xE`** 설정은 **키 만료 이벤트를 Keyevent 채널로 발행**하도록 Redis를 구성한 것입니다.  

## 마무리
---
Spring Data Redis에서 `@Indexed` 어노테이션은 분명 편리한 기능이지만, TTL과 함께 사용할 경우 고아 데이터 문제를 일으킬 수 있습니다.  
따라서 운영 환경에서는 단순 편의성보다, 정합성과 성능을 지킬 수 있는 대책을 마련하는 것이 중요합니다.  

이번 포스팅이 `@Indexed` 사용 시 주의해야 할 점과, 운영 환경에서의 문제 예방에 도움이 되었기를 바랍니다.  

감사합니다.  

> 참고 자료 : [Spring Data Redis의 @Indexed 사용 시 주의점](https://dkswnkk.tistory.com/709)  
{: .prompt-info }
