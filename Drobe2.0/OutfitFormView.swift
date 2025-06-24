//
//  OutfitFormVIew.swift
//  Drobe2.0
//
//  Created by Elham on 2025-06-15.
//

import SwiftUI

struct OutfitFormView: View {
    var selectedItems: [ClothingItem]
    @Binding var goToOutfits: Bool
    var dismissParent: DismissAction
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext



    @State private var outfitName: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Outfit Name")) {
                    TextField("Enter outfit name", text: $outfitName)
                }

                Section(header: Text("Items")) {
                    ForEach(selectedItems, id: \.self) { item in
                        HStack {
                            if let data = item.imageData,
                               let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .cornerRadius(6)
                            }

                            Text(item.name ?? "Unnamed")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("New Outfit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveOutfit()
                    }
                    
                    .disabled(outfitName.isEmpty)
                }
            }
        }
    }

    private func saveOutfit() {
        let newOutfit = Outfit(context: viewContext)
        newOutfit.id = UUID()
        newOutfit.name = outfitName
        newOutfit.dateCreated = Date()

        for item in selectedItems {
            newOutfit.addToClothingItems(item)
        }

        do {
            try viewContext.save()
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                dismissParent()
                goToOutfits = true
            }
        } catch {
            print("Failed to save outfit: \(error)")
        }
    }
}

