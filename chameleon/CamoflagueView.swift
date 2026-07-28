//
//  CamoflagueView.swift
//  chameleon
//
//  Created by 櫻田聖和 on 2026/07/21.
//
import SwiftUI

struct CamoflagueView: View {
    @State private var trigger = false
    @State private var trigger2 = false
    @State private var trigger3 = false
    @State private var trigger4 = false
    @Binding var nowPhase: Phase
    var state: ChameleonState
    
    struct DescriptionAnimation {
        var offsetY: CGFloat = -5.0
        var opacity = 0.0
    }
    
    var body: some View {
        
            ScrollView {
                VStack {
                    Group {
                        Rectangle()
                            .fill(.black)
                            .frame(width: 300, height: 300)
                        LazyVStack {
                            Text(
                                state == .even ?
                                "カメレオンはあなたに好意を持っているようです！" :
                                    "カメレオンはあなたを警戒しているようです。"
                            )
                            .onAppear {
                                print("描画された")
                                trigger = true
                            }
                            .font(.title)
                            .padding()
                            Rectangle()
                                .fill(.black)
                                .frame(width: 300, height: 50)
                            Text("Please Scroll")
                            Image("Union")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            
                        }
                        .keyframeAnimator(
                            initialValue: DescriptionAnimation(), trigger: trigger) {content, value in
                                content
                                    .opacity(value.opacity)
                                    .offset(y: value.offsetY)
                            } keyframes: { _ in
                                KeyframeTrack(\.offsetY) {
                                    SpringKeyframe(-20, duration: 0)
                                    LinearKeyframe(0, duration: 0.5)
                                }
                                KeyframeTrack(\.opacity) {
                                    LinearKeyframe(0, duration: 0)
                                    LinearKeyframe(1, duration: 0.5)
                                }
                            }
                        Rectangle().fill(.black)
                            .frame(width: 200, height: 200)
                        
                        LazyVStack() {
                            if state == .even {
                                Text("カメレオンは普段は緑色の体をしていますが、敵などから身を守るために体の色を変化させ、背景に溶け込むようにします。")
                                    .onAppear {
                                        print("描画された")
                                    }
                                Rectangle()
                                    .frame(width: 200, height: 200)
                                    .onAppear {
                                        trigger2 = true
                                    }
                                Text("というイメージが有名ですが、実はカメレオンの体色変化の目的は擬態ではないとされています。(私も製作中に知りました。)本来の目的はコミュニケーションで、背景色とは全く関係のない、明るい派手な色や暗い色に変化したりします。")
                                    .onAppear {
                                        print("描画された")
                                    }
                            } else {
                                Text("カメレオンは緑以外にも、体を様々な色を変化させることができます。")
                                Rectangle()
                                    .frame(width: 200, height: 200)
                                Text("理由は様々で、異性へのアピールやコミュニケーション、体調管理があげられます。明るい色の時は求愛行動をしていることが多く、暗い色の時はストレスを感じていたり、温度調整をしていることが多いそうです。机の上のカメレオンは、背景の保護色に変化して、あなたとコミュニケーションを取ろうとしているかもしれません。")
                            }
                        }
                        .keyframeAnimator(
                            initialValue: DescriptionAnimation(), trigger: trigger2) {content, value in
                                content
                                    .opacity(value.opacity)
                                    .offset(y: value.offsetY)
                            } keyframes: { _ in
                                KeyframeTrack(\.offsetY) {
                                    SpringKeyframe(-20, duration: 0)
                                    LinearKeyframe(0, duration: 0.5)
                                }
                                KeyframeTrack(\.opacity) {
                                    LinearKeyframe(0, duration: 0)
                                    LinearKeyframe(1, duration: 0.5)
                                }
                            }
                        .padding()
                        Rectangle().fill(.black)
                            .frame(width: 200, height: 200)
                        Group {
                            LazyVStack {
                                Text("カメレオンを背景の上で動かしてみてください")
                                    .font(.title)
                                //                        .keyframeAnimator(
                                //                            initialValue: DiscriptionAnimation(), trigger: trigger) {content, value in
                                //                                content
                                //                                    .opacity(value.opacity)
                                //                                    .offset(y: value.offsetY)
                                //                            } keyframes: { _ in
                                //                                KeyframeTrack(\.offsetY) {
                                //                                    LinearKeyframe(1.0, duration: 4)
                                //                                    LinearKeyframe(0.7, duration: 1)
                                //                                }
                                //                                KeyframeTrack(\.opacity) {
                                //                                    LinearKeyframe(0, duration: 2)
                                //                                    LinearKeyframe(1, duration: 1)
                                //                                }
                                //                            }
                                Rectangle()
                                    .frame(width: 200, height: 200)
                                    .onAppear() {
                                        trigger3 = true
                                    }
                                Text(state == .even ? "背景色に合わせて、カメレオンが体の色を変更させます。" : "背景色を検知して、カメレオンが目立つ色に変化します。")
                            }
                        }
                        .padding()
                        .keyframeAnimator(
                            initialValue: DescriptionAnimation(), trigger: trigger3) {content, value in
                                content
                                    .opacity(value.opacity)
                                    .offset(y: value.offsetY)
                            } keyframes: { _ in
                                KeyframeTrack(\.offsetY) {
                                    SpringKeyframe(-20, duration: 0)
                                    LinearKeyframe(0, duration: 0.5)
                                }
                                KeyframeTrack(\.opacity) {
                                    LinearKeyframe(0, duration: 0)
                                    LinearKeyframe(1, duration: 0.5)
                                }
                            }
                    }
                    .padding()
                    Rectangle().fill(.black)
                        .frame(width: 200, height: 200)
                    Group {
                        LazyVStack {
                            
                            Text("Thank you!")
                                .font(.title)
                            Rectangle()
                                .frame(width: 200, height: 50)
                                .onAppear() {
                                    trigger4 = true
                                }
                            Text("下のボタンを押して終了してください。")
                            Button(action:  {
                                nowPhase = .beforeTap
                            }, label: {
                              Text("終了する")
                                    .shadow(color: .white, radius: 2, x: 0, y: 5)
                            })
                            .padding()
                        }
                    }
                    .keyframeAnimator(
                        initialValue: DescriptionAnimation(), trigger: trigger4) {content, value in
                            content
                                .opacity(value.opacity)
                                .offset(y: value.offsetY)
                        } keyframes: { _ in
                            KeyframeTrack(\.offsetY) {
                                SpringKeyframe(-20, duration: 0)
                                LinearKeyframe(0, duration: 0.5)
                            }
                            KeyframeTrack(\.opacity) {
                                LinearKeyframe(0, duration: 0)
                                LinearKeyframe(1, duration: 0.5)
                            }
                        }
                    .padding()
                    Rectangle()
                        .fill(.black)
                        .frame(width: 300, height: 300)
                }
                .fontWeight(.thin)
                .foregroundStyle(.white)
                .onAppear() {
                    trigger.toggle()
                }
            }
            .background(.black)
        
    }
}

#Preview {
    
}
