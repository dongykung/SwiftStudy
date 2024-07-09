## Map

### 컬렉션의 각 요소에 동일한 변환을 적용하여 새로운 컬렉션 반환

```Swift
let numbers: [Int] = [1,2,3,4,5]
let squaredNumbers = numbers.map { number in
    //클로저 사용 방식 1
    number * number
}
print(squaredNumbers)
//[1, 4, 9, 16, 25]
```

<br>

#### in, return 키워드 생략 후 $0로 접근 가능
```Swift
let firends: [String] = ["동경", "윤성", "영준", "재행"]
let firendsSir = firends.map { 
    //클로저 사용 방식 2
    $0 + "Sir"
}
print(firendsSir)
//["동경Sir", "윤성Sir", "영준Sir", "재행Sir"]
```

<br>

#### enumerated()를 사용하여 index 접근 가능
```Swift
let fiveNumbers = [1,2,3,4,5]

fiveNumbers.enumerated().map{ (index, value) in 
    print("\(index), \(value)")
}
/*
0 1
1 2
2 3
3 4
4 5
*/
```

