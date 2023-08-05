//
//  CartItem.swift
//  Demoshop
//
//  Created by Marko Benačić on 27.07.2023..
//

import Foundation

struct Product: Equatable {
    let id: Double
    let name: String
    let price: Double
    let description: String?
    let image: String?
    let discount: Double?
}

extension Product {
    var newPrice: Double? {
        guard let discount else { return nil }
        return price - discount
    }
}
