//
//  ContentView.swift
//  RealityObjectScan
//
//  Created by 홍승표 on 5/27/24.
//

import SwiftUI
import ARKit
import RealityKit

struct ContentView : View {
    @EnvironmentObject var trainingDataModel: TrainigDataModel
    
    var body: some View {
        ZStack {
            ARViewContainer(trainingDataModel: trainingDataModel)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    HStack {
                        Text("Manual")
                            .foregroundColor(.white)
                            .font(.subheadline)
                        Toggle("", isOn: $trainingDataModel.isAutoMode)
                            .labelsHidden()
                            .onChange(of: trainingDataModel.isAutoMode) { newValue, oldValue in
                                // 모드가 변경될 때마다 모든 앵커 제거 및 recognizeObject 초기화
                                trainingDataModel.arModel.arView.scene.anchors.removeAll()
                                trainingDataModel.recognizeObject = ""
                                trainingDataModel.currentAnchor = nil
                            }
                        Text("Auto")
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .clipShape(Capsule())
                    .frame(width: 300, height: 40)
                }
                Spacer()
                HStack {
                    Spacer()
                    if !trainingDataModel.recognizeObject.isEmpty && trainingDataModel.recognizeObject != "데이터가 존재하지 않습니다." {
                        ObjectInfoView()
                    }
                }
                .padding()
                Spacer()
            }
            VStack {
                Spacer()
                Text(trainingDataModel.recognizeObject)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }
        }
    }
}


struct ARViewContainer: UIViewRepresentable {
    var trainingDataModel: TrainigDataModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = trainingDataModel.arModel
        let view = arView.arView
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.arView.addGestureRecognizer(tapGestureRecognizer)
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

// TapHandler
class Coordinator: NSObject {
    var parent: ARViewContainer
    
    init(_ parent: ARViewContainer) {
        self.parent = parent
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if !parent.trainingDataModel.isAutoMode {
            let location = sender.location(in: parent.trainingDataModel.arModel.arView)
            let hitTestResults = parent.trainingDataModel.arModel.arView.hitTest(location, types: .existingPlaneUsingExtent)
            
            if let firstResult = hitTestResults.first {
                let anchor = ARAnchor(transform: firstResult.worldTransform)
                parent.trainingDataModel.arModel.arView.session.add(anchor: anchor)
            }
            
            parent.trainingDataModel.recognizeObjectFromCurrentFrame()
            parent.trainingDataModel.updateARModel()
            
        }
    }
}





#Preview {
    ContentView()
        .environmentObject(TrainigDataModel(arModel: ARModel(arView: ARView(frame: .zero))))
}
