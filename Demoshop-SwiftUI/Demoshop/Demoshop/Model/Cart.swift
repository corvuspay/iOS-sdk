//
//  Cart.swift
//  Demoshop
//
//  Created by Marko Benačić on 27.07.2023..
//

import Foundation

class Cart: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var numberOfItems: Int = 0

    /*
     Returns: The total price as a Double if total discount exists; If there is no discount, returns zero.
    */
    func getTotalPrice() -> Double {
        return items.reduce(0.0) { partialResult, cartItem in
            partialResult + cartItem.totalPrice
        }
    }

    /*
     Returns: The discounted price as a Double if total discount exists; If there is no discount, returns zero.
    */
    func getTotalDiscount() -> Double? {
        return items.reduce(0.0) { partialResult, cartItem in
            partialResult + cartItem.totalDiscount
        }
    }

    func add(item: CartItem) {
        if let exists = items.first(where: { cartItem in
            cartItem == item
        }) {
            exists.addOne()
            numberOfItems += 1
        }else {
            items.append(item)
            numberOfItems += item.quantity
        }
    }

    func remove(item: CartItem) {

        numberOfItems -= items.first(where: { cartItem in
            cartItem == item
        })?.quantity ?? 0

        items.removeAll { cartItem in
            cartItem == item
        }
    }

    func removeAll() {
        items = []
        numberOfItems = 0
    }

    func getItems() -> [CartItem] {
        return items
    }

}
