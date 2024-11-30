# Cancellable
A protocol indicating that an activity or action supports cancellation.<br>
Cancellable은 Combine 프레임워크에서 구독(subscription)을 관리하기 위해 사용되는 프로토콜입니다.

```Swift
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public protocol Cancellable {
    func cancel()
}
```
이 프로토콜은 단일 메서드인 cancel()을 정의하고 있으며, 이를 통해 구독을 취소할 수 있습니다.

*구독을 더 이상 필요로 하지 않을 때 cancel()을 호출하여 리소스를 해제하고 메모리 누수를 방지할 수 있습니다*


<br><br>

# AnyCancellable
A type-erasing cancellable object that executes a provided closure when canceled.<br>
AnyCancellable은 Cancellable 프로토콜을 채택하는 타입으로, 타입 소거(type-erased)된 형태입니다.
```Swift
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final public class AnyCancellable : Cancellable, Hashable {

    public init(_ cancel: @escaping () -> Void)

    public init<C>(_ canceller: C) where C : Cancellable

    final public func cancel()

    final public func hash(into hasher: inout Hasher)

    public static func == (lhs: AnyCancellable, rhs: AnyCancellable) -> Bool

    final public var hashValue: Int { get }
}
```
다양한 Cancellable 타입을 하나의 타입으로 통합하여 관리할 수 있게 해줍니다.

<br>
- 타입 소거: 특정 Cancellable 타입에 의존하지 않고, 모든 Cancellable을 동일한 타입으로 처리할 수 있습니다.
- 자동 취소: AnyCancellable 인스턴스가 해지될 때 자동으로 cancel()이 호출되어 구독이 취소됩니다.
- 스토리지 용이성: AnyCancellable을 사용하면 구독을 배열이나 다른 컬렉션에 쉽게 저장할 수 있음(타입 소거 때문).


```Swift
@Observable
class MyViewModel {
    var cancellables = Set<AnyCancellable>()
    
    let publisher = Just("Hello, Combine!")
    var myString: String = ""
    
    func getHello() {
        publisher
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure:
                    print("failed")
                }
            } receiveValue: { value in
                self.myString = value
            }
            .store(in: &cancellables)
    }
}
```
MyViewModel 뷰모델 인스턴스가 해지될 때 자동으로 구독이 취소됨.
