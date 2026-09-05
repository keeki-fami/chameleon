//
//  TouchView.swift
//  chameleon
//
//  Created by 櫻田聖和 on 2026/07/21.
//

import SwiftUI

struct TouchView: View {
    @Binding var tap: CGPoint
    var body: some View {
        Circle()
            .fill(.white)
            .frame(width: 30, height: 30)
            .position(x: tap.x, y: tap.y)
            .keyframeAnimator(
                initialValue: 0.0, trigger: tap) {content, value in
                    content
                        .opacity(value)
                } keyframes: { _ in
                    MoveKeyframe(1.0)
                    LinearKeyframe(0.0, duration: 2.0)
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
    @Binding var tap: CGPoint
    @Binding var trigger: Bool
    var xval: CGFloat {
        tap.x
    }
    var yval: CGFloat {
        tap.y
    }
    var body: some View {
        ZStack {
            ForEach(delay, id: \.self) { i in
                Circle()
                    .strokeBorder(.white, lineWidth: 1)
                    .frame(width: 100, height: 100)
                    .position(x: tap.x, y: tap.y)
                    .keyframeAnimator(initialValue: Value(), trigger: trigger) { content, value in
                        content
                            .opacity(value.opacity)
                            .scaleEffect(value.scale, anchor: UnitPoint(x: xval/400, y: yval/777))
                        
                    } keyframes: { _ in
                        KeyframeTrack(\.opacity) {
                            LinearKeyframe(0, duration: 0 + i)
                            MoveKeyframe(1)
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

    }
}
