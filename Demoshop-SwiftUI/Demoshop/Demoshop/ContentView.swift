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
            //                .navigationBarItems(trailing: Image(systemName: "cart.fill"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if cart.items.isEmpty {
                            Button(action: {
                            }) {
                                Image(systemName: "cart.fill")
                                    .foregroundColor(.black)
                            }
                        } else {
                            Button(action: {
                            }) {
                                Text("\(cart.numberOfItems)")
                                    .foregroundColor(.red)
                                Image(systemName: "cart.fill")
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
