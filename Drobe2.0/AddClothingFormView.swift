//
//  AddClothingFormView.swift
//  Drobe2.0
//
//  Created by Elham on 2025-06-10.
//

import SwiftUI
import PhotosUI

struct AddClothingFormView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @Environment(\.dismiss) var dismiss

    @State private var itemName: String = ""
    @State private var selectedCategory: String = "Top"
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil

    let categories = ["Top", "Bottom", "Outerwear", "Shoes", "Accessory"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Name")) {
                    TextField("Enter name", text: $itemName)
                }

                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section(header: Text("Image")) {
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        HStack {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                Image(systemName: "photo.on.rectangle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                            }

                            Text("Select Image")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .onChange(of: selectedPhoto) {
                Task {
                    if let data = try? await selectedPhoto?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newItem = ClothingItem(context: viewContext)
                        newItem.id = UUID()
                        newItem.name = itemName
                        newItem.category = selectedCategory
                        newItem.dateAdded = Date()
                        if let image = selectedImage {
                            newItem.imageData = image.jpegData(compressionQuality: 0.8)
                        }

                        do {
                            try viewContext.save()
                            print("✅ Item saved successfully")
                            dismiss()
                        } catch {
                            print("❌ Failed to save item: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    AddClothingFormView()
}
