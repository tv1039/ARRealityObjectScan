
## Project Overview (프로젝트 개요)
RealityObjectScan은 현실 세계에서 사물을 인식하고, </br>
거기에 해당하는 가상 3D 모델을 실시간으로 투영하여 사용자에게 보여주는 앱입니다. </br>
이 프로젝트는 AR 기술의 활용과 함께 Firebase의 데이터베이스 및 저장소 기능을 활용하여 사용자에게 기존 2D이상의 3D 경험을 제공합니다.

## Project Goals (프로젝트 목표)
RealityObjectScan의 목표는 사용자들이 현실 세계를 AR을 통해 더욱 흥미롭고 상호작용적으로 경험할 수 있도록 하는 것입니다. </br>
사용자가 주변 사물을 식별하고 그에 상응하는 가상 객체를 시각적으로 탐색함으로써 새로운 경험을 제공하고,</br>
인식된 사물에 대한 3D 모델과 모델의 정보를 제공하는게 목적입니다.

## Key Features and Technical Details (중요기능과 기술 정보)
- **사물 인식**: `CoreML`과 `Vision` 프레임워크를 활용하여 실시간으로 주변 환경을 분석하고, 사물을 인식합니다.
- **가상 객체 투영**: Firebase의 저장소에서 다운로드한 3D 모델을 사용하여 인식된 사물에 해당하는 가상 객체를 투영합니다.
- **사물 정보 제공**: Firebase Firestore를 사용하여 인식된 사물의 정보를 가져와 사용자에게 제공합니다.
- **자동/수동 모드**: 사용자는 자동 모드에서는 카메라를 통해 인식된 사물에 대응하는 가상 객체를 자동으로 표시하고, 수동 모드에서는 화면을 탭하여 특정 사물을 선택할 수 있습니다.

### Implementation Details (구현 세부 내용)
이 프로젝트에서 주요 역할은 AR 모델과 사물 인식 부분입니다.</br>
`CoreML` 및 `Vision` 프레임워크를 사용하여 실시간으로 딥러닝한 사물을 스캔하고 인식합니다. </br>
Firebase Firestore 및 Storage를 활용하여 객체 정보를 관리하였습니다. </br>
또한 `SwiftUI`와 `Combine`을 사용하여 사용자 인터페이스를 설계하고 구현하였습니다.

### Key Functionality Code Snippets and Explanations (중요 기능과 코드 설명)
```swift
func recognizeObjectFromCurrentFrame() {
    // 현재 프레임에서 사물 인식을 수행하는 메서드입니다.
    // Vision 프레임워크를 사용하여 주변 환경을 분석하고 사물을 인식합니다.
    // 인식된 사물의 이름을 객체로 설정하고 해당하는 가상 객체를 업데이트합니다.
}

func updateARModel() {
    // 가상 객체를 업데이트하는 메서드입니다.
    // Firebase 저장소에서 다운로드한 3D 모델을 사용하여 인식된 사물에 해당하는 가상 객체를 투영합니다.
    // 새로운 객체가 인식될 때마다 해당하는 3D 모델을 불러와 AR 뷰에 표시합니다.
}

func getObjectInfo(objectName: String, completion: @escaping (ObjectModel?, Error?) -> Void) {
    // Firestore에서 객체 정보를 가져오는 메서드입니다.
    // objectName을 이용하여 Firestore에서 해당 객체의 정보를 가져옵니다.
    // 가져온 정보를 ObjectModel 객체로 디코딩하여 completion 핸들러를 호출합니다.
}
```
이 코드들은 프로젝트의 핵심 기능을 수행하는 함수들입니다. </br>
`recognizeObjectFromCurrentFrame()` 함수는 현재 카메라 프레임에서 사물을 인식하고,</br>
인식된 사물의 이름을 객체로 설정하여 가상 객체를 업데이트합니다. </br></br>
`updateARModel()` 함수는 Firebase에서 다운로드한 3D 모델을 사용하여 인식된 사물에 해당하는 가상 객체를 투영합니다.</br>
마지막으로 `getObjectInfo()` 함수는 Firestore에서 해당 객체의 데이터를 가져와 사용자에게 제공합니다. </br>
이 메서드들 사용자에게 현실과 가상 세계를 융합한 구현을 제공하는 데 중요한 역할을 했습니다.
</br></br>
## TroubleShooting
3D 모델을 로드하기 전, 3D 텍스트 로드하는 과정으로 우선 테스트를 진행하였습니다.</br></br>
<img src ="https://github.com/tv1039/ARRealityObjectScan/assets/62321931/5763366f-4b22-4242-8160-ef66e2283497" width="500px" /></br>
이 테스트 단계에서는 알아채지 못했던 문제를 발견했습니다. </br></br>
3D 모델로 전환한 후 관찰한 결과, 장치 기준의 앵커인 `cameraTransform`를 사용하면 3D 모델이 뷰에 잡히지 않는 외부 위치에 배치되거나 예상치 못한 곳에 나타날 수 있다는 것을 깨달았습니다.</br></br>
<img src ="https://github.com/tv1039/ARRealityObjectScan/assets/62321931/2907c227-7b25-4e5f-9056-62cb6e38cf26" width="500px" /></br>
</br>
해결 방법은 앵커를 장치 기준에서 객체의 기준 앵커 `worldTransform`로 전환하는 것이었습니다. 이 방안으로 문제가 해결되었고, 3D 모델이 AR 환경에 정확하게 배치되었습니다. </br>
이 경험으로 ARKit과 RealityKit을 사용할 때 앵커 포인트를 올바르게 설정하는 것의 중요성을 깨달았습니다. </br>
이는 실제 세계에서 3D 객체를 정확하게 배치하기 위해 AR 앱을 개발할 때 고려해야 할 중요한 요소라고 생각합니다. </br>
[Solutions in Blog](https://velog.io/@messeung/SwiftUI-ARKit-%EB%B0%8F-Core-ML%EC%9D%84-%EC%9D%B4%EC%9A%A9%ED%95%9C-%EC%8B%A4%EC%8B%9C%EA%B0%84-%EC%82%AC%EB%AC%BC-%EC%9D%B8%EC%8B%9D3) - 블로그 보러가기

## Implementation goal (목표 구현)
자동/수동 모드에 따른 테스트를 거친후 원하는 방향으로 3D모델과 동시에 인식된 객체를 설명하는 뷰의 구성을 완성하였습니다.</br></br>
<img src="https://github.com/tv1039/ARRealityObjectScan/assets/62321931/757206a9-40b9-4a54-bf7d-82eac888efb7" width="500px" />
<img src="https://github.com/tv1039/ARRealityObjectScan/assets/62321931/e99971db-31e2-43b4-8a88-8e1f5544a0b1" width="500px" />
</br></br>

### Technologies Used
- `SwiftUI`
- `Combine`
- `ARKit`
- `RealityKit`
- `Firebase`
- `CoreML`
- `Vision`

