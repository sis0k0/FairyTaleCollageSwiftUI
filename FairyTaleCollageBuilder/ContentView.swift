//
//  ContentView.swift
//  FairyTaleCollageBuilder
//
//  Created by Stanimira Vlaeva on 29.08.20.
//  Copyright © 2020 Stanimira Vlaeva. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowPhotoLibrary = false
    @State private var images = Array<UIImage>()

    var body: some View {
        return VStack {
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
