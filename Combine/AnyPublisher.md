# AnyPublisher
A publisher that performs type erasure by wrapping another publisher.<br>
Combine프레임워크에서 제공하는 타입 소거(type erasure) 퍼블리셔<br><br>

AnyPublisher는 자체적으로는 특별한 속성을 가지지 않으며, 업스트림 퍼블리셔로부터 전달된 요소와 완료 이벤트를 그대로 통과(pass through) 시킵니다.

```Swift
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@frozen public struct AnyPublisher<Output, Failure> : CustomStringConvertible, CustomPlaygroundDisplayConvertible where Failure : Error {

    /// A textual representation of this instance.
    ///
    /// Calling this property directly is discouraged. Instead, convert an
    /// instance of any type to a string by using the `String(describing:)`
    /// initializer. This initializer works with any type, and uses the custom
    /// `description` property for types that conform to
    /// `CustomStringConvertible`:
    ///
    ///     struct Point: CustomStringConvertible {
    ///         let x: Int, y: Int
    ///
    ///         var description: String {
    ///             return "(\(x), \(y))"
    ///         }
    ///     }
    ///
    ///     let p = Point(x: 21, y: 30)
    ///     let s = String(describing: p)
    ///     print(s)
    ///     // Prints "(21, 30)"
    ///
    public var description: String { get }

    public var playgroundDescription: Any { get }

    @inlinable public init<P>(_ publisher: P) where Output == P.Output, Failure == P.Failure, P : Publisher
}
```
<br><br>

## 타입 소거

*(타입의 구체적인 구현을 숨기고 추상화된 타입으로 대체하는 프로그래밍 기법)*
퍼블리셔의 구체적인 타입을 숨기고, AnyPublisher라는 추상화된 타입으로 대체합니다.<br>

#### 왜 타입 소거가 필요할까?
- 유연성: 퍼블리셔의 내부 구현을 변경해도 외부 클라이언트 코드는 수정할 필요가 없습니다.
- 모듈화: 서로 다른 모듈 간에 구현 세부 사항을 숨기고, 공통된 인터페이스만 노출하여 의존성을 줄일 수 있습니다.
- 간결성: 복잡한 퍼블리셔 체인의 타입을 간결화하여 코드의 가독성을 높일 수 있음.   
```Swift
import Combine
import Foundation

// 데이터 모델 정의 (예시)
struct MyData: Decodable {
    let id: Int
    let name: String
}

// API 서비스 클래스
class APIService {
    // URL 정의
    private let url = URL(string: "https://example.com/data")!
    
    // 데이터 요청 메서드
    func fetchData() -> AnyPublisher<MyData, URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MyData.self, decoder: JSONDecoder())
            .eraseToAnyPublisher() // AnyPublisher로 타입 소거
    }
}
```
<br>
- 업스트림 = 데이터 흐름의 시작점(데이터 생산자)<br>
- 다운 스트림 = 데이터 흐름의 종착점(데이터 소비자)
