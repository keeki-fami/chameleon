//
//  BluetoothView.swift
//  chameleon
//
//  Created by 櫻田聖和 on 2026/07/22.
//

import SwiftUI

struct BluetoothView: View {
    @State var bluetoothManager: BluetoothManager = BluetoothManager()
    var body: some View {
        
        if bluetoothManager.isLoading {
            ProgressView()
        }
        Button("bluetooth_start") {
            bluetoothManager.scanForDevices()
        }
        Button("送信") {
            bluetoothManager.readValue()
        }
        
    }
}

