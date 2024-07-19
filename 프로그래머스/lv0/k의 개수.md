### 1부터 13까지의 수에서, 1은 1, 10, 11, 12, 13 이렇게 총 6번 등장합니다. 정수 i, j, k가 매개변수로 주어질 때, i부터 j까지 k가 몇 번 등장하는지 return 하도록 solution 함수를 완성해주세요.
<hr>

제한사항
- 1 ≤ i < j ≤ 100,000
- 0 ≤ k ≤ 9

<img width="350" alt="image" src="https://github.com/user-attachments/assets/83bdf59f-c79c-4b55-a779-97c72e8683a9">

#### 내 풀이
```Swift
func solution(_ i:Int, _ j:Int, _ k:Int) -> Int {
    var count: Int = 0
    for num in i...j {
        var number = num
        while number > 0 {
            if number % 10 == k {
                count += 1
            }
            number /= 10
        }
    }
    return count
}
```
- 각 숫자마다 자릿 수 숫자가 k와 같다면 count를 증가시키는 방법

<br>

#### 다른 사람의 풀이
```Swift
func solution(_ i:Int, _ j:Int, _ k:Int) -> Int {
    return (i...j)
    .map { 
        String($0).filter { String($0) == String(k) }.count
    }
    .reduce(0, +)
}
```
- ...map 안쪽에서 $0에 대해서도 따로 filter가 가능하다는 사실을 처음 알게됨


