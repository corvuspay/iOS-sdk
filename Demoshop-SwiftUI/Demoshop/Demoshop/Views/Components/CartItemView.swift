//
//  CartItemView.swift
//  Demoshop
//
//  Created by Marko Benačić on 31.07.2023..
//

import SwiftUI

struct CartItemView: View {
    @State var product: Product
    @EnvironmentObject var cart: Cart

    var body: some View {
        HStack(spacing: 40) {
            image
            detailsView
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .buttonStyle(.plain)
    }

    private var detailsView: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(product.name)
                .bold()
            productInfo
            addToCartButton
        }
        .padding(.vertical)
    }

    private var image: some View {
        Image(product.image ?? "Hoodie")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 150)
    }

    private var productInfo: some View {
        Group {
            if product.discount != nil, let newPrice = product.newPrice {
                HStack {
                    Text(String(format: "%.2f", product.price))
                        .strikethrough()
                        .foregroundColor(.gray)
                    Text(String(format: "%.2f", newPrice))
                }
            } else {
                Text(String(format: "%.2f", product.price))
            }
        }
    }

    private var addToCartButton: some View {
        Button("Add to cart") {
            addToCardAction()
        }
        .fontWeight(.bold)
        .frame(width: 110, height: 40)
        .background(.blue)
        .foregroundColor(.white)
        .cornerRadius(12)
    }

    private func addToCardAction() {
        if let cartItem = cart.items.first(where: { item in
            item == CartItem(product: product, quantity: 1)
        }) {
            cart.add(item: cartItem)
        } else {
            cart.add(item: CartItem(product: product, quantity: 1))
        }
    }
}

//struct CartItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        CartItemView(product:ShopItemsRepository.getRandomItem())
//            .previewLayout(.sizeThatFits)
//            .frame(width: 400, height: 150)
//    }
//}
