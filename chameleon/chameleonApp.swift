//
//  chameleonApp.swift
//  chameleon
//
//  Created by 櫻田聖和 on 2026/07/17.
//

import SwiftUI

@main
struct chameleonApp: App {
    @State var bluetoothManager: BluetoothManager = BluetoothManager()
    var body: some Scene {
        WindowGroup {
            if !bluetoothManager.beforeConnectPeripheral {
                BeforeConnectView(bluetoothManager: bluetoothManager)
            } else {
                ContentView(bluetoothManager: bluetoothManager)
            }

//            BluetoothView()
//            lastView()
        }
    }
}
