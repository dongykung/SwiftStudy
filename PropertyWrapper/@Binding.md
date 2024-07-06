## @Binding


```Swift
@frozen @propertyWrapper @dynamicMemberLookup
struct Binding <Value>
```
  **_A property wrapper type that can read and write a value owned by a source of truth_**
  
  **단일 출처가 소유한 값을 읽고 쓸 수 있게 해주는 프로퍼티 래퍼**

<br><br>
### Q. 단일출처?
특정 데이터의 유일한 저장 장소입니다. 데이터는 여러 뷰에서 공유할 수 있지만 원본은 한 곳에만 있습니다.
<br>
<br>
값이 실제로 저장되어 있는 곳...

@State 로 선언된 변수의 값은 SwiftUI가 관리하는 저장소에 저장됩니다.

<br>

> $\color{#6E6E6E}\Huge{\textsf{단일 출처가 소유한 값을 읽고 쓸 수 있게 해준다 = @State의 상태 값을 읽고 쓸 수 있게 해준다?}}$


<br>
<br>


 ```Swift
struct PlayButton: View {
    @Binding var isPlaying: Bool
    var body: some View {
        Button(isPlaying ? "Pause" : "Play") {
            isPlaying.toggle()
        }
    }
}

struct PlayerView: View {
    @State private var isPlaying: Bool = false
    var body: some View {
        VStack {
        	//PlayButton 바인딩과 연결하기 위해 @State 변수에 $붙여 전달
            PlayButton(isPlaying: $isPlaying) // Pass a binding.
        }
    }
}
```


<br>
@Binding을 사용하여 데이터를 저장하는 속성과 데이터를 표시하고 상위 뷰 사이에 양방향 연결을 생성합니다. 

**바인딩은 데이터를 직접 저정하는 대신 속성을 다른 곳에 저장된 단일 출처에 연결합니다.**

<br>
이렇게 하면 PlayButton에서 PlayerView에서 생성된 isPlaying의 값을 읽고 쓰기가 가능해집니다.

<br>
<br>
<br>

 $\color{#6E6E6E}\Huge{\textsf{이런 방식을 왜 사용하며, 어떤 이점이 있을가?}}$
 - 상위 뷰와 하위 뷰 간의 상태를 공유하고 일관되게 유지할 수 있습니다.
 - 하위 뷰에서 상위 뷰의 상태를 읽고 하위 뷰에서 상태를 변경할 수 있게됩니다. **(양방향 데이터 연결)**
 - 상위 뷰, 하위 뷰에서 값을 변경해도 UI의 일관성을 가질 수 있습니다.
 - 하위 뷰를 독립적으로 사용할 수 있게됩니다. 상위 뷰의 상태를 바인딩으로 받기 때문에 여러 상위 뷰에서 동일하게 사용할 수 있습니다. **(코드 재사용 높아짐)**
 
