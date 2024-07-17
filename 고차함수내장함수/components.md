## components

### 문자열을 특정 구분자를 기준으로 나누어 배열을 반환

<br>

#### 매개변수로 ,(콤마) 를 주었을 때
```Swift
let str = "apple,banana,orange"
let fruits = str.components(separatedBy: ",")
// ["apple", "banana", "orange"]
```
<br>

#### 매개변수로 한 칸을 주었을 때
```Swift
let sentence = "Hello world Swift"
let words = sentence.components(separatedBy: " ")
// ["Hello", "world", "Swift"]
```
