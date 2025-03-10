//
//  DemoshopApp.swift
//  Demoshop
//
//  Created by Marko Benačić on 27.07.2023..
//

import SwiftUI
import CorvusWalletSDK

@main
struct DemoshopApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    CorvusWallet.logLevel = .debug
                    CorvusWallet.environment = .test
                }
                .onOpenURL { url in
                    _ = CorvusWallet.handleWalletAppCallback(url: url)
                }
        }
    }
}
