//
//  InstallmentsHelper.swift
//  Demoshop
//
//  Created by Marko Benačić on 07.08.2023..
//

import Foundation
import CorvusWalletSDK

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

    // Most versatile form of installments setup
    static func mockInstallmentMap() -> InstallmentMap? {
        // diners
        let dinersDiscounts = DiscountsBuilder()
            .add(numberOfInstallments: 1, amount: 600, discountedAmount: 600)
            .add(numberOfInstallments: 2, amount: 610, discountedAmount: 610)
            .add(numberOfInstallments: 3, amount: 610, discountedAmount: 610)
            .add(numberOfInstallments: 4, amount: 620, discountedAmount: 610)
            .add(numberOfInstallments: 5, amount: 630, discountedAmount: 620)
            .build()

        // visa
        let visaDiscounts = DiscountsBuilder()
            .add(numberOfInstallments: 1, amount: 1101, discountedAmount: 1001)
            .add(numberOfInstallments: 2, amount: 1102, discountedAmount: 1002)
            .add(numberOfInstallments: 3, amount: 1103, discountedAmount: 1002)
            .add(numberOfInstallments: 4, amount: 1200, discountedAmount: 1050)
            .build()

        // maestro
        let maestroDiscounts = DiscountsBuilder()
            .add(numberOfInstallments: 1, amount: 500, discountedAmount: 490)
            .add(numberOfInstallments: 2, amount: 510, discountedAmount: 500)
            .add(numberOfInstallments: 3, amount: 515, discountedAmount: 505)
            .add(numberOfInstallments: 4, amount: 520, discountedAmount: 510)
            .build()

        // master
        let masterDiscounts = DiscountsBuilder()
            .add(numberOfInstallments: 1, amount: 1000, discountedAmount: 980)
            .add(numberOfInstallments: 2, amount: 1020, discountedAmount: 990)
            .add(numberOfInstallments: 3, amount: 1030, discountedAmount: 1000)
            .add(numberOfInstallments: 4, amount: 1050, discountedAmount: 1020)
            .build()

        // jcb
        let jcbDiscounts = DiscountsBuilder()
            .add(numberOfInstallments: 1, amount: 700, discountedAmount: 680)
            .add(numberOfInstallments: 2, amount: 710, discountedAmount: 690)
            .add(numberOfInstallments: 3, amount: 720, discountedAmount: 700)
            .add(numberOfInstallments: 4, amount: 730, discountedAmount: 710)
            .build()

        // amex
        let amexDiscounts = DiscountsBuilder()
            .add(numberOfInstallments: 1, amount: 900, discountedAmount: 880)
            .add(numberOfInstallments: 2, amount: 910, discountedAmount: 890)
            .add(numberOfInstallments: 3, amount: 920, discountedAmount: 900)
            .add(numberOfInstallments: 4, amount: 930, discountedAmount: 910)
            .build()

        // build
        let customInstallmentsMap = InstallmentsMapBuilder()
            .create(withCard: .diners, withDiscounts: dinersDiscounts)
            .create(withCard: .visa, withDiscounts: visaDiscounts)
            .create(withCard: .maestro, withDiscounts: maestroDiscounts)
            .create(withCard: .master, withDiscounts: masterDiscounts)
            .create(withCard: .jcb, withDiscounts: jcbDiscounts)
            .create(withCard: .amex, withDiscounts: amexDiscounts)
            .build()

        return customInstallmentsMap
    }

    // Another possible implementation
//    static func mockInstallmentMap2() -> InstallmentMap {
//        var installmentMap = InstallmentMap()
//
//        // diners
//        let discountOneDiners = Discount(numberOfInstallments: 1, amount: 600, discountedAmount: 600)
//        let discountTwoDiners = Discount(numberOfInstallments: 2, amount: 610, discountedAmount: 610)
//        let discountThreeDiners = Discount(numberOfInstallments: 3, amount: 610, discountedAmount: 610)
//        let discountFourDiners = Discount(numberOfInstallments: 4, amount: 620, discountedAmount: 610)
//
//        let installmentMockDiners = CardConfiguration()
//        installmentMockDiners.cardName = "diners"
//        installmentMockDiners.discounts = [discountOneDiners, discountTwoDiners, discountThreeDiners, discountFourDiners]
//
//        // visa
//        let discountVisaOne = Discount(numberOfInstallments: 1, amount: 1101, discountedAmount: 1001)
//        let discountVisaTwo = Discount(numberOfInstallments: 2, amount: 1102, discountedAmount: 1002)
//        let discountVisaThree = Discount(numberOfInstallments: 3, amount: 1103, discountedAmount: 1002)
//        let discountVisaFour = Discount(numberOfInstallments: 4, amount: 1200, discountedAmount: 1050)
//
//        let installmentMockVisa = CardConfiguration()
//        installmentMockVisa.cardName = "visa"
//        installmentMockVisa.discounts = [discountVisaOne, discountVisaTwo, discountVisaThree, discountVisaFour]
//
//        // maestro
//        let discountOneMaestro = Discount(numberOfInstallments: 1, amount: 500, discountedAmount: 490)
//        let discountTwoMaestro = Discount(numberOfInstallments: 2, amount: 510, discountedAmount: 500)
//        let discountThreeMaestro = Discount(numberOfInstallments: 3, amount: 515, discountedAmount: 505)
//        let discountFourMaestro = Discount(numberOfInstallments: 4, amount: 520, discountedAmount: 510)
//
//        let installmentMockMaestro = CardConfiguration()
//        installmentMockMaestro.cardName = "maestro"
//        installmentMockMaestro.discounts = [discountOneMaestro, discountTwoMaestro, discountThreeMaestro, discountFourMaestro]
//
//        // master
//        let discountOneMaster = Discount(numberOfInstallments: 1, amount: 1000, discountedAmount: 980)
//        let discountTwoMaster = Discount(numberOfInstallments: 2, amount: 1020, discountedAmount: 990)
//        let discountThreeMaster = Discount(numberOfInstallments: 3, amount: 1030, discountedAmount: 1000)
//        let discountFourMaster = Discount(numberOfInstallments: 4, amount: 1050, discountedAmount: 1020)
//
//        let installmentMockMaster = CardConfiguration()
//        installmentMockMaster.cardName = "master"
//        installmentMockMaster.discounts = [discountOneMaster, discountTwoMaster, discountThreeMaster, discountFourMaster]
//
//        // jcb
//        let discountOneJcb = Discount(numberOfInstallments: 1, amount: 700, discountedAmount: 680)
//        let discountTwoJcb = Discount(numberOfInstallments: 2, amount: 710, discountedAmount: 690)
//        let discountThreeJcb = Discount(numberOfInstallments: 3, amount: 720, discountedAmount: 700)
//        let discountFourJcb = Discount(numberOfInstallments: 4, amount: 730, discountedAmount: 710)
//
//        let installmentMockJcb = CardConfiguration()
//        installmentMockJcb.cardName = "jcb"
//        installmentMockJcb.discounts = [discountOneJcb, discountTwoJcb, discountThreeJcb, discountFourJcb]
//
//        // amex
//        let discountOneAmex = Discount(numberOfInstallments: 1, amount: 900, discountedAmount: 880)
//        let discountTwoAmex = Discount(numberOfInstallments: 2, amount: 910, discountedAmount: 890)
//        let discountThreeAmex = Discount(numberOfInstallments: 3, amount: 920, discountedAmount: 900)
//        let discountFourAmex = Discount(numberOfInstallments: 4, amount: 930, discountedAmount: 910)
//
//        let installmentMockAmex = CardConfiguration()
//        installmentMockAmex.cardName = "amex"
//        installmentMockAmex.discounts = [discountOneAmex, discountTwoAmex, discountThreeAmex, discountFourAmex]
//
//        installmentMap.installments = [
//            installmentMockDiners,
//            installmentMockVisa,
//            installmentMockMaestro,
//            installmentMockMaster,
//            installmentMockAmex,
//            installmentMockJcb
//        ]
//
//        return installmentMap
//    }
}
