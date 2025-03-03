//
//  InstallmentsHelper.swift
//  Demoshop
//
//  Created by Marko Benačić on 07.08.2023..
//

import Foundation
import CorvusWalletSDK

enum InstallmentType: CaseIterable {
    case noInstallments
    case fixedInstallments
    case installments
    case dynamicInstallments
    case installmentMap

    var title: String {
        switch self {
        case .noInstallments:
            return "NO INSTALLMENTS"
        case .fixedInstallments:
            return "FIXED INSTALLMENTS"
        case .installments:
            return "INSTALLMENTS"
        case .dynamicInstallments:
            return "DYNAMIC INSTALLMENTS"
        case .installmentMap:
            return "INSTALLMENT MAP"
        }
    }
}

class InstallmentsHelper {

    // Used when single payment only should be available
    static func mockNoInstallments() -> InstallmentsParams {
        // 0 or 1
        InstallmentsParams.createWithFixedNumberOfInstallments(0)
    }

    // available installments: 0 - 99
    static func mockFixedInstallments() -> InstallmentsParams {
        let fixedNumberOfInstallments = 5
        return InstallmentsParams.createWithFixedNumberOfInstallments(fixedNumberOfInstallments)
    }

    // oneTimePayment - boolean value representing is single installment payment available
    // lowerBound - minimum number of installments to be shown to payer (0-99 installments)
    // upperBound - maximum number of installments to be shown to payer (0-99 installemnts)
    static func mockInstallments() -> InstallmentsParams{
        let oneTimePayment = true
        let lowerBound = 2
        let upperBound = 12
        return InstallmentsParams.createWithPaymentAll(oneTimePayment: oneTimePayment, lowerBound: lowerBound, upperBound: upperBound)
    }

    // Use when you need to setup custom number of installments for each supported card
    static func mockDynamicInstallments() -> InstallmentsParams {
        var dynamicInstallmentsBuilder = DynamicInstallmentsBuilder()

        dynamicInstallmentsBuilder = dynamicInstallmentsBuilder.setupAmexDynamic(oneTime: true, lowerBound: 1, upperBound: 20)
        dynamicInstallmentsBuilder = dynamicInstallmentsBuilder.setupDinersDynamic(oneTime: true, lowerBound: 4, upperBound: 13)
        dynamicInstallmentsBuilder = dynamicInstallmentsBuilder.setupDinaDynamic(oneTime: true, lowerBound: 0, upperBound: 12)
        dynamicInstallmentsBuilder = dynamicInstallmentsBuilder.setupVisaDynamic(oneTime: true, lowerBound: 5, upperBound: 12)
        dynamicInstallmentsBuilder = dynamicInstallmentsBuilder.setupMasterDynamic(oneTime: true, lowerBound: 6, upperBound: 8)
        dynamicInstallmentsBuilder = dynamicInstallmentsBuilder.setupMaestroDynamic(oneTime: true, lowerBound: 9, upperBound: 10)
        dynamicInstallmentsBuilder = dynamicInstallmentsBuilder.setupDiscoverDynamic(oneTime: false, lowerBound: 2, upperBound: 12)
        dynamicInstallmentsBuilder = dynamicInstallmentsBuilder.setupJcbDynamic(oneTime: false, lowerBound: 3, upperBound: 12)

        return InstallmentsParams.createWithDynamicPayment(dynamicInstallmentsBuilder.build())
    }

//    func mockInstallmentMap() -> InstallmentMap {
//        var installmentMap = CorvusWalletSDK.InstallmentMap()
//
//        let discountOne = Discount(numberOfInstallments: 1, amount: 600, discountedAmount: 600)
//        let discountTwo = Discount(numberOfInstallments: 2, amount: 610, discountedAmount: 610)
//        let discountThreee = Discount(numberOfInstallments: 3, amount: 610, discountedAmount: 610)
//        let discountThreeee = Discount(numberOfInstallments: 4, amount: 620, discountedAmount: 610)
//        let installmentMockDiners = CardConfiguration()
//        installmentMockDiners.cardName = "diners"
//        installmentMockDiners.discounts = [discountOne, discountTwo, discountThreee, discountThreeee]
//
//        let discountVisaOne = Discount(numberOfInstallments: 1, amount: 1101, discountedAmount: 1001)
//        let discountVisaTwo = Discount(numberOfInstallments: 2, amount: 1102, discountedAmount: 1002)
////        let discountFour = Discount(numberOfInstallments: 3, amount: 1000, discountedAmount: 950)
//
//        let installmentMockVisa = CardConfiguration()
//        installmentMockVisa.cardName = "visa"
//        installmentMockVisa.discounts = [discountVisaOne, discountVisaTwo, discountThreee, discountThreeee]
//
//        let installmentMockMaestro = CardConfiguration()
//        installmentMockMaestro.cardName = "maestro"
//        installmentMockMaestro.discounts = [discountVisaOne, discountVisaTwo, discountThreee, discountThreeee]
//
//        let installmentMockMaster = CardConfiguration()
//        installmentMockMaster.cardName = "master"
//        installmentMockMaster.discounts = [discountVisaOne, discountVisaTwo, discountThreee, discountThreeee]
//
//
//        let installmentMockJcb = CardConfiguration()
//        installmentMockJcb.cardName = "jcb"
//        installmentMockJcb.discounts = [discountVisaOne, discountVisaTwo, discountThreee, discountThreeee]
//
//        let installmentMockAmex = CardConfiguration()
//        installmentMockAmex.cardName = "amex"
//        installmentMockAmex.discounts = [discountVisaOne, discountVisaTwo, discountThreee, discountThreeee]
//
//        installmentMap.setInstallments(installments: [installmentMockDiners, installmentMockVisa, installmentMockMaestro, installmentMockMaster, installmentMockAmex, installmentMockJcb])
//
//        return installmentMap
//    }
}
