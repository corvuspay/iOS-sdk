//
//  InstallmentsHelper.swift
//  Demoshop
//
//  Created by Marko Benačić on 07.08.2023..
//

import Foundation

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
    
}
