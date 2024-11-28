# Combine

Customize handling of asynchronous events by combining event-processing operators.<br>
이벤트 처리 연산자를 결합하여 비동기 이벤트 처리를 사용자 정의합니다.

Combine 프레임워크는 시간이 지남에 따라 변하는 값을 처리할 수 있는 선언적인 Swift API 제공. <br>
이러한 값들은 다양한 종류의 비동기 이벤트를 나타낼 수 있음.


## 정의
다양한 비동기 이벤트와 데이터 스트림을 선언적으로 처리할 수 있게 해주는 Swift Framework로, 반응형 프로그래밍 패러다임을 지원하여, 코드의 가독성과 유지보수성을 향상시킴

<br>

## Publisher(공급자)
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




