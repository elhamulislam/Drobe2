//
//  ClosetView.swift
//  Drobe2.0
//
//  Created by Elham on 2025-06-10.
//

import SwiftUI
import CoreData

struct ClosetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: ClothingItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ClothingItem.name, ascending: true)]
    ) private var items: FetchedResults<ClothingItem>
    
    @State private var showingAddForm = false
    @State private var showSelectionSheet = false
    @State private var redirectToOutfits = false
    @State private var showItemActionSheet = false
    @State private var selectedItemForAction: ClothingItem? = nil
    
    
    @State private var selectedSort: SortOption = .alphabetical
    
    enum SortOption {
        case alphabetical
        case dateAdded
    }
    enum CategoryFilter: String, CaseIterable {
        case all = "All"
        case top = "Top"
        case bottom = "Bottom"
        case outerwear = "Outerwear"
        case shoes = "Shoes"
        case accessory = "Accessory"
    }
    
    @State private var selectedCategory: CategoryFilter = .all
    
    
    let columns = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        NavigationStack{
            ZStack {
                VStack(alignment: .leading) {
                    if selectedCategory != .all {
                        Text(selectedCategory.rawValue)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                    }
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            let visibleItems: [ClothingItem] = {
                                var filtered = items.filter { item in
                                    guard let category = item.category else { return false }
                                    return selectedCategory == .all || category == selectedCategory.rawValue
                                }
                                
                                switch selectedSort {
                                case .alphabetical:
                                    return filtered.sorted { ($0.name ?? "") < ($1.name ?? "") }
                                case .dateAdded:
                                    return filtered.sorted { ($0.dateAdded ?? .distantPast) > ($1.dateAdded ?? .distantPast) }
                                }
                            }()
                            
                            ForEach(visibleItems, id: \.id) { item in
                                VStack {
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
                                    
                                    Text(item.name ?? "Unnamed")
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                                .onLongPressGesture {
                                    selectedItemForAction = item
                                    withAnimation {
                                        showItemActionSheet = true
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                if showItemActionSheet, let selectedItem = selectedItemForAction {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Text(selectedItem.name ?? "Selected Item")
                            .font(.headline)
                            .padding(.bottom)
                        
                        HStack(spacing: 40) {
                            Button {
                                // Add edit functionality later
                                showItemActionSheet = false
                            } label: {
                                VStack {
                                    Image(systemName: "pencil")
                                    Text("Edit")
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(12)
                            }
                            
                            Button(role: .destructive) {
                                deleteItem(selectedItem)
                                showItemActionSheet = false
                            } label: {
                                VStack {
                                    Image(systemName: "trash")
                                    Text("Delete")
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(12)
                            }
                        }
                        
                        Button("Cancel") {
                            showItemActionSheet = false
                        }
                        .padding(.top)
                        .foregroundColor(.blue)
                    }
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(20)
                    .padding(.horizontal, 30)
                    .transition(.scale)
                }
            }
            .navigationTitle("Your Closet")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Section(header: Text("Sort By")) {
                            Button("Alphabetical (A-Z)") {
                                selectedSort = .alphabetical
                            }
                            Button("Date Added") {
                                selectedSort = .dateAdded
                            }
                        }

                        Section(header: Text("Filter Category")) {
                            ForEach(CategoryFilter.allCases, id: \.self) { filter in
                                Button(filter.rawValue) {
                                    selectedCategory = filter
                                }
                            }
                        }
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            showingAddForm = true
                        }) {
                            Image(systemName: "plus")
                        }

                        Button(action: {
                            showSelectionSheet = true
                        }) {
                            Image(systemName: "figure.dress.line.vertical.figure")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddForm) {
                AddClothingFormView()
            }
            .sheet(isPresented: $showSelectionSheet) {
                ClothingSelectionView(goToOutfits: $redirectToOutfits)
            }
            .navigationDestination(isPresented: $redirectToOutfits) {
                OutfitView()
            }
        }
    }
    private func deleteItem(_ item: ClothingItem) {
        viewContext.delete(item)
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete item: \(error)")
        }
    }
}

#Preview {
    ClosetView()
}
