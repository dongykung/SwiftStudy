## joined

### 배열의 요소들을 하나의 문자열로 합치는 데 사용됩니다. 문자열 배열을 하나의 문자열로 합칠 때 유용

<br>

#### 매개변수로 , (콤마)
```Swift
let array = ["apple", "banana", "orange"]
let joinedString = array.joined(separator: ", ")
// "apple, banana, orange"
```

<br>

#### 매개변수로 " " (한 칸)
```Swift
let words = ["Hello", "world", "Swift"]
let sentence = words.joined(separator: " ")
// "Hello world Swift"
```

<br>


#### 매개변수로 아무것도 안줬을 때
```Swift
let characters = ["H", "e", "l", "l", "o"]
let word = characters.joined()
// "Hello"
```
