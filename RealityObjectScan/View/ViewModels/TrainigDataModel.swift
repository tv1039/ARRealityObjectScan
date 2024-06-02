//
//  TrainigDataModel.swift
//  RealityObjectScan
//
//  Created by 홍승표 on 5/27/24.
//

import Foundation
import Vision
import RealityKit
import CoreML
import ARKit
import SceneKit
import FirebaseStorage
import FirebaseFirestore

class TrainigDataModel: ObservableObject {
    
    @Published var arModel : ARModel
    @Published var recognizeObject: String = "인식이 되지 않았습니다."
    @Published var model = try! VNCoreMLModel(for: RealityObjectScanTrainingData().model)
    @Published var isAutoMode: Bool = false
    @Published var objectInfo: ObjectModel?
    
    var timer: Timer?
    var currentAnchor: AnchorEntity?
    var lastRecognizedObject: String?
    
    init(arModel: ARModel) {
        self.arModel = arModel
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.ContinuouslyViewUpdated()
        }
    }
    
    // 새로운 객체 인식 설정
      func recognizedObjectSettings(newObj: String) {
          recognizeObject = newObj
          FireStoreManager.shared.getObjectInfo(objectName: newObj) { [weak self] (object, error) in
              if let error = error {
                  print("객체 정보 가져오기 오류: \(error)")
              } else if let object = object {
                  self?.objectInfo = object
              } else {
                  print("이름 \(newObj)과 일치하는 객체가 없음")
              }
          }
      }
    
    // 자동 모드일 때 프레임을 지속적으로 업데이트
      func ContinuouslyViewUpdated() {
          guard isAutoMode else { return }
          recognizeObjectFromCurrentFrame()
          
          // 이전에 인식된 객체와 현재 인식된 객체가 다를 때만 AR 모델을 업데이트
          if recognizeObject != lastRecognizedObject {
                     lastRecognizedObject = recognizeObject
                     updateARModel()
                 }
      }
    
    // 현재 앵커 제거
    func removeCurrentAnchor() {
        if let currentAnchor = self.currentAnchor {
            self.arModel.arView.scene.removeAnchor(currentAnchor)
            self.currentAnchor = nil
        }
    }
    
    // AR 모델 업데이트
    func updateARModel() {
        
        // 새로운 객체 인식 되었때 앵커 업데이트
        let fileName = recognizeObject
        
        if fileName == "데이터가 존재하지 않습니다." {
            removeCurrentAnchor()
            return
        }
        
        FirebaseStorageManager.shared.downloadUSDZ(scanModelName: fileName) { [weak self] result in
            switch result {
            case .success(let url):
                do {
                    let scale: Float
                    
                    if fileName == "Chair" || fileName == "Table" {
                        scale = 0.0005
                    } else {
                        scale = 0.05
                    }
                    
                    let entity = try Entity.load(contentsOf: url)
                    
                    entity.scale = SIMD3(repeating: scale)
                    
                    let hitTestResults = self?.arModel.arView.raycast(from: CGPoint(x: (self?.arModel.arView.bounds.midX ?? 0), y: self?.arModel.arView.bounds.midY ?? 0), allowing: .estimatedPlane, alignment: .any)
                    
                    if let firstResult = hitTestResults?.first {
                        let anchor = AnchorEntity(world: firstResult.worldTransform)
                        anchor.addChild(entity)
                        self?.arModel.arView.scene.addAnchor(anchor)
                        
                        // 재생성 방지
                        // 기존 앵커를 제거
                        self?.removeCurrentAnchor()
                        // 새로운 앵커를 저장
                        self?.currentAnchor = anchor
                        
                    } else {
                        // 앵커 실패시 카메라 위치로 배치
                        let cameraTransform = self?.arModel.arView.cameraTransform
                        let cameraMatrix = cameraTransform?.matrix
                        let identityMatrix = matrix_identity_float4x4
                        let cameraAnchor = AnchorEntity(world: cameraMatrix ?? identityMatrix)
                        cameraAnchor.addChild(entity)
                        self?.arModel.arView.scene.addAnchor(cameraAnchor)
                        print("카메라 위치에 앵커를 배치했습니다.")
                        
                        // 재생성 방지
                        // 기존 앵커를 제거
                        self?.removeCurrentAnchor()
                        // 새로운 앵커를 저장
                        self?.currentAnchor = cameraAnchor
                        
                    }
                    
                } catch {
                    print("모델 불러오기 실패 \(url)")
                }
            case .failure(let error):
                print("USDZ 파일 다운로드 중 오류 발생: \(error)")
            }
        }
    }
    
    // 현재 프레임에서 객체 인식
    func recognizeObjectFromCurrentFrame() {
        
        let view = arModel.arView
        let session = view.session
        let model = model
        
        let tempImage: CVPixelBuffer? = session.currentFrame?.capturedImage
        
        if tempImage == nil {
            return
        }
        
        let tempciImage = CIImage(cvPixelBuffer: tempImage!)
        let request = VNCoreMLRequest(model: model) { (request, error) in }
        
        request.imageCropAndScaleOption = .centerCrop
        
        
        let handler = VNImageRequestHandler(ciImage: tempciImage, orientation: .right)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
        guard let observations = request.results as? [VNClassificationObservation] else {
            return
        }
        
        if observations.first?.confidence ?? 0.0 < 0.98 {
            recognizeObject = "데이터가 존재하지 않습니다."
            return
        }
        
        let topLabelObservation = observations.first?.identifier
        let firstWord = topLabelObservation?.components(separatedBy: [","]).first
        
        if recognizeObject != firstWord {
            recognizedObjectSettings(newObj: firstWord ?? "")
        }
        print(recognizeObject)
    }
}

