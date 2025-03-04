//
//  CheckoutHelper.swift
//  Demoshop
//
//  Created by Marko Benačić on 27.02.2025..
//

import Foundation
import CorvusWalletSDK
import UIKit

class CheckoutHelper {
    static func createCheckout(with installmentType: InstallmentType, cart: Cart) -> Checkout {
        var installmentMap: InstallmentMap?
        var installments: InstallmentsParams?

        switch installmentType {
        case .noInstallments:
            installments = InstallmentsHelper.mockNoInstallments()
        case .fixedInstallments:
            installments = InstallmentsHelper.mockFixedInstallments()
        case .installments:
            installments = InstallmentsHelper.mockInstallments()
        case .dynamicInstallments:
            installments = InstallmentsHelper.mockDynamicInstallments()
        case .installmentMap:
            installmentMap = nil // mockinstallmentmap
        }

        let discount = cart.getTotalDiscount() ?? 0

        let cardHolder = mockCardholder()
        let cartArray = cartItemArray(from: cart)

        let che

//        let checkout = Checkout(
//            storeId: storeId,
//            orderNumber: orderNumber,
//            language: .en,
//            cart: cartArray,
//            currency: Currency(.eur),
//            amount: cart.getTotalPrice(),
//            requireComplete: requireComplete,
//            bestBefore: bestBefore,
//            discountAmount: cart.getTotalDiscount() ?? 0,
//            cardHolder: cardHolder,
//            installments: installments,
//            installmentsMap: installmentMap,
//            isSdk: true,
//            version: "1.4"
//        )
        return checkout
    }

    //        let signature = createDemoSignature(for: checkout)
}

// MARK: Mock data
extension CheckoutHelper {
    // Test (Corvus Shop)
    static let secretKey = "mYRLilVm8mEXdLzFMreZaGO6Y"
    static let storeId = 14423

    static let orderNumber = ""

    // TRUE if transaction is preauthorization, FALSE otherwise
    static let requireComplete = false

    static var bestBefore: Int64 {
        // Checkout duration (maximum 900 seconds)
        let checkoutDurationSeconds = 600
        let date = Calendar.current.date(byAdding: .second, value: checkoutDurationSeconds, to: Date())
        return Int64(date?.timeIntervalSince1970 ?? 0)
    }

    static func mockCardholder() -> Cardholder {
        var cardHolder = Cardholder()
        cardHolder.firstName = "Ivan"
        cardHolder.lastName = "Horvat"
        cardHolder.address = "Primorska ulica 10"
        cardHolder.city = "Zagreb"
        cardHolder.zip = "10000"
        cardHolder.country = "Croatia"
        cardHolder.countryCode = "1"
        cardHolder.email = "ivan@gmail.com"
        cardHolder.phone = "0991234567"

        return cardHolder
    }

    static func cartItemArray(from cart: Cart) -> [CorvusWalletSDK.CartItem] {
        cart.getItems().map { cartItem in
            return CorvusWalletSDK.CartItem(name: cartItem.product.name, quantity: cartItem.quantity, image: UIImage(named: cartItem.product.image!)!)
        }
    }
}

