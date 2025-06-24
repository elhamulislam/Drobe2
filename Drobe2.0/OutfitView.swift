//
//  OutfitView.swift
//  Drobe2.0
//
//  Created by Elham on 2025-06-10.
//

import SwiftUI
import CoreData

struct OutfitView: View {
    @State private var goToOutfits = false
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Outfit.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Outfit.dateCreated, ascending: false)]
    ) private var outfits: FetchedResults<Outfit>

    var body: some View {
        List {
            ForEach(outfits, id: \.id) { outfit in
                VStack(alignment: .leading) {
                    Text(outfit.name ?? "Unnamed Outfit")
                        .font(.headline)
                    Text("Items: \(outfit.clothingSet.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Outfits")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ClothingSelectionView(goToOutfits: $goToOutfits)) {
                    Label("New Outfit", systemImage: "plus")
                }
            }
        }
    }
}
