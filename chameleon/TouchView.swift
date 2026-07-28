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
