//
//  ContentView.swift
//  FairyTaleCollageBuilder
//
//  Created by Stanimira Vlaeva on 29.08.20.
//  Copyright © 2020 Stanimira Vlaeva. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.imageCache) var cache: ImageCache
    @State private var isShowPhotoLibrary = false
    @State private var images = Array<UIImage>()
    @State private var imageUrls = Array<String>()
    @State private var url: String = ""

    func addImage() {
        self.imageUrls.append(self.url)
        self.url = ""
    }
    
    var body: some View {
        let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

        return VStack {
            HStack {
                TextField("Image URL", text: $url)
                .keyboardType(.URL)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)

                Button(action: {
                    self.addImage()
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                    }
                    .frame(minWidth: 0, maxWidth: 50, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                self.isShowPhotoLibrary = true
            }) {
                HStack {
                    Image(systemName: "photo")
                        .font(.system(size: 20))
                        
                    Text("Photo Library")
                        .font(.headline)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(30)
                .padding(.horizontal)
            }
            VStack {
                ForEach(images, id: \.self) {
                    Image(uiImage: $0)
                        .resizable()
                        .draggable()
                        .frame(minWidth: 0, maxWidth: 200, minHeight: 0, maxHeight: 200)

                }
                ForEach(imageUrls, id: \.self) {
                    AsyncImage(
                       urlString: $0,
                       cache: self.cache,
                       placeholder: Text("Loading ..."),
                       configuration: { $0.resizable() }
                    )
                    .frame(minWidth: 0, maxWidth: 200, minHeight: 0, maxHeight: 200)
                        .draggable()
                }
            }
            Spacer()
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, images: self.$images)
        }
    }
    
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
