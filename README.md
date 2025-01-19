# cakeTimer

---

목차 
1. 프로젝트 개요
2. 도입 전과 도입 후 비교
3. 주요 기술적 이슈와 해결 과정

---

### 1. 프로젝트 개요
투썸플레이스에서는 홀케익이 매출에서 차지하는 비중이 상당히 큽니다. 그렇기에 평소에도 많은 주문이 들어오는데 일반적인 음료 제조와는 한 가지 다른 점이 있습니다. 해동이 덜 된 상태의 케익이 고객에게 인도되면 안 된다는 점입니다. 홀케익의 해동 시간은 6시간 정도로 예를 들어 오늘 오후 2시에 쇼케이스에 진열했다면 오후 8시 전까지는 고객에게 설명 없이 판매되어서는 안 됩니다. 이를 위해 기존에는 쇼케이스 진열 시간을 타임스탬프로 케익 판 뒷면에 붙여 관리했었는데 이는 케익 판매 시 그리고 케익 진열 시에 상당한 불편한 점이 있었습니다. 그래서 현재 시간 - 진열 시간 = "해동 경과 시간"을 자동으로 관리해주는 앱을 만들어보았고 이는 다음 목차에서 설명하는 효과를 가져왔습니다.

### 2. 도입 전과 도입 후 비교
cakeTimer 도입 전  
<img width="1356" alt="스크린샷 2025-01-19 오후 5 38 52" src="https://github.com/user-attachments/assets/498f6b65-49e4-4b6e-87e6-a903cf0aa27f" />

<img width="1361" alt="스크린샷 2025-01-19 오후 5 39 01" src="https://github.com/user-attachments/assets/8ebe0dea-08f1-4792-8e46-a0044261059d" />

cakeTimer 도입 후  
<img width="983" alt="스크린샷 2025-01-19 오후 5 29 29" src="https://github.com/user-attachments/assets/6179f350-fe4b-4ed6-bd81-31d114752569" />
<img width="990" alt="스크린샷 2025-01-19 오후 5 30 23" src="https://github.com/user-attachments/assets/1a928ea9-3072-40f2-a75e-b0e2dec2f082" />

cakeTimer를 도입하자 고객 응대 시 잠시 양해를 구한 뒤 쇼케이스에서 시간을 확인하는 프로세스가 없어져 훨씬 효율적으로 응대할 수 있었습니다.

















