# Convenience Publishers
Apple에서 미리 만들어둔 Publisher들 
<br>

## Just
A publisher that emits an output to each subscriber just once, and then finishes.<br>
단일 값을 하나 발행하고 완료하는 퍼블리셔입니다.
```Swift
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct Just<Output> : Publisher {

    public typealias Failure = Never

    public let output: Output

    public init(_ output: Output)

    public func receive<S>(subscriber: S) where Output == S.Input, S : Subscriber, S.Failure == Never
}

let intPublisher = Just(100)
let cancellable = intPublisher.sink { completion in 
		print("Receivedcompletion: ", completion)
	} receiveValue: { value in
		print("Received value: ", value)
	}
	
	
	//Received value: 100
	//Received completion: finished
```

- 테스트용 데이터 제공
- 초기값 설정
- 구독이 시작되면 지정된 단일 값을 발행하고 즉시 완료 이벤트를 보냅니다.


<br>

## Empty
A publisher that never publishes any values, and optionally finishes immediately.<br>
값을 생성하지 않고 완료만 하는 Publisher
```Swift
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct Empty<Output, Failure> : Publisher, Equatable where Failure : Error {

    public init(completeImmediately: Bool = true)

    public init(completeImmediately: Bool = true, outputType: Output.Type, failureType: Failure.Type)

    public let completeImmediately: Bool

    public func receive<S>(subscriber: S) where Output == S.Input, Failure == S.Failure, S : Subscriber

    public static func == (lhs: Empty<Output, Failure>, rhs: Empty<Output, Failure>) -> Bool
}
struct Empty<Output, Failure> where Failure: Error

let emptyPublisher = Empty<Int, Never>()

let cancellable = emptyPublisher.sink { completion in
		switch completion {
			case .finished:
				print("Received finished")
			case .failure(let error):
				print("Received failure: ", error.localizedDescription)
		}
	} receiveValue: { value in 
		print("Received value: ", value)
	}
// Received finished
```
- 테스트 시 빈 퍼블리셔 필요할 때
- 기본값으로 사용
- 값이 전혀 발행되지 않으므로 값 기반 로직과는 부적합
- 구독이 시작되면 Empty 퍼블리셔는 즉시 완료 또는 지정된 오류를 전송하고 연결을 종료합니다.

<br>

## Fail
A publisher that immediately terminates with the specified error.<br>
지정된 오류를 즉시 발행하고 퍼블리셔를 종료하는 퍼블리셔입니다.
```Swift
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct Fail<Output, Failure> : Publisher where Failure : Error {

    public init(error: Failure)

    public init(outputType: Output.Type, failure: Failure)

    public let error: Failure

    public func receive<S>(subscriber: S) where Output == S.Input, Failure == S.Failure, S : Subscriber
}
let failPublisher = Fail<Int, IntError>(error:.error)

let cancellable = failPublisher.sink(
	receiveCompletion: { completion in 
		switch completion {
			case .finished:
				print("Received finished")
			case let .failure(error):
				print("Received failure", error)
				}
			},
		...
	)
// Received failure: error
```
- 에러 상태를 시뮬레이션할 때
- 특정 조건에서 강제적으로 오류를 발생시킬 때
- 오류 처리를 테스트할 때 유용
- 구독이 시작되면 지정된 오류를 즉시 전송하고 퍼블리셔를 종료합니다.


<br>

## Future
A publisher that eventually produces a single value and then finishes or fails.<br>
최종적으로 하나의 값을 생성한 후 완료되거나 실패하는 Publisher(혼자 클래스임)

```Swift
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final public class Future<Output, Failure> : Publisher where Failure : Error {

    public typealias Promise = (Result<Output, Failure>) -> Void

    public init(_ attemptToFulfill: @escaping (@escaping Future<Output, Failure>.Promise) -> Void)

    final public func receive<S>(subscriber: S) where Output == S.Input, Failure == S.Failure, S : Subscriber
}

Future<Void, Error> { [weak self] promise in 
  self?.db.child(DBKey.Chats).child(chatRoomId).child(object.chatId).setValue(value) {
  error, _ in
    if let error {
    promise(.failure(error))
      } else {
        promise(.success(()))
      }
  }
}
//db에 값을 세팅한 후 결과값을 방출하는 Future
```
- 비동기 네트워크 요청 결과를 퍼블리싱할 때
- 데이터베이스 쿼리 결과를 Combine 스트림으로 래핑할 때
- 구독자가 여러 명일 경우 각 구독마다 별도의 작업이 실행됨
- 단일 값만 발행하므로 여러 결과를 처리할 수 없음
- Future는 클로저를 통해 비동기 작업을 수행하고, 작업 완료 시 결과를 구독자에게 전달합니다. 구독자가 구독을 시작할 때 클로저가 실행됩니다.

<br>

## Deferred
A publisher that awaits subscription before running the supplied closure to create a publisher for the new subscriber.<br>
퍼블리셔의 생성을 구독 시점까지 지연시키는 퍼블리셔입니다.
```Swift
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct Deferred<DeferredPublisher> : Publisher where DeferredPublisher : Publisher {

    public typealias Output = DeferredPublisher.Output

    public typealias Failure = DeferredPublisher.Failure

    public let createPublisher: () -> DeferredPublisher

    public init(createPublisher: @escaping () -> DeferredPublisher)

    public func receive<S>(subscriber: S) where S : Subscriber, DeferredPublisher.Failure == S.Failure, DeferredPublisher.Output == S.Input
}
Deferred {
    Future<Int, Never> { promise in
        // 퍼블리셔 생성 로직
        promise(.success(100))
    }
}
```
- 구독자가 구독을 시작할 때마다 새로운 퍼블리셔를 생성하고자 할 때
- 퍼블리셔 생성 시점에 특정 로직을 실행해야 할 때
- 구독 시점에 퍼블리셔를 생성할 수 있어 유연성 제공
- 필요할 때마다 새로운 퍼블리셔 인스턴스를 생성 가능
- Deferred는 클로저를 통해 실제 퍼블리셔를 생성합니다. 구독자가 구독을 시작할 때 클로저가 호출되어 퍼블리셔를 반환하고, 그 퍼블리셔가 구독을 관리합니다.

<br>


