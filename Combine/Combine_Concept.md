# 1. Combine

Customize handling of asynchronous events by combining event-processing operators.<br>
이벤트 처리 연산자를 결합하여 비동기 이벤트 처리를 사용자 정의합니다.

Combine 프레임워크는 시간이 지남에 따라 변하는 값을 처리할 수 있는 선언적인 Swift API 제공. <br>
이러한 값들은 다양한 종류의 비동기 이벤트를 나타낼 수 있음.


## 2. 정의
다양한 비동기 이벤트와 데이터 스트림을 선언적으로 처리할 수 있게 해주는 Swift Framework로, 반응형 프로그래밍 패러다임을 지원하여, 코드의 가독성과 유지보수성을 향상시킴

<br>

## 3. Publisher(공급자)
Declares that a type can transmit a sequence of values over time. <br>
유형이 시간이 지남에 따라 일련의 값을 전송할 수 있다고 선언한다.
```Swift
public protocol Publisher<Output, Failure> {

    /// 생성되는 값의 종류
    associatedtype Output

    /// 생성되는 에러의 종류
    /// Use `Never` if this `Publisher` does not publish errors.
    associatedtype Failure : Error

    /// Attaches the specified subscriber to this publisher.
    ///
    /// Implementations of ``Publisher`` must implement this method.
    ///
    /// The provided implementation of ``Publisher/subscribe(_:)-4u8kn``calls this method.
    /// - 퍼블리셔가 서브스크라이버를 수락하고, 데이터 스트림을 시작할 수 있도록 설정
    /// - Parameter subscriber: The subscriber to attach to this ``Publisher``, after which it can receive values.
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input
}
```

- 데이터 스트림 생성
- 데이터 전달
- 데이터 변환 및 조합

> 구독자와의 타입이 동일해야 구독이 가능함

게시자는 하나 이상의 구독자 인스턴스에 요소를 전달합니다.<br>
구독자의 Input and Failure 타입은 게시자의 Output, Failure 타입과 일치해야 합니다.

<br>
게시자는 구독자를 수락하기 위해 receive(subscriber:) 메서드를 구현해야 함.

<br><br>

## 4. Subscriber(소비자)
A protocol that declares a type that can receive input from a publisher.<br>
데이터 스트림을 구독하고 데이터를 받아 처리, 게시자로부터 입력을 받을 수 있는 유형을 선언하는 프로토콜
```Swift
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol Subscriber<Input, Failure> : CustomCombineIdentifierConvertible {

    /// The kind of values this subscriber receives.
    associatedtype Input

    /// The kind of errors this subscriber might receive.
    ///
    /// Use `Never` if this `Subscriber` cannot receive errors.
    associatedtype Failure : Error

    /// Tells the subscriber that it has successfully subscribed to the publisher and may request items.
    ///
    /// Use the received ``Subscription`` to request items from the publisher.
    /// - Parameter subscription: A subscription that represents the connection between publisher and subscriber.
    func receive(subscription: any Subscription)

    /// Tells the subscriber that the publisher has produced an element.
    ///
    /// - Parameter input: The published element.
    /// - Returns: A `Subscribers.Demand` instance indicating how many more elements the subscriber expects to receive.
    func receive(_ input: Self.Input) -> Subscribers.Demand

    /// Tells the subscriber that the publisher has completed publishing, either normally or with an error.
    ///
    /// - Parameter completion: A ``Subscribers/Completion`` case indicating whether publishing completed normally or with an error.
    func receive(completion: Subscribers.Completion<Self.Failure>)
}
```
게시자의 <Output, Failure> 타입과 구독자의 <Input, Failure> 타입은 일치해야 합니다. <br><br>

### 4.1 Subscriber를 Publisher에 연결하기: subscribe(_:) 메서드 호출
- subscribe(_:) 메서드는 Subscriber를 Publisher에 연결하는 방법입니다. 이 메서드를 호출함으로써 Subscriber는 Publisher로부터 데이터를 받기 시작하게 됩니다.
- subscriber는 publisher의 subscribe(_:) 메서드를 통해 연결됩니다. 이 호출로 인해 Publisher는 Subscriber의 receive(subscription:) 메서드를 호출합니다.

```Swift
import Combine

let publisher = Just("Hello, Combine!")
let subscriber = Subscribers.Sink<String, Never>(
    receiveCompletion: { completion in
        print("완료: \(completion)")
    },
    receiveValue: { value in
        print("수신된 값: \(value)")
    }
)

// Subscriber를 Publisher에 연결
publisher.subscribe(subscriber)

// 수신된 값: Hello, Combine!
// 완료: finished
```

<br>

### 4.2 Publisher가 Subscriber의 receive(subscription:) 메서드를 호출
- receive(subscription:) 메서드는 Publisher가 Subscriber에게 Subscription 인스턴스를 전달하는 역할을 합니다. 이를 통해 Subscriber는 Publisher에게 얼마나 많은 데이터를 요청할지, 또는 구독을 취소할지 결정할 수 있습니다.
- Subscription은 Publisher와 Subscriber 간의 연결을 관리

<br>

### 4.3 Combine은 게시자 유형에 대한 연산자로 다음 구독자를 제공합니다.
- sink(receiveCompletion:receiveValue:) =  완료 신호를 수신할 때와 새 요소를 수신할 때마다 임의의 클로저를 실행
- assign(to:on:) = 할당(to:on:)은 새로 수신된 각 값을 지정된 인스턴스의 키 경로로 식별되는 속성에 씁니다.

<br>

### 4.4 직접 Subscriber 생성 및 연결
```Swift
import Combine

// 1. 퍼블리셔 생성
let publisher = Just("Hello, Combine!")

// 2. 커스텀 서브스크라이버 정의
class MySubscriber: Subscriber {
    typealias Input = String
    typealias Failure = Never

    func receive(subscription: Subscription) {
        print("구독 시작")
        subscription.request(.unlimited) // 모든 데이터를 요청
    }

    func receive(_ input: String) -> Subscribers.Demand {
        print("수신된 값: \(input)")
        return .none // 추가 데이터를 요청하지 않음
    }

    func receive(completion: Subscribers.Completion<Never>) {
        print("완료: \(completion)")
    }
}

// 3. 서브스크라이버 인스턴스 생성
let mySubscriber = MySubscriber()

// 4. 퍼블리셔와 서브스크라이버 연결
publisher.subscribe(mySubscriber)

// 출력:
// 구독 시작
// 수신된 값: Hello, Combine!
// 완료: finished
```

<br>

### 4.5 예제: 커스텀 Subscriber와 Subscription
```Swift
import Combine

// 1. 커스텀 Publisher 정의
struct MyPublisher: Publisher {
    typealias Output = String
    typealias Failure = Never

    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, String == S.Input {
        // Subscriber에게 Subscription 전달
        let subscription = MySubscription(subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

// 2. 커스텀 Subscription 정의
class MySubscription<S: Subscriber>: Subscription where S.Input == String {
    private var subscriber: S?

    init(subscriber: S) {
        self.subscriber = subscriber
    }

    // Subscriber의 요청을 처리
    func request(_ demand: Subscribers.Demand) {
        // demand 만큼 데이터 방출
        _ = subscriber?.receive("첫 번째 값")
        _ = subscriber?.receive("두 번째 값")
        // 완료 이벤트 전달
        subscriber?.receive(completion: .finished)
    }

    // 구독 취소 시 처리
    func cancel() {
        subscriber = nil
    }
}

// 3. Subscriber 정의 및 사용
let myPublisher = MyPublisher()
let mySubscriber = Subscribers.Sink<String, Never>(
    receiveCompletion: { completion in
        print("완료: \(completion)")
    },
    receiveValue: { value in
        print("수신된 값: \(value)")
    }
)

myPublisher.subscribe(mySubscriber)

// 출력:
// 수신된 값: 첫 번째 값
// 수신된 값: 두 번째 값
// 완료: finished
```
<br>

## 5. Subscruption(구독권)
A protocol representing the connection of a subscriber to a publisher.

```Swift
public protocol Subscription : Cancellable, CustomCombineIdentifierConvertible {

    /// Tells a publisher that it may send more values to the subscriber.
    func request(_ demand: Subscribers.Demand)
}
```

- 이벤트 및 데이터 전달
- 구독관리
- 자원 해제 및 정리
- 구독의 생명 주기를 관리
- Subscriber가 구독을 취소할 때 Subscription을 통해 취소할 수 있음
- 구독이 끝날 때 필요한 자원을 해제하는 역활을 함
<br>

## 6. 구독 메커니즘 이해하기
<img width="891" alt="image" src="https://github.com/user-attachments/assets/26f8c02f-d2fb-4f60-be3d-a7a3edefbcff">

 <br>

 1. Publisher에게 .subscribe(_: Subscriber:S)
 2. 구독을 요청받은 Publisher는 구독자에게 전달할 Subscription(구독권)을 내부적으로 생성
 3. Publisher는 구독권을 implement 함수인 receive에서 Subscriber.receive(subscription:) 메서드 호출하여 구독자에게 전달
```Swift
// 1. Custom Publisher 정의
struct MyPublisher: Publisher {
    typealias Output = String
    typealias Failure = Never

    // Subscriber를 수락하고 Subscription을 전달
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, String == S.Input {
        let subscription = MySubscription(subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

```
 4. 구독권을 받은 구독자는 Subscription에게 원하는 Demand 요청 Subscription.request(_: Demand) Demand란 구독자가 원하는 값의 수요로 unlimited, None, MaxValue를 셋팅할 수 있음
```Swift
// 2. Custom Subscription 정의
class MySubscription<S: Subscriber>: Subscription where S.Input == String {
    private var subscriber: S?

    init(subscriber: S) {
        self.subscriber = subscriber
    }

    // Subscriber의 요청을 처리
    func request(_ demand: Subscribers.Demand) {
        guard let subscriber = subscriber else { return }
        // 요청된 만큼 데이터 방출 (여기서는 3개의 문자열을 방출)
        _ = subscriber.receive("첫 번째 값")
        _ = subscriber.receive("두 번째 값")
        _ = subscriber.receive("세 번째 값")
        // 완료 이벤트 전달
        subscriber.receive(completion: .finished)
    }

    // 구독 취소 시 처리
    func cancel() {
        subscriber = nil
    }
}

```
5. Publisher는 값을 생성하면 Subscruption(구독권) 에게 값을 전달하고 Subscruption들은 구독자에게 값을 전달
6. 구독자들은 Input을 받고 수요 값에 대한 변경을 원하면 Subscription은 구독자로부터 받은 Demand로 값을 조정함 Subscriber.receive(_: Input) → Subscriber.Demand 로 Subscription의 Demand 조정 가능
7. Publisher로 부터 완료 이벤트를 받으면 Subscription은 Subscriber에게 이벤트를 전달하며 Subscriber에 대한 메모리를 해지하고 Publisher로 Subscription에 대한 메모리를 해제함 Subscriber.reveive(completion:)

> Publisher와 Subscriber가 직접 연결되지 않고 Subscription을 통해 소통한다






