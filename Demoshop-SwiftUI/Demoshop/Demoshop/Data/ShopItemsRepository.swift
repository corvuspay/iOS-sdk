//
//  CartItemsRepository.swift
//  Demoshop
//
//  Created by Marko Benačić on 31.07.2023..
//

import Foundation

class ShopItemsRepository {

    private static var items: [Product] {
        var list: [Product] = []

        list.append(Product(
            id: 1,
            name: "Hoodie with pocket",
            price: 99.0,
            description: nil,
            image: "Hoodie_with_pocket",
            discount: 21.0
            )
        )
        list.append(
            Product(
                id: 2,
                name: "Beanie",
                price: 35.10,
                description: nil,
                image: "Beanie",
                discount: 5.81
            )
        )

        list.append(
            Product(
                id: 3,
                name: "Belt",
                price: 35.10,
                description: nil,
                image: "Belt",
                discount: 5.81
            )
        )
        list.append(
            Product(
                id: 4,
                name: "Hoodie",
                price: 154.0,
                description: nil,
                image: "Hoodie",
                discount: nil
            )
        )
        list.append(
            Product(
                id: 5,
                name: "Hoodie with Logo",
                price: 203.0,
                description: nil,
                image: "Hoodie_with_logo",
                discount: 24.0
            )
        )
        list.append(
            Product(
                id: 6,
                name: "Polo",
                price: 55.0,
                description: nil,
                image: "Polo",
                discount: 12.0
            )
        )

        list.append(
            Product(
                id: 7,
                name: "Hoodie with zipper",
                price: 120.0,
                description: nil,
                image: "Hoodie_with_zipper",
                discount: nil
            )
        )

        list.append(
            Product(
                id: 8,
                name: "Long sleeve tee",
                price: 40.0,
                description: nil,
                image: "Long_sleeve_tee",
                discount: 8.0
            )
        )

        list.append(
            Product(
                id: 9,
                name: "Sunglasses",
                price: 35.0,
                description: nil,
                image: "Sunglasses",
                discount: nil
            )
        )

        list.append(
            Product(
                id: 10,
                name: "T-shirt",
                price: 44.0,
                description: nil,
                image: "T-shirt",
                discount: 7.0
            )
        )

        list.append(
            Product(
                id: 11,
                name: "V-neck tee",
                price: 30.0,
                description: nil,
                image: "V-neck_tee",
                discount: 5.5
            )
        )

        return list
    }

    static func getShopItems() -> [Product] {
        return items
    }

    static func getRandomItem() -> Product {
        return items.randomElement() ?? Product(id: 999, name: "Item", price: 100, description: nil, image: nil, discount: nil)
    }

}
