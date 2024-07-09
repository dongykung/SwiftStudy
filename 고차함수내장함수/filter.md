## filter

### 컬렉션의 요소 중에서 주어진 조건을 만족하는 요소들만 포함하는 새로운 컬렉션 반환

```Swift
let numbers: [Int] = [1,2,3,4,5]
let evenNumbers = numbers.filter { number in
    number % 2 == 0 
    }
print(evenNumbers)
//[2, 4]
```
<br>

#### 범위 연산자에 대해서도 가능
```Swift
let range = 0...12
let evenRange = range.filter { $0 % 2 == 0 }
print(evenRange)
//[0, 2, 4, 6, 8, 10, 12]
```

<br>

#### 문자열에 대해서도 가능, 문자열을 반환해줌
```Swift
let myName = "DongKyung"
let deleteN = "n"
let newName = myName.filter { String($0) != deleteN }
print(newName)
//DogKyug
```




