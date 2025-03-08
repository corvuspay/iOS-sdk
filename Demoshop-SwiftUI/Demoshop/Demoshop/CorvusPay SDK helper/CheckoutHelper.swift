//
//  CheckoutHelper.swift
//  Demoshop
//
//  Created by Marko Benačić on 27.02.2025..
//

import Foundation
import CorvusWalletSDK
import UIKit
import CommonCrypto

extension String {
    static let hexFormat = "%02hhx"

    var urlQueryEscaped: String {
        return (self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
}

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

        let cardHolder = mockCardholder()
        let cartArray = cartItemArray(from: cart)

        let checkout = Checkout(
            storeId: storeId,
            orderNumber: String(orderNumber),
            language: .en,
            cart: cartArray,
            currency: Currency(.eur),
            amount: cart.getTotalPrice(),
            requireComplete: requireComplete,
            bestBefore: bestBefore,
            discountAmount: cart.getTotalDiscount() ?? 0,
            cardHolder: cardHolder,
            installments: installments,
            installmentsMap: installmentMap,
            isSdk: true,
            version: version
        )
        return checkout
    }

    static func createDemoSignature(from checkout: Checkout) -> String {
        let signatureString = CorvusWallet.createSignatureString(for: checkout)
        return CheckoutHelper.encryptedSignature(signatureParams: signatureString, secretKey: secretKey) ?? "invalid signature"
    }

    static func encryptedSignature(signatureParams: String, secretKey: String) -> String? {
        guard let paramsData = signatureParams.data(using: .utf8),
              let secretKeyData = secretKey.data(using: .utf8) else {
            return nil
        }

        let algLen = Int(CC_SHA256_DIGEST_LENGTH)
        let bytes = UnsafeMutablePointer<UInt8>.allocate(capacity: algLen)

        defer {
            bytes.deallocate()
        }

        paramsData.withUnsafeBytes { (paramsDataPtr) in
            secretKeyData.withUnsafeBytes { (secretKeyDataPtr) in
                CCHmac(
                    CCHmacAlgorithm(kCCHmacAlgSHA256),
                    secretKeyDataPtr.baseAddress,
                    secretKeyData.count,
                    paramsDataPtr.baseAddress,
                    paramsData.count,
                    bytes
                )
            }
        }

        return Data(bytes: bytes, count: algLen).map { (byte) in
            String(format: .hexFormat, byte)
        }
        .joined()
        .urlQueryEscaped
    }

    // For UI purposes
    static func checkoutParametersList(from checkout: Checkout, signature: String) -> [(String, String)] {
        var parameters: [(String, String)] = []

        parameters.append(("storeId", String(checkout.storeId)))
        parameters.append(("orderId", checkout.orderNumber))
        parameters.append(("language", checkout.language.description))
        parameters.append(("currency", checkout.currency.code))
        parameters.append(("amount", String(format: "%.2f", checkout.amount)))
        parameters.append(("discount_amount", String(checkout.discountAmount)))

        parameters.append(("requireComplete", String(checkout.requireComplete)))

        if let cardholder = checkout.cardHolder {
            parameters.append(("cardholder", (cardholder.firstName ?? "") + " " + (cardholder.lastName ?? "")))
        }

        parameters.append(("bestBefore", String(checkout.bestBefore)))

        if let installmentsParams = checkout.installments {
            parameters.append(("installmentsParams", installmentsParams.toString))
        }
        
        // if let installmentsMap
        parameters.append(("installmentsMap", "todo"))

        if let useCardProfiles = checkout.useCardProfiles as? Bool {
            parameters.append(("use_card_profiles", String(useCardProfiles)))
        }

        if let userCardProfilesId = checkout.userCardProfilesId {
            parameters.append(("userCardProfilesId", userCardProfilesId))
        }

        parameters.append(("isSDK", String(checkout.isSdk)))
        parameters.append(("version", checkout.version))
        parameters.append(("signature", signature))

        return parameters
    }

}

// MARK: Mock data
extension CheckoutHelper {
    // Test (Corvus Shop)
    static let secretKey = "mYRLilVm8mEXdLzFMreZaGO6Y"
    static let storeId = 14423
    static let version = "1.4"

    static let orderNumber = Int.random(in: 1...Int.max)

    // TRUE if transaction is preauthorization, FALSE otherwise
    static let requireComplete = false

    static var bestBefore: Int64 {
        // Checkout duration (maximum 900 seconds)
        let checkoutDurationSeconds = 600
        let date = Calendar.current.date(byAdding: .second, value: checkoutDurationSeconds, to: Date())
        return Int64(date?.timeIntervalSince1970 ?? 0)
    }

    static func mockCardholder() -> Cardholder {
        return Cardholder(
            firstName: "Hrvoje",
            lastName: "Horvat",
            address: "Primorska ulica 10",
            city: "Zagreb",
            zip: "10000",
            country: "Croatia",
            countryCode: "1",
            email: "ivan@gmail.com",
            phone: "0991234567"
        )
    }

    static func cartItemArray(from cart: Cart) -> [CorvusWalletSDK.CartItem] {
        cart.getItems().map { cartItem in
            return CorvusWalletSDK.CartItem(
                name: cartItem.product.name,
                quantity: cartItem.quantity,
                image: UIImage(named: cartItem.product.image!)!
            )
        }
    }
}
