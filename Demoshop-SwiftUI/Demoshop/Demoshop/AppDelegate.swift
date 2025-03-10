//
//  AppDelegate.swift
//  Demoshop
//
//  Created by Marko Benačić on 10.03.2025..
//

import CorvusWalletSDK
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return CorvusWallet.handleWalletAppCallback(url: url)
    }
}
