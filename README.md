### RealityObjectScan

#### Project Overview (프로젝트 개요)
RealityObjectScan은 현실 세계에서 사물을 탐지하고, 거기에 해당하는 가상 3D 모델을 실시간으로 투영하여 사용자에게 보여주는 앱입니다. </br>
이 프로젝트는 AR 기술의 활용과 함께 Firebase의 데이터베이스 및 저장소 기능을 활용하여 사용자에게 기존 2D이상의 3D 경험을 제공합니다.

#### Project Goals (프로젝트 목표)
RealityObjectScan의 목표는 사용자들이 현실 세계를 AR을 통해 더욱 흥미롭고 상호작용적으로 경험할 수 있도록 하는 것입니다. </br>
사용자가 주변 사물을 식별하고 그에 상응하는 가상 객체를 시각적으로 탐색함으로써 새로운 경험을 제공하고,</br>
인식된 사물에 대한 3D 모델과 모델의 정보를 제공하는게 목적입니다.

#### Key Features and Technical Details (중요기능과 기술 정보)
- **사물 인식**: CoreML과 Vision 프레임워크를 활용하여 실시간으로 주변 환경을 분석하고, 사물을 인식합니다.
- **가상 객체 투영**: Firebase의 저장소에서 다운로드한 3D 모델을 사용하여 인식된 사물에 해당하는 가상 객체를 투영합니다.
- **사물 정보 제공**: Firebase Firestore를 사용하여 인식된 사물의 정보를 가져와 사용자에게 제공합니다.
- **자동/수동 모드**: 사용자는 자동 모드에서는 카메라를 통해 인식된 사물에 대응하는 가상 객체를 자동으로 표시하고, 수동 모드에서는 화면을 탭하여 특정 사물을 선택할 수 있습니다.

#### Implementation Details" (구현 세부 내용)
이 프로젝트에서 제가 맡은 주요 역할은 AR 모델과 사물 인식 부분을 담당하였습니다.</br>
CoreML 및 Vision 프레임워크를 사용하여 실시간으로 사물을 인식하고, </br>
Firebase Firestore 및 Storage를 활용하여 객체 정보를 관리하였습니다. </br>
또한 SwiftUI와 Combine을 사용하여 사용자 인터페이스를 설계하고 구현하였습니다.

### Key Functionality Code Snippets and Explanations (중요 기능과 코드 설명)
```swift
func recognizeObjectFromCurrentFrame() {
    // 현재 프레임에서 사물 인식을 수행하는 함수
    // CoreML 및 Vision 프레임워크를 사용하여 주변 환경을 분석하고 사물을 인식합니다.
    // 인식된 사물의 이름을 객체로 설정하고 해당하는 가상 객체를 업데이트합니다.
}

func updateARModel() {
    // 가상 객체를 업데이트하는 함수
    // Firebase 저장소에서 다운로드한 3D 모델을 사용하여 인식된 사물에 해당하는 가상 객체를 투영합니다.
    // 새로운 객체가 인식될 때마다 해당하는 3D 모델을 불러와 AR 화면에 표시합니다.
}

func getObjectInfo(objectName: String, completion: @escaping (ObjectModel?, Error?) -> Void) {
    // Firestore에서 객체 정보를 가져오는 함수
    // objectName을 이용하여 Firestore에서 해당 객체의 정보를 가져옵니다.
    // 가져온 정보를 ObjectModel 객체로 디코딩하여 completion 핸들러를 호출합니다.
}
```
이 코드들은 프로젝트의 핵심 기능을 수행하는 함수들입니다. </br>
recognizeObjectFromCurrentFrame() 함수는 현재 카메라 프레임에서 사물을 인식하고, </br>
인식된 사물의 이름을 객체로 설정하여 가상 객체를 업데이트합니다. </br></br>

updateARModel() 함수는 Firebase에서 다운로드한 3D 모델을 사용하여 인식된 사물에 해당하는 가상 객체를 투영합니다. </br>
마지막으로 getObjectInfo() 함수는 Firestore에서 해당 객체의 정보를 가져와 사용자에게 제공합니다. </br>
이러한 함수들은 프로젝트의 중요한 기능을 구현하는 데 사용되며, </br>
사용자에게 현실과 가상 세계를 융합한 구현을 제공하는 데 중요한 역할을 했습니다.

#### Results and Achievements (결과와 각오)
RealityObjectScan은 사용자들에게 현실과 가상 세계를 융합한 증강현실 경험을 제공하는 데 성공하였습니다. </br>
이 프로젝트를 통해 저는 AR 기술을 활용한 애플리케이션 개발 및 Firebase의 데이터베이스 및 저장소 기능 활용에 대한 원리와 이해를 얻었으며,</br>
꾸준한 서치와 시도로 문제 해결 능력을 향상시킬 수 있었습니다.</br>
앞으로도 더욱 다양하고 사용자들에게 있어서 흥미로운 프로젝트에 도전하여 성장해 나가겠습니다.







