//
//  PaymentViewModel.swift
//  Demoshop
//
//  Created by Marko Benačić on 08.03.2025..
//

import Foundation
import CorvusWalletSDK

struct PaymentAlertItem {
    let text: String
    let isError: Bool
}

class PaymentViewModel: ObservableObject {
    public let checkout: Checkout
    public let signature: String

    @Published var alert: PaymentAlertItem?

    init(
        pickedInstallments: InstallmentType,
        cart: Cart
    ) {
        checkout = CheckoutHelper.createCheckout(
            with: pickedInstallments,
            cart: cart
        )
        signature = CheckoutHelper.createDemoSignature(from: checkout)
    }

    func proceedToPayment() {
        CorvusWallet.shopURL = "demoShop"

        CorvusWallet.checkout(with: checkout, signature: signature) { [weak self] responseData, result in

            if let responseData {
                print("response data: \n" + responseData)
            }

            switch result {
            case .success:
                self?.alert = PaymentAlertItem(text: "Order placed successfully", isError: false)
            case .checkoutError:
                self?.alert = PaymentAlertItem(text: "Order not processed", isError: true)
            case .networkError:
                self?.alert = PaymentAlertItem(text: "Network connection error", isError: true)
            case .canceled:
                self?.alert = PaymentAlertItem(text: "Order cancelled", isError: true)
            case .validationFailed:
                self?.alert = PaymentAlertItem(text: "Please double check checkout parameters", isError: true)
            default:
                break
            }
        }
    }

    func dismissAlert() {
        alert = nil
    }
}
