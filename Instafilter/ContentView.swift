//
//  ContentView.swift
//  Instafilter
//
//  Created by Даниил Сивожелезов on 07.11.2024.
//

import PhotosUI
import SwiftUI
import StoreKit

struct ContentView: View {
    @Environment(\.requestReview) var requestReview
    
    @State private var pickerItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    
    var body: some View {
        let example = selectedImages.first ?? Image(systemName: "photo.artframe")
        
        VStack {
            HStack {
                PhotosPicker(selection: $pickerItems, maxSelectionCount: 3, matching: .any(of: [.images, .not(.screenshots)])) {
                    Label("Select photos", systemImage: "photo.artframe")
                }
                Spacer()
                ShareLink(item: example, preview: SharePreview("Some image", image: example)) {
                    Image(systemName: "arrowshape.turn.up.right")
                }
            }
            
            Button("Request Review") {
                requestReview()
            }
            
            ScrollView {
                ForEach(0..<selectedImages.count, id: \.self) { i in
                    selectedImages[i]
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .padding(.horizontal, 20)
        .onChange(of: pickerItems) {
            Task {
                selectedImages.removeAll()
                
                for pickerItem in pickerItems {
                    if let loadedImage = try await pickerItem.loadTransferable(type: Image.self) {
                        selectedImages.append(loadedImage)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
