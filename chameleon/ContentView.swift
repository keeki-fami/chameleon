//
//  ContentView.swift
//  chameleon
//
//  Created by 櫻田聖和 on 2026/07/17.
//

import SwiftUI
import RealityKit

enum Phase {
    case beforeTap
    case afterTap
}


struct ContentView: View {
    @State private var tap: CGPoint = CGPoint(x: 0, y: 0)
    @State private var trigger: Bool = false
    @State private var nowPhase: Phase = .beforeTap
    @State var bluetoothManager: BluetoothManager = BluetoothManager()
    @State var entity: Entity?
    
    
    var body: some View {
        switch nowPhase {
        case .beforeTap:
            ZStack {
                Rectangle()
                    .ignoresSafeArea()
                VStack {
                    Text("カメレオンをTapしてみましょう")
                        .foregroundStyle(Color.white)
                    RealityView (make: { content in
                        if let model = try? await ModelEntity(named: "chameleon2.usdz") {
                            model.scale = [0.005, 0.005, 0.005]
                            
                            model.generateCollisionShapes(recursive: true)

                            // Entityをタップ可能にする
                            model.components.set(InputTargetComponent())
                            
                            content.add(model)
                            
                            entity = model
                            
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
                .onTapGesture(coordinateSpace: .local) { location in
                    tap = location
                    print(tap.x, tap.y)
                }
                .keyframeAnimator(
                    initialValue: 1.0, trigger: trigger) {content, value in
                        content
                            .opacity(value)
                    } keyframes: { _ in
                        LinearKeyframe(0.0, duration: 2.0)
                    }
            
            
            // Tapした場所のエフェクト
            TouchView(tap: $tap)
                
            }
            
        case .afterTap:
            CamoflagueView(nowPhase: $nowPhase, state: .even)
        }
        
    }
}

struct SpreadTouchView: View {
    struct Value {
        var opacity: Double = 0
        var scale: CGFloat = 0
    }
    let delay: [CGFloat] = [0.0, 0.3, 0.6, 0.9, 1.2]
    @State private var isAppeared = false
    var body: some View {
        ZStack {
            ForEach(delay, id: \.self) { i in
                Circle()
                    .strokeBorder(.black, lineWidth: 1)
                    .frame(width: 100, height: 100)
                    .keyframeAnimator(initialValue: Value(), trigger: isAppeared) { content, value in
                        content
                            .opacity(value.opacity)
                            .scaleEffect(value.scale)
                        
                    } keyframes: { _ in
                        KeyframeTrack(\.opacity) {
                            LinearKeyframe(0, duration: 0 + i)
                            LinearKeyframe(1, duration: 1)
                            LinearKeyframe(0, duration: 1)
                        }
                        KeyframeTrack(\.scale) {
                            LinearKeyframe(1, duration: 0 + i)
                            LinearKeyframe(4, duration: 2)
                        }
                    }
            }
        }
        Button("push") {
            isAppeared.toggle()
        }
    }
}

#Preview {
//    ContentView()
    //    CamoflagueView()
    SpreadTouchView()
}
