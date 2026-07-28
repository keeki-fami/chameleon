//
//  scroll.swift
//  chameleon
//
//  Created by 櫻田聖和 on 2026/07/26.
//

import SwiftUI

struct lastView: View {
    @State var data: [Bool] = Array(repeating: false, count: 20)
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(data.indices, id: \.self) {i in
                    Rectangle()
                        .frame(width: 300, height: 300)
                        .opacity(data[i] ? 1 : 0)
                        .onAppear {
                            print("\(i)")
                            withAnimation {
                                data[i] = true
                            }
                        }
                }
            }
        }
    }
}

