## sorted

### 컬렉션의 요소를 정렬하여 새로운 배열을 반환, 정렬 기준을 정의하는 클로저를 인자로 받을 수 있습니다.


기본 sorted()함수를 사용하면 오름차순을 적용하여 배열을 반환해주는 것을 확인가능
```Swift
let numbers: [Int] = [5,2,55,75,1]
let sortedNumbers = numbers.sorted()
print(sortedNumbers)
//[1, 2, 5, 55, 75]
```
<br>

내림차순으로 정렬하고 싶다면?
```Swift
//내림차순으로 정렬하고 싶다면?
var reverseNumbers = numbers.sorted { number1, number2 in
    number1 > number2
  //앞 숫자가 뒷 숫자보다 큽니다
    }
print(reverseNumbers)
//[75, 55, 5, 2, 1]
```

<br>

클로저 생략으로 간단하게 사용하는 방법
```Swift
//클로저 생략을 통해 이런 방식으로도 가능합니다
let numbers2: [Int] = [24,1,2,44,62,6]
let reverseNumbers2 = numbers2.sorted(by: >)
print(reverseNumbers2)
//[62, 44, 24, 6, 2, 1]
```

<br>

구조체나 클래스의 프로퍼티 순으로도 정렬 가능합니다.
- 여러 사람들이 있고 나이 순으로 정렬하는 예제
  
```Swift
struct Person {
    var name: String
    var age: Int
}
let person1 = Person(name: "동경", age: 26)
let person2 = Person(name: "길동", age: 27)
let person3 = Person(name: "더콰", age: 33)
let person4 = Person(name: "훈이", age: 12)

let persons: [Person] = [person1, person2, person3, person4]

//나이순으로 정렬할 것이기 때문에 .age < 작성
let sortAgePersons = persons.sorted { $0.age < $1.age }
for person in sortAgePersons {
    print(person)
}
/*
 Person(name: "훈이", age: 12)
 Person(name: "동경", age: 26)
 Person(name: "길동", age: 27)
 Person(name: "더콰", age: 33) 
*/
```

