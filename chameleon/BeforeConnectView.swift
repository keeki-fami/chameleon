//
//  BeforeConnectView.swift
//  chameleon
//
//  Created by 櫻田聖和 on 2026/07/29.
//

import SwiftUI

struct BeforeConnectView: View {
    @Bindable var bluetoothManager: BluetoothManager
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
            VStack {
                Spacer()
                Image("icon")
                    .clipShape(
                        RoundedRectangle(cornerRadius: 30)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.gray, lineWidth: 1)
                    }
                    .shadow(color: .white.opacity(0.5), radius: 10)
                    .padding()
                Text("Chameleon")
                    .foregroundStyle(.white)
                    .font(.title)
                    .fontWeight(.thin)
                Spacer()
                Rectangle()
                    .frame(width: 400, height: 100)
                    .overlay() {
                        
                            VStack {
                                Group {
                                    ProgressView()
                                        .scaleEffect(2)
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                    Text("通信中...")
                                        .foregroundStyle(.white)
                                        .fontWeight(.thin)
                                        .padding()
                                }
                                .opacity(bluetoothManager.isLoading ? 1 : 0)
                                Button("接続する") {
                                    bluetoothManager.scanForDevices()
                                }
                                .foregroundStyle(.white)
                                .fontWeight(.thin)
                                .padding()
                            }
                        
                    }
                Spacer()
            }
        }
    }
}
#Preview {
    @Previewable @State var bluetoothManager = BluetoothManager()
    BeforeConnectView(bluetoothManager: bluetoothManager)
}
