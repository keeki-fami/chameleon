//
//  bluetooth.swift
//  chameleon
//
//  Created by 櫻田聖和 on 2026/07/21.
//

import CoreBluetooth

enum ChameleonState {
    case even
    case odd
    case normal
}

@Observable
class BluetoothManager: NSObject {
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    private var characteristic: CBCharacteristic?
    var onDeviceDiscovered: ((CBPeripheral) -> Void)?
    var isLoading: Bool = false
    var nowState: ChameleonState = .normal
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func scanForDevices() {
        isLoading = true
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func disconnect() {
        guard let peripheral = peripheral else {
            print("接続中のPeripheralがありません")
            return
        }
        print("Peripheralとの接続を解除します")
        centralManager?.cancelPeripheralConnection(peripheral)
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // TODO: scanForDevices()
            // ここで特定のサービスUUIDを持つperipheralを指定する。
            let chameleonCbuuid = [CBUUID(string: "7df18283-68cd-4025-9979-719e899d3072")]
            central.scanForPeripherals(withServices: chameleonCbuuid, options: nil)
        } else {
            print("Bluetooth is not available")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name ?? "Unknown")")
//        onDeviceDiscovered?(peripheral)
        if peripheral.name == "ESP32_chameleon" {
            print("接続します")
            self.peripheral = peripheral
            centralManager?.connect(peripheral, options: nil)
            isLoading = false
        }
    }
    
    // 接続時にはこれが呼び出される。
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // こうすることで、CBPeripheralDelegateのメソッドを通して、Peripheralからのイベントを受け取れる様になる。
        peripheral.delegate = self
        // peripheral.discoverServices([CBUUID(string: "サービスUUIDを定義")])
        // こうすることで、任意のサービスを探索することができる。
        peripheral.discoverServices(nil)
        
        central.stopScan()
        
    }
    
    // 失敗した時に呼ばれる。
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        print("peripheralデバイスへの接続に失敗しました。: \(error?.localizedDescription ?? "不明")")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("接続解除中にエラーが発生しました。: \(error.localizedDescription)")
        } else {
            print("peripheralとの接続が正常に解除されました。")
        }
        self.peripheral = nil
    }
    
}

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        
        if let error = error {
            print("サービスの探索中にエラーが発生しました：\(error)")
            return
        }
        
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            print("サービスが見つかりました：\(service.uuid)")
            if service.uuid == CBUUID(string: "7DF18283-68CD-4025-9979-719E899D3072") {
                print("サービスが見つかりました。Characteristicを探索します。")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        if let error = error {
            print("Characteristicの探索中にエラーが発生しました：\(error.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        for characteristic in characteristics {
            print("characteristicが見つかりました。\(characteristic.uuid)")
            if characteristic.uuid == CBUUID(string: "DF81DB95-42D3-4BF2-B536-0310D8AC4FA2") || characteristic.uuid == CBUUID(string: "1205F4D5-CF70-470E-9C3F-7BEF7FAEDC5D")  {
                print("characteristicが見つかりました： \(characteristic.uuid)")
                print("\(characteristic.properties)")
                if characteristic.properties.contains(.read) {
                    self.peripheral = peripheral
                    self.characteristic = characteristic
                    print("peripheal: \(peripheral.name ?? "unknown"), characteristic: \(String(describing: characteristic.value))")
                } else {
                    print("writeは含まれていません。")
                }
                
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Characteristicの値の読み書き中にエラーが発生しました。：\(error.localizedDescription)")
            return
        }
        
        guard let data = characteristic.value else {
            print("characteristicの値が存在しません。")
            return
        }
        
        print("data: \(data)")
        print("data: \(String(describing: data))")
        if let stringValue = String(data: data, encoding: .utf8) {
            print("読み取った値：\(stringValue)")
            if let value = characteristic.value {
                if let stringValue = String(data: value, encoding: .utf8) {
                    print("getvalue: \(stringValue)")
                    if stringValue == "0" {
                        nowState = .even
                    } else {
                        nowState = .odd
                    }
                }
            }
        } else {
            print("データをUTF-8文字列に変換できません。")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("データ書き込み中にエラーが発生しました。: \(error.localizedDescription)")
        } else {
            print("データが正常に書き込まれました。")
        }
    }
    
    func readValue() {
        guard let peripheral = peripheral, let characteristic = characteristic else {
            print("peripheralやキャラクタリスティックが取得されていません。")
            return
        }
        
        peripheral.readValue(for: characteristic)
        if let value = characteristic.value {
            if let stringValue = String(data: value, encoding: .utf8) {
                print("getvalue: \(stringValue)")
                if stringValue == "0" {
                    nowState = .even
                } else {
                    nowState = .odd
                }
            }
        }
    }
}
