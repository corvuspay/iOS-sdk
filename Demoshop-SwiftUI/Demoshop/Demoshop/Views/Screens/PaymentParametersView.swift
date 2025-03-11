//
//  PaymentParametersView.swift
//  Demoshop
//
//  Created by Marko Benačić on 08.08.2023..
//

import SwiftUI
import CorvusWalletSDK

struct PaymentParametersView: View {
    private let pickedInstallments: InstallmentType
    private let cart: Cart
    @StateObject private var viewModel: PaymentViewModel

    @SwiftUICore.Environment(\.dismiss) private var dismiss

    init(
        pickedInstallments: InstallmentType,
        cart: Cart
    ) {
        self.pickedInstallments = pickedInstallments
        self.cart = cart
        _viewModel = StateObject(wrappedValue: PaymentViewModel(pickedInstallments: pickedInstallments, cart: cart))
    }

    var body: some View {
        ScrollView {
            VStack {
                CheckoutParametersListView(viewModel: viewModel)

                Button("Continue with payment") {
                    viewModel.proceedToPayment()
                }
                .fontWeight(.bold)
                .buttonStyle(DemoShopButtonStyle())
                .padding(.top, 24)
            }
            .padding()
        }
        .navigationTitle(pickedInstallments.title)
        .alert("", isPresented: .constant(viewModel.alert != nil)) {
            Button("OK") {
                viewModel.dismissAlert()
                dismiss()
            }
        } message: {
            Text(viewModel.alert?.text ?? "")
        }
    }

    struct CheckoutParametersListView: View {
        let viewModel: PaymentViewModel
        private var checkoutParameters: [(String, String)] {
            CheckoutHelper.checkoutParametersList(from: viewModel.checkout, signature: viewModel.signature)
        }

        var body: some View {
            VStack {
                ForEach(Array(checkoutParameters.enumerated()), id: \.0) { (index, parameterTouple) in
                    HStack(alignment: .top, spacing: 16) {
                        Text(parameterTouple.0)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text(parameterTouple.1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if index != checkoutParameters.count - 1 {
                        Divider()
                    }
                }
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray, lineWidth: 2)
            }
        }
    }
}
