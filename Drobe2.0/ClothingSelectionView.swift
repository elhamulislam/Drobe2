//
//  ClothingSelectionView.swift
//  Drobe2.0
//
//  Created by Elham on 2025-06-15.
//

import SwiftUI

struct ClothingSelectionView: View {
    @Binding var goToOutfits: Bool
    @Environment(\.dismiss) var dismiss
    
    @FetchRequest(
        entity: ClothingItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ClothingItem.name, ascending: true)]
    ) private var allItems: FetchedResults<ClothingItem>
    
    @State private var selectedItems: Set<ClothingItem> = []
    @State private var showOutfitForm = false
    @State private var showForm = false
    
    
    let columns = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(allItems, id: \.self) { item in
                            VStack {
                                ZStack(alignment: .topTrailing) {
                                    if let data = item.imageData,
                                       let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(10)
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(10)
                                            .overlay(
                                                Image(systemName: "photo")
                                                    .foregroundColor(.gray)
                                            )
                                    }
                                    
                                    if selectedItems.contains(item) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                            .padding(5)
                                    }
                                }
                                
                                Text(item.name ?? "Unnamed")
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            .onTapGesture {
                                if selectedItems.contains(item) {
                                    selectedItems.remove(item)
                                } else {
                                    selectedItems.insert(item)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                if !selectedItems.isEmpty {
                    Button("Next") {
                        showOutfitForm = true
                        showForm = true
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
            .navigationTitle("Select Items for Outfit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showForm) {
                OutfitFormView(
                    selectedItems: Array(selectedItems),
                    goToOutfits: $goToOutfits,
                    dismissParent: dismiss
                )
            }
        }
    }
}

