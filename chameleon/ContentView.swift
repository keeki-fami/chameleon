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
    @State var entity: Entity?
    let window = UIApplication.shared.connectedScenes.first as? UIWindowScene
    @Bindable var bluetoothManager: BluetoothManager
    @State var camTap = false
    
    
    var body: some View {
        switch nowPhase {
        case .beforeTap:
            ZStack {
                Rectangle()
                    .ignoresSafeArea()
                VStack {
                    Text("カメレオンをTapしてみましょう")
                        .foregroundStyle(Color.white)
                    Image("came")
                        .resizable()
                        .scaledToFit()
                        .onTapGesture(coordinateSpace: .global) { location in
                            print("tap")
                            camTap = true
                            
                            tap = location
                            print(tap.x, tap.y)
                            if camTap {
                                trigger.toggle()
                                // 通信をする
                                bluetoothManager.readValue()
                                
                                Task {
                                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                                    nowPhase = .afterTap
                                }
                            }
                        }
//                    RealityView (make: { content in
//                        if let model = try? await ModelEntity(named: "chameleon2.usdz") {
//                            model.scale = [0.005, 0.005, 0.005]
//                            
//                            model.generateCollisionShapes(recursive: true)
//
//                            // Entityをタップ可能にする
//                            model.components.set(InputTargetComponent())
//                            
//                            content.add(model)
//                            
//                            entity = model
//                            
//                            content.camera = .spatialTracking
//                        }
//                    }, placeholder: {
//                        VStack {
//                            Spacer()
//                            HStack {
//                                Spacer()
//                                Text("カメレオンを描画中です...")
//                                    .foregroundStyle(Color.white)
//                                Spacer()
//                            }
//                            Spacer()
//                        }
//                    })
//                    .realityViewLayoutBehavior(.centered)

                    //            .edgesIgnoringSafeArea(.all)
                    
                }
//                .onTapGesture(coordinateSpace: .local) { location in
//                    tap = location
//                    print(tap.x, tap.y)
//                    if camTap {
//                        trigger.toggle()
//                        // 通信をする
//                        bluetoothManager.readValue()
//                        
//                        Task {
//                            try? await Task.sleep(nanoseconds: 3_000_000_000)
//                            nowPhase = .afterTap
//                        }
//                    }
//                }
                .keyframeAnimator(
                    initialValue: 1.0, trigger: trigger) {content, value in
                        content
                            .opacity(value)
                    } keyframes: { _ in
                        LinearKeyframe(0.0, duration: 1.5)
                    }
                    .onAppear()
            
            
            // Tapした場所のエフェクト
            TouchView(tap: $tap)
            SpreadTouchView(tap: $tap, trigger: $trigger)
                
            }
            .contentShape(Rectangle())
            .onAppear() {
                camTap = false
            }
            
        case .afterTap:
            CamoflagueView(nowPhase: $nowPhase, bluetoothManager: bluetoothManager, state: .even)
        }
        
    }
}

#Preview {
    @Previewable @State var b: BluetoothManager = BluetoothManager()
    ContentView(bluetoothManager: b)
//        CamoflagueView(bluetoothManager: $b)
//    SpreadTouchView()
}
