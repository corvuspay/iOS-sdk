//
//  InstallmentType.swift
//  Demoshop
//
//  Created by Marko Benačić on 08.03.2025..
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

// MARK: Helpers for demoShop UI
extension InstallmentTuple {
    var toString: String {
        return "(\(oneTime), \(lowerBound), \(upperBound))"
    }
}

extension InstallmentsParams {
    var toString: String {
        if let numberOfInstallments {
            return String(numberOfInstallments)
        } else if let paymentAll {
            return paymentAll.toString
        } else if let paymentAllDynamic {
            return paymentAllDynamic.toString
        } else {
            return ""
        }
    }
}

extension DynamicInstallmentsParams {
    var toString: String {
        var stringBuilder = ""

        if let paymentAmex {
            stringBuilder.append("paymentAmex = " + paymentAmex.toString + "\n")
        }
        if let paymentJcb {
            stringBuilder.append("paymentJcb = " + paymentJcb.toString + "\n")
        }
        if let paymentDina {
            stringBuilder.append("paymentDina = " + paymentDina.toString + "\n")
        }
        if let paymentVisa {
            stringBuilder.append("paymentVisa = " + paymentVisa.toString + "\n")
        }
        if let paymentDiners {
            stringBuilder.append("paymentDiners = " + paymentDiners.toString + "\n")
        }
        if let paymentMaster {
            stringBuilder.append("paymentMaster = " + paymentMaster.toString + "\n")
        }
        if let paymentMaestro {
            stringBuilder.append("paymentMaestro = " + paymentMaestro.toString + "\n")
        }
        if let paymentDiscover {
            stringBuilder.append("paymentDiscover = " + paymentDiscover.toString + "\n")
        }

        return stringBuilder.trimmingCharacters(in: .newlines)
    }
}

extension InstallmentMap {
    var toString: String {
        var stringBuilder = "["

        installments.forEach { cardConfiguration in
            stringBuilder.append("CardConfiguration(")
            stringBuilder.append("cardType=\(cardConfiguration.cardName),")
            stringBuilder.append("discounts=[")
            cardConfiguration.discounts.forEach { discount in
                stringBuilder.append(discount.toString)
            }
            stringBuilder.append("]")
            stringBuilder.append(")\n")
        }

        stringBuilder.append("]")
        return stringBuilder
    }
}

extension Discount {
    var toString: String {
        return "Discount(numberOfInstallments=\(numberOfInstallments), amount=\(amount),discountedAmount=\(discountedAmount)"
    }
}
