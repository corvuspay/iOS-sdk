//
//  CartItem.swift
//  Demoshop
//
//  Created by Marko Benačić on 27.07.2023..
//

import Foundation

class CartItem: Equatable, ObservableObject {
    let product: Product
    @Published var quantity: Int

    init(product: Product, quantity: Int) {
        self.product = product
        self.quantity = quantity
    }

    var totalPrice: Double {
        if let discount = product.discount {
            return (product.price - discount) * Double(quantity)
        } else {
            return product.price * Double(quantity)
        }
    }

    /*
     Returns: Price prior to discount. If there is no discount, returns nil.
    */
    var oldPrice: Double? {
        guard product.discount != nil else { return nil }
        return product.price * Double(quantity)
    }

    var totalDiscount: Double {
        guard let discount = product.discount else { return 0.0 }
        return discount * Double(quantity)
    }

    func addOne() {
        quantity += 1
    }

    func removeOne() {
        quantity += 1
    }

}

// MARK: - equatable conformance
extension CartItem {
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.product == rhs.product
    }
}

