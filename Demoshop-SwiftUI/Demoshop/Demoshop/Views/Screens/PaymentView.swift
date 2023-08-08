//
//  PaymentView.swift
//  Demoshop
//
//  Created by Marko Benačić on 07.08.2023..
//

import SwiftUI

struct PaymentView: View {
    @EnvironmentObject var cart: Cart

    var body: some View {
        VStack {
            Text("Payment parameters")
                .font(.title)

            Spacer()

            ForEach(InstallmentType.allCases, id: \.self) { installmentType in
                NavigationLink {
                    PaymentParametersView(pickedInstallments: installmentType)
                } label: {
                    Text(installmentType.title)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }

        .fontWeight(.bold)
        .buttonStyle(DemoShopButtonStyle())
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView()
    }
}
