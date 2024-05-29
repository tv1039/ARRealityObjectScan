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

class TrainigDataModel: ObservableObject {
    @Published var arModel : ARModel
    @Published var recognizeObject: String = "인식이 되지 않았습니다."
    @Published var model = try! VNCoreMLModel(for: RealityObjectScanTrainingData().model)
    @Published var isManualMode: Bool = false
    
    var timer: Timer?
    
    init(arModel: ARModel) {
        self.arModel = arModel
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.ContinuouslyViewUpdated()
        }
    }
    
    func recognizedObjectSettings(newObj: String) {
        recognizeObject = newObj
    }
    
    func ContinuouslyViewUpdated() {
        guard !isManualMode else { return }
        recognizeObjectFromCurrentFrame()
        DispatchQueue.main.async {
            self.updateARText()
        }
    }
    
    func updateARText() {
        // Remove all existing anchors
        if arModel.arView.scene.anchors.count > 0 {
            arModel.arView.scene.anchors.removeAll()
        }

        // Create the AR Text to place on the screen
        let shader = SimpleMaterial(color: .red, roughness: 1, isMetallic: true)
        let text = MeshResource.generateText(
            "\(recognizeObject)",
            extrusionDepth: 0.05,
            font: .init(name: "Helvetica", size: 0.05)!,
            alignment: .center
        )

        let textEntity = ModelEntity(mesh: text, materials: [shader])

        let transform = arModel.arView.cameraTransform

        // Set the transform (the 3d location) of the text to be near the center of the camera, and 1/2 meter away
        let trans = simd_float4x4(transform.matrix)
        let anchEntity = AnchorEntity(world: trans)
        textEntity.position.z -= 0.5 // place the text 1/2 meter away from the camera along the Z axis

        // Find the width of the entity in order to have the text appear in the center
        let minX = text.bounds.min.x
        let maxX = text.bounds.max.x
        let width = maxX - minX
        let xPos = width / 2

        textEntity.position.x = transform.translation.x - xPos

        anchEntity.addChild(textEntity)

        // Add this anchor entity to the scene
        arModel.arView.scene.addAnchor(anchEntity)
    }
    
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
        
        if observations.first?.confidence ?? 0.0 < 0.6 {
                DispatchQueue.main.async { [weak self] in
                    self?.recognizeObject = "데이터가 존재하지 않습니다."
                }
                return
            }
        
        let topLabelObservation = observations.first?.identifier
        let firstWord = topLabelObservation?.components(separatedBy: [","]).first

        if recognizeObject != firstWord {
            DispatchQueue.main.async { [weak self] in
                self?.recognizedObjectSettings(newObj: firstWord ?? "")
            }
            print(recognizeObject)
        }
    }
}
