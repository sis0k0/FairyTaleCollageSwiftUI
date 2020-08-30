//
//  AsyncImage.swift
//  FairyTaleCollageBuilder
//
//  Created by Stanimira Vlaeva on 30.08.20.
//  Copyright © 2020 Stanimira Vlaeva. All rights reserved.
//

import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    private let configuration: (Image) -> Image
    
    init(urlString: String, cache: ImageCache? = nil, placeholder: Placeholder? = nil, configuration: @escaping (Image) -> Image = { $0 }) {
          self.placeholder = placeholder
          self.configuration = configuration
    
        let url = verifyUrl(urlString: urlString) ? URL(string: urlString) : URL(string: "https://cdn.iconscout.com/icon/premium/png-256-thumb/not-found-2061566-1738842.png")
        loader = ImageLoader(url: url!, cache: cache)
    }
    
    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                configuration(Image(uiImage: loader.image!))
            } else {
                placeholder
            }
        }
    }
}

func verifyUrl(urlString: String?) -> Bool {
    guard let urlString = urlString,
          let url = URL(string: urlString) else {
        return false
    }

    return UIApplication.shared.canOpenURL(url)
}
