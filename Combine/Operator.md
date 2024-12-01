# Operator
퍼블리셔(Publisher)가 발행하는 데이터를 변환, 필터링, 결합, 오류 처리 등을 수행하는 메서드들<br><br>

### Operator를 왜 사용해야 할까?
Operator를 사용하는 것은 데이터 스트림을 효과적으로 관리하고 조작하기 위한 핵심적인 방법입니다.
- 비동기 데이터 흐름 관리
- 복잡한 비동기 로직의 단순화
<br><br>
### 주요 이점
- 코드의 간결성
- 유지보수성과 확장성
- 비동기 작업의 순차적 처리
- 에러 처리의 일관성과 유연성
- 스레드 안정성과 성능 최적화

<br>

##  1. Catch
```Swift
struct Catch<Upstream, NewPublisher> where Upstream : Publisher, NewPublisher : Publisher, Upstream.Output == NewPublisher.Output
```
실패한 Publisher를 대체 Publisher를 제공하여 오류를 처리하는데 사용.(업스트림 게시자의 오류를 처리함)<br>
이를 통해 오류 발생 시에도 데이터 스트림을 지속적으로 처리할 수 있습니다.

### 사용상황
- 네트워크 요청 시 오류가 발생했을 때 기본값을 제공하고 싶을 때
- 파일 읽기 등에서 오류 발생 시 대체 데이터를 제공하고 싶을 때
- 사용자 인터페이스에서 오류 메시지를 표시하지 않고 대체 콘텐츠를 보여주고 싶을 때

```Swift
func fetchData() -> AnyPublisher<String, URLError> {
    if Bool.random() {
        return Fail(error: URLError(.badServerResponse))
            .eraseToAnyPublisher()
    } else {
        return Just("Hello, Combine!")
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}

let cancellable = fetchData()
    .catch { error in
        Just("대체 데이터")
            .setFailureType(to: URLError.self)
    }
    .sink { completion in
        switch completion {
        case .finished:
            return
        case .failure(let error):
            print("\(error.localizedDescription)")
        }
    } receiveValue: { value in
        print("\(value)")
    }
```
<br>

## 2. Receive(on:)
```Swift
struct ReceiveOn<Upstream, Context> where Upstream : Publisher, Context : Scheduler
```
Publisher가 발행한 값을 특정 디스패처나 스케줄러에서 수신하도록 지원.<br>
주로 UI 업데이트와 같은 메인 스레드에서 수행해야 하는 작업에 사용됩니다.

<br>

Publisher가 전달한 요소를 지정된 스케줄러에서 처리되도록 스케줄. -> *Publisher의 실행 스레드와 수신 스레드를 분리* <br>



### 사용상황
- 백그라운드 스레드에서 데이터를 처리한 후, 메인 스레드에서 UI를 업데이트 할 때
- 네트워크 요청 등 시간이 걸리는 작업을 백그라운드에서 처리한 수행하고, 결과를 메인 스레드에서 처리할 때
- Publisher 체인에서 특정 단계 이후에 수신 스레드를 변경하고 싶을 때

```Swift
import Combine
import Foundation

// 예시 퍼블리셔: 백그라운드에서 데이터 처리
func processData() -> AnyPublisher<String, Never> {
    Just("백그라운드 데이터 처리")
        .delay(for: .seconds(1), scheduler: DispatchQueue.global())
        .eraseToAnyPublisher()
}

let cancellable = processData()
    .receive(on: DispatchQueue.main) // 메인 스레드에서 수신
    .sink { value in
        print("메인 스레드에서 수신된 값: \(value)")
        // 여기서 UI 업데이트 가능
    }

// 출력 예시 (1초 후):
// 메인 스레드에서 수신된 값: 백그라운드 데이터 처리
```
<br>

## 2. Subscribe(on:)
```Swift
struct SubscribeOn<Upstream, Context> where Upstream : Publisher, Context : Scheduler
```
Publisher의 구독작업, 즉 퍼블리셔가 구독자를 등록하고 데이터를 발행하기 시작하는 작업이 특정 스케줄러에서 수행되도록 지원합니다.
<br>
이는 Publisher가 데이터를 데이터를 생성하거나 처리하는 작업의 스레드를 제어할 때 유용합니다.

<br>
Publisher의 구독 작업을 지정된 스케줄러에서 수행하도록 스케줄링 -> Publisher의 내부 작업이 특정 스레드에서 실행되도록 보장.

<br>

### 사용상황
- Publisher가 무거운 작업(데이터 처리, 네트워크 요청 등)을 수행할 때, 백그라운드 스레드에서 실행하고 싶을 때
- Publisher의 생성과 관련된 작업을 메인 스레드가 아닌 다른 스레드에서 작업하고 싶을 때
- Publisher 체인에서 구독 작업의 스레드를 변경하고 싶을 때

```Swift
import Combine
import Foundation

// 예시 퍼블리셔: 무거운 작업 시뮬레이션
func heavyWork() -> AnyPublisher<String, Never> {
    Just("무거운 작업 완료")
        .handleEvents(receiveSubscription: { _ in
            print("무거운 작업을 백그라운드 스레드에서 시작")
        })
        .subscribe(on: DispatchQueue.global(qos: .background)) // 백그라운드 스레드에서 구독
        .eraseToAnyPublisher()
}

let cancellable = heavyWork()
    .receive(on: DispatchQueue.main) // 메인 스레드에서 수신
    .sink { value in
        print("메인 스레드에서 수신된 값: \(value)")
        // UI 업데이트 가능
    }

// 출력 예시:
// "무거운 작업을 백그라운드 스레드에서 시작"
// "메인 스레드에서 수신된 값: 무거운 작업 완료"
```






