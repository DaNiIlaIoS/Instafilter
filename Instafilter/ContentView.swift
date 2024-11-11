//
//  ContentView.swift
//  Instafilter
//
//  Created by Даниил Сивожелезов on 07.11.2024.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var pickerItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    
    var body: some View {
        let example = selectedImages.first ?? Image(systemName: "photo.artframe")
        
        VStack {
            HStack {
                PhotosPicker(selection: $pickerItems, maxSelectionCount: 3, matching: .any(of: [.images, .not(.screenshots)])) {
                    Label("Select photos", systemImage: "photo.artframe")
                }
                
                ShareLink(item: example, preview: SharePreview("Some image", image: example)) {
                    Image(systemName: "arrowshape.turn.up.right.fill")
                }
            }
            
            ScrollView {
                ForEach(0..<selectedImages.count, id: \.self) { i in
                    selectedImages[i]
                        .resizable()
                        .scaledToFit()
                }
            }
        }
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
