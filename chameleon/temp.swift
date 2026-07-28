//
//  temp.swift
//  chameleon
//
//  Created by 櫻田聖和 on 2026/07/25.
//

import SwiftUI
import RealityKit

struct tempView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
            VStack {
                Text("カメレオンをTapしてみましょう")
                    .foregroundStyle(Color.white)
                RealityView (make: { content in
                    if let model = try? await ModelEntity(named: "chameleon2.usdz") {
                        model.scale = [0.005, 0.005, 0.005]
                        content.add(model)
                        
                        content.camera = .spatialTracking
                    }
                }, placeholder: {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("カメレオンを描画中です...")
                                .foregroundStyle(Color.white)
                            Spacer()
                        }
                        Spacer()
                    }
                })
                .realityViewLayoutBehavior(.centered)
                
                //            .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
#Preview {
    tempView()
}
