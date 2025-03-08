//
//  PaymentViewModel.swift
//  Demoshop
//
//  Created by Marko Benačić on 08.03.2025..
//

import Foundation
import CorvusWalletSDK

class PaymentViewModel {
    public let checkout: Checkout
    public let signature: String

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

            print("CALLBACK")

            if let responseData {
                print("response data: \n" + responseData)
            }

            switch result {
            case .success:
                print("success")
//                self?.showAlert(message: "Order " + orderNumber + " placed successfully!")
            case .checkoutError:
                print("success")
//                self?.showErrorAlert(message: "Order " + orderNumber + " not processed.")
            case .networkError:
                print("success")
//                self?.showErrorAlert(message: "Network connection error.")
            case .canceled:
                print("success")
//                self?.showErrorAlert(message: "Order cancelled")
            case .validationFailed:
                print("success")
//                self?.showErrorAlert(message: "Please double check checkout parameters")
            default:
                break
            }
        }
    }
}
