//
//  DemoShopButtonStyle.swift
//  Demoshop
//
//  Created by Marko Benačić on 07.08.2023..
//

import SwiftUI

struct DemoShopButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

