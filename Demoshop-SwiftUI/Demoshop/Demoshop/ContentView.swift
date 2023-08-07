//
//  ContentView.swift
//  Demoshop
//
//  Created by Marko Benačić on 27.07.2023..
//

import SwiftUI

struct ContentView: View {
    @StateObject var cart = Cart()

    var body: some View {
        NavigationView {
            ShopView()
                .navigationTitle("CorvusPay Demo Shop")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: CheckoutView().environmentObject(cart)) {
                                if cart.items.isEmpty {
                                    Image(systemName: "cart.fill")
                                        .foregroundColor(.black)
                                } else {
                                    Text("\(cart.items.count)")
                                        .foregroundColor(.red)
                                    Image(systemName: "cart.fill.badge.plus")
                                        .foregroundColor(.red)
                                }
                            }
                    }

                }
        }
        .environmentObject(cart)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
