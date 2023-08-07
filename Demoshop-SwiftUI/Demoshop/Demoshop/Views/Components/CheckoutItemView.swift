//
//  CheckoutItemView.swift
//  Demoshop
//
//  Created by Marko Benačić on 06.08.2023..
//

import SwiftUI
import Combine

struct CheckoutItemView: View {
    @State var cartItem: CartItem
    @EnvironmentObject var cart: Cart
    @State private var quantityString: String

    private var cancellables = [AnyCancellable]()

    init(cartItem: CartItem) {
        _cartItem = State(initialValue: cartItem)
        _quantityString = State(initialValue: String(cartItem.quantity))

    }

    var body: some View {
        HStack {
            Image(cartItem.product.image ?? "Hoodie")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 150)
            VStack {
                Text(cartItem.product.name)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    if cartItem.product.discount != nil, let newPrice = cartItem.product.newPrice {
                        Text(String(format: "%.2f", cartItem.product.price))
                            .strikethrough()
                            .foregroundColor(.gray)
                        Text(String(format: "%.2f", newPrice))
                    } else {
                        Text(String(format: "%.2f", cartItem.product.price))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    TextField("", text: $quantityString)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 36)
                        .disabled(true)

                    Button {
                        if let currentQuantity = Int(quantityString), currentQuantity > 1 {
                            quantityString = String(currentQuantity - 1)
                            cart.removeOne(item: cartItem)
                        }
                    } label: {
                        Image(systemName: "minus.square")
                            .resizable()
                            .frame(width: 28, height: 28)
                    }
                    Button {
                        if let currentQuantity = Int(quantityString) {
                            quantityString = String(currentQuantity + 1)
                            cart.add(item: cartItem)
                        }
                    } label: {
                        Image(systemName: "plus.square")
                            .resizable()
                            .frame(width: 28, height: 28)
                    }
                    Spacer()
                }

            }
            .padding([.top,.bottom])

            Button {
                withAnimation {
                    cart.remove(item: cartItem)
                }
            } label: {
                Image(systemName: "trash.square.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.red)
            }

        }
        .buttonStyle(.plain)
    }
}

struct CheckoutItemView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutItemView(cartItem: CartItem(product: ShopItemsRepository.getRandomItem(), quantity: 1))
    }
}
