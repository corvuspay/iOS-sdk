//
//  CheckoutHelper.swift
//  Demoshop
//
//  Created by Marko Benačić on 27.02.2025..
//

import Foundation
import CorvusWalletSDK

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

        // Checkout duration (maximum 900 seconds)
        let checkoutDurationSeconds = 600
        let date = Calendar.current.date(byAdding: .second, value: checkoutDurationSeconds, to: Date())
        let bestBefore = Int64(date?.timeIntervalSince1970 ?? 0)

//        let cardHolderMock = Cardholder(firstName: "Marko", lastName: "Benacic", address: "Promorska 5", city: "Zagreb", zip: "10000", country: "Croatia", countryCode: "1", email: "marko@gmail.com", phone: "099999999999")
//
//        let adawiojwa = Cardholder()
//
//        let checkout = Checkout(storeId: Config.storeId,
//                                orderNumber: orderNumber,
//                                language: .en,
//                                cart: Array(cart[..<numberOfItems]),
//                                //                                cartS: cartS,
//                                currency: currency,
//                                amount: amount,
//                                requireComplete: requireCompleteSwitch.isOn,
//                                bestBefore: bestBefore,
//                                discountAmount: (discount > 0 ? discount : CorvusWallet.noValueDouble),
//                                cardHolder: cardHolderMock,
//                                installments: installments,
//                                installmentsMap: installmentsMap,
//                                //                                useCardProfiles: useCardProfiles,
//                                //                                userCardProfilesId: userCardProfilesId,
//                                isSdk: true,
//                                version: "1.4"
//                                //                                creditorReference: "HR00841700-933108-611748",
//                                //                                debtorIban: "HR5023400093000000003"
//                                //                                voucherAmount: 15
//                                //                                hideTab: "wallet"
//                                //                                hideTabs: "wallet"
//                                //                                shopAccountId: "sdfemr4lgfwrg"
//        )
//        return checkout
    }

    //        let signature = createDemoSignature(for: checkout)
}
extension CheckoutHelper {
    // Mocks
}

