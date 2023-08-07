//
//  PaymentView.swift
//  Demoshop
//
//  Created by Marko Benačić on 07.08.2023..
//

import SwiftUI

struct PaymentView: View {
    @EnvironmentObject var cart: Cart

    @State var pickedInstallments: InstallmentType = .noInstallments

    var body: some View {
        VStack {
            Text("Payment parameters")
                .font(.title)
            Spacer()

            // mislim da je ipak bolje s butonima
            Group {
                NavigationLink {
                    Text("no instalments")
                } label: {
                    Text("NO INSTALLMENTS")
                        .frame(maxWidth: .infinity)
                }
                NavigationLink {
                    Text("fixed")
                } label: {
                    Text("FIXED INSTALLMENTS")
                        .frame(maxWidth: .infinity)
                }
                NavigationLink {
                    Text("installments")
                } label: {
                    Text("INSTALLMENTS")
                        .frame(maxWidth: .infinity)
                }
                NavigationLink {
                    Text("dynamic instalments")
                } label: {
                    Text("DYNAMIC INSTALLMENTS")
                        .frame(maxWidth: .infinity)
                }
                NavigationLink {
                    Text("instalment map")
                } label: {
                    Text("INSTALLMENT MAP")
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)

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
