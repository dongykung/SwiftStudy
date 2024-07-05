## SwiftUI PropertyWrapper

### @State
```Swift
@frozen @propertyWrapper 
struct State<Value>
```
  **_A property wrapper type that can read and write a value managed by SwiftUI._**

  **SwiftUI가 관리하는 값을 읽고 쓸 수 있는 프로퍼티 래퍼**
<br>
<br>

```Swift
struct ContentView: View {
	@State private var isPlaying: Bool = false
	
	var body: some View {
		Button(isPlaying ? "Pause" : "Play") {
			isPlaying.toggle()
		}
	}
}
```
<br>

$\color{#6E6E6E}\Huge{\textsf{언제, 왜 사용할까?}}$

- @State는 뷰의 상태를 관리하기 위해 사용되는 프로퍼티 래퍼입니다, 상태 관리 주체는 **`해당 뷰`** 입니다..
- SwiftUI에서 @State로 선언된 프로퍼티는 상태가 변경되면 상태를 사용하는 모든 뷰가 다시 렌더링 됩니다.
- UIKit에서 수동으로 변화를 관찰하고 반영했던 반면 상태가 바뀌면 자동으로 다시 그리기 때문에 항상 최신 값을 가질 수 있습니다.
- `private`으로 선언하여 다른 뷰에서 접근하지 않도록 합니다. 
