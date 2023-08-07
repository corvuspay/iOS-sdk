//
//  CheckoutView.swift
//  Demoshop
//
//  Created by Marko Benačić on 06.08.2023..
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cart: Cart

    var body: some View {
        List(cart.items, id: \.product.id) { item in
            CheckoutItemView(cartItem: item)
                .alignmentGuide(.listRowSeparatorLeading) { d in
                    d[.leading]
                }
                .alignmentGuide(.listRowSeparatorTrailing) { d in
                    d[.trailing]
                }

        }
        .listSectionSeparator(.hidden, edges: .top)

        VStack {
            HStack {
                Text("Total: ")
                Text(String(format: "%.2f", cart.getTotalPrice()))
            }
            .padding([.horizontal])

            NavigationLink(destination: PaymentView().environmentObject(cart)) {

                Text("Proceed to checkout")
                    .fontWeight(.bold)
            }
            .buttonStyle(DemoShopButtonStyle())
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var cart: Cart = {
        var cart = Cart()
        ShopItemsRepository.getShopItems().forEach { product in
            cart.add(item: CartItem(product: product, quantity: 1))
        }
        return cart
    }()

    static var previews: some View {
        CheckoutView().environmentObject(cart)
    }
}
