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
    @State private var texts: [String] = []
    @State private var text: String = ""

    func addImage() {
        self.imageUrls.append(self.url)
        self.url = ""
    }
    
    func addText() -> Void {
        self.texts.append(self.text)
        self.text = ""
    }

    public func exportScene() -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        
        let width = screenshotImage!.size.width * scale
        let height = screenshotImage!.size.height * scale
        let rect = CGRect(x: 0, y: 450, width: width, height: height)
        let croppedImage = cropImage(image: screenshotImage!, toRect: rect)
        
        
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil)

        return screenshotImage
    }
    
    func cropImage(image:UIImage, toRect rect:CGRect) -> UIImage{
        let imageRef:CGImage = image.cgImage!.cropping(to: rect)!
        let croppedImage:UIImage = UIImage(cgImage:imageRef)
        return croppedImage
    }
    
    var body: some View {
        let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

        let sceneModifiers = VStack {
            HStack {
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
                Button(action: {
                    _ = self.exportScene()
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 20))
                    }
                    .frame(minWidth: 0, maxWidth: 50, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    .padding(.horizontal)
                }
            }
            
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

            HStack {
                TextField("Add Custom Text", text: $text)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)

                Button(action: {
                    self.addText()
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
        }

        let scene = ZStack {
            ForEach(images, id: \.self) {
                Image(uiImage: $0)
                    .resizable()
                    .draggable()
                    .frame(minWidth: 0, maxWidth: .infinity)

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
            ForEach(texts, id: \.self) {
                Text($0)
                    .draggable()
                    .foregroundColor(Color.yellow)
                    .font(.system(size: 30))
                
            }
        }
        
        return VStack {
            sceneModifiers
            scene
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
