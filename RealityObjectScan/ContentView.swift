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
    @StateObject var trainingDataModel: TrainigDataModel
    
    var body: some View {
        ZStack {
            ARViewContainer(trainingDataModel: trainingDataModel)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    Button {
                        trainingDataModel.isManualMode.toggle()
                        if trainingDataModel.isManualMode {
                            trainingDataModel.recognizeObject = ""
                        }
                    } label: {
                        Image(systemName: trainingDataModel.isManualMode ? "autostartstop" : "autostartstop.slash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .tint(.white)
                    }
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .fill(.black).opacity(0.5)
                            .frame(width: 40, height: 40)
                    )
                    .padding()
                }
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
      
    
    class Coordinator: NSObject {
        var parent: ARViewContainer
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            if parent.trainingDataModel.isManualMode {
                let location = sender.location(in: parent.trainingDataModel.arModel.arView)
                let hitTestResults = parent.trainingDataModel.arModel.arView.hitTest(location, types: .existingPlaneUsingExtent)
                
                if let firstResult = hitTestResults.first {
                    let anchor = ARAnchor(transform: firstResult.worldTransform)
                    parent.trainingDataModel.arModel.arView.session.add(anchor: anchor)
                }
                
                parent.trainingDataModel.recognizeObjectFromCurrentFrame()
                
            }
        }
    }





//#Preview {
//    let arModel = ARModel(arView: ARView())
//    let trainingDataModel = TrainigDataModel(arModel: arModel)
//    ContentView(trainingDataModel: trainingDataModel)
//}
