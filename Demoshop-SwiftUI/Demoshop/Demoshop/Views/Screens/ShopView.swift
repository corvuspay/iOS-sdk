//
//  ShopVIew.swift
//  Demoshop
//
//  Created by Marko Benačić on 31.07.2023..
//

import SwiftUI

struct ShopView: View {
    @State var shopItems = ShopItemsRepository.getShopItems()

    var body: some View {
        ScrollView {
            VStack {
                ForEach(shopItems, id: \.id) { product in
                    CartItemView(product: product)
                    Divider()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }
    }
    
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}
