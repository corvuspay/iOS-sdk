//
//  PaymentParametersView.swift
//  Demoshop
//
//  Created by Marko Benačić on 08.08.2023..
//

import SwiftUI

struct PaymentParametersView: View {
    private let pickedInstallments: InstallmentType
    
    init(pickedInstallments: InstallmentType) {
        self.pickedInstallments = pickedInstallments
    }

    var body: some View {
        Text(pickedInstallments.title)
    }
}

struct PaymentParametersView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentParametersView(pickedInstallments: .dynamicInstallments)
    }
}
