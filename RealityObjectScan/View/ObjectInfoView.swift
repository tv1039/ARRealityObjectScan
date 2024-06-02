//
//  ObjectInfoView.swift
//  RealityObjectScan
//
//  Created by 홍승표 on 6/2/24.
//

import SwiftUI
import RealityKit

struct ObjectInfoView: View {
    @EnvironmentObject var trainigDataModel: TrainigDataModel
    
    var body: some View {
        VStack {
            Text(trainigDataModel.objectInfo?.name ?? "객체이름")
                .font(.title)
                .foregroundStyle(.white)
                .padding(.bottom, 5)
            Text(trainigDataModel.objectInfo?.description ?? "객체설명")
                .foregroundStyle(.white)
        }
        .frame(width: 200)
        .padding()
        .background(Color.black.opacity(0.7))
    }
}

#Preview {
    ObjectInfoView()
        .environmentObject(TrainigDataModel(arModel: ARModel(arView: ARView(frame: .zero))))
    
}
