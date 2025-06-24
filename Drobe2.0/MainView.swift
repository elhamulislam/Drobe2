//
//  ContentView.swift
//  Drobe2.0
//
//  Created by Elham on 2025-06-09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Text("Drobe")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)

                NavigationLink(destination: ClosetView()) {
                    Text("Closet")
                        .font(.title2)
                        .frame(width: 200, height: 50)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                }

                NavigationLink(destination: OutfitView()) {
                    Text("Outfits")
                        .font(.title2)
                        .frame(width: 200, height: 50)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
