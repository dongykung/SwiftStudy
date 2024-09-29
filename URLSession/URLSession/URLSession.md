# URLSession
> An object that coordinates a group of related, network data transfer tasks.


네트워크 데이터 전송 작업 그룹을 조정하는 객체
<hr>

## 1. URLSession?
- Foundation 프레임워크에 포함된 클래스, HTTP/HTTPS 요청을 만들고 관리하는 데 사용
- 데이터 전송: 데이터를 다운로드하거나 업로드
- 백그라운드 작업: 앱이 백그라운드에 있을 때도 작업 수행
- 캐싱 및 인증 관리: 자동으로 캐시를 관리하고 인증 처리

<br>

## 2. URLSession 구성요소

### 2.1 URLSession Configuration
> A configuration object that defines behavior and policies for a URL session.

URL 세션에 대한 동작과 정책을 정의하는 구성 객체

URL 세션을 초기화 하기 전에 URLSession Configuration 객체를 적절히 구성하는 것이 중요함.<br>
세션 객체는 사용자가 제공한 Configuration으로 세션을 구성하고 구성되면 URLSessionConfiguration 객체에 대한 변경 사항을 무시합니다.<br>
전송 정책을 수정해야 하는 경우 세션 구성 객체를 업데이트하고 이를 사용하여 새 URLSession 객체를 만들어야 합니다
<br>
#### 세 가지 주요 설정
- default: 기본 설정을 사용하여 URLSession 사용
- ephemeral: 디스크에 캐시나 쿠키를 저장하지 않는 설정
- background: 백그라운드에서 네트워크 작업을 사용할 때 사용
```Swift
let configuration = URLSessionConfiguration.default
let session = URLSession(configuration: configuration)
```
<br>

### 2.2 URLSession Task
> 실제 네트워크 작업을 나타내는 추상 클래스.

#### 세 가지 주요 클래스
- URLSessionDataTask: 데이터를 가져오거나 보내는 작업
- URLSessionDownloadTask: 파일을 다운로드하는 작업
- URLSessionUploadTask: 파일을 업로드하는 작업

<br>

### 2.3 Delegate
> Delegate를 통해 데이터를 더 자세히 다루고 커스텀 할 수 있음

- 인증
- 응답처리
- 데이터 수신 등의 이벤트

단 Delegate를 사용하여 NetworkManager를 구성할 때 메모리 누수 방지 작업을 꼭 해줘야 함.<br>
URLSession과 해당 Delegate에 강한 참조가 생길 수 있음

<br>

## 3. URLSession사용

### 3.1 async/await

```Swift
import Foundation

struct User: Codable {
    let id: Int
    let name: String
}

func fetchUser() async throws -> User {
    let url = URL(string: "https://jsonplaceholder.typicode.com/users/1")!
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }
    
    let user = try JSONDecoder().decode(User.self, from: data)
    return user
}

Task {
    do {
        let user = try await fetchUser()
        print("User name: \(user.name)")
    } catch {
        print("Error fetching user: \(error)")
    }
}
```

<br>

### 3.2 Combine

```Swift
import Foundation
import Combine

struct Post: Codable {
    let id: Int
    let title: String
}

let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
var cancellables = Set<AnyCancellable>()

URLSession.shared.dataTaskPublisher(for: url)
    .map { $0.data }
    .decode(type: Post.self, decoder: JSONDecoder())
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("Finished successfully")
        case .failure(let error):
            print("Error: \(error)")
        }
    }, receiveValue: { post in
        print("Post title: \(post.title)")
    })
    .store(in: &cancellables)
```
















 

