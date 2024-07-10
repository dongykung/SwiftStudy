## reduce

### 컬렉션의 모든 요소를 하나의 값으로 축소합니다. 초기값과 결합 연산을 정의하는 클로저를 인자로 받습니다

<br> 


#### 배열의 합 구하기

```Swift
let numbers: [Int] = [1,2,3,4,5]
//초기 값을 설정하고 클로저를 통해 값을 설정합니다
//partialResult = 누적 값, number = 배열 값
let sum: Int = numbers.reduce(0) { partialResult, number in
    print("partialResult = \(partialResult), number = \(number)")
    return partialResult + number    
}
/*
  partialResult = 0, number = 1. 첫번째 초기값 0으로 설정 0 + 1
  partialResult = 1, number = 2  누적 합 1,  1 + 2
  partialResult = 3, number = 3  누적 합 3,  3 + 3
  partialResult = 6, number = 4  누적 합 6,  6 + 4
  partialResult = 10, number = 5 누적 합 10, 10 + 5
                                 누적 합 15
*/
```
<br>

#### 숨어있는 숫자의 덧셈 
<img width="272" alt="image" src="https://github.com/dongykung/SwiftUIStudy/assets/92030316/e188460a-f42a-4df6-9949-07256e03b46c">
<br>
위 예시와 달리 초기값 뒤에 +를 사용해 같은 기능을 구현할 수 있습니다

```Swift
func solution(_ my_string:String) -> Int {
     return my_string.compactMap{Int(String($0))}.reduce(0,+)
}
```


