## compactMap

### 배열에서 옵셔널 값을(nil) 값을 제거하고 나머지 값을 포함하는 배열을 반환

```Swift
let optionalNumbers: [Int?] = [1, nil, 3, nil, 5]
let nonNilNumbers = optionalNumbers.compactMap { number in
    number
}
//[1, 3, 5]
```

#### 타입변경할 때도 사용 가능

<img width="260" alt="image" src="https://github.com/dongykung/SwiftUIStudy/assets/92030316/e991f05c-aecf-4e16-9066-8c7714728e38">
<br>
문자열 속에서 숫자만 추출하여 합을 구해봅시다


```Swift
func solution(_ my_string:String) -> Int {
     return my_string.compactMap{Int(String($0))}.reduce(0,+)
}
```

