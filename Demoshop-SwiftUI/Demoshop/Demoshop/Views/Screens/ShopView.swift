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
        List(shopItems, id: \.id) { product in
            CartItemView(product: product)
                .alignmentGuide(.listRowSeparatorLeading) { d in
                    d[.leading]
                }
                .alignmentGuide(.listRowSeparatorTrailing) { d in
                    d[.trailing]
                }

        }
        .listSectionSeparator(.hidden, edges: .top)
    }
    
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}
