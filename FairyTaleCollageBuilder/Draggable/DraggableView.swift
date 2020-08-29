//
//  DraggableView.swift
//  FairyTaleCollageBuilder
//
//  Created by Stanimira Vlaeva on 29.08.20.
//  Copyright © 2020 Stanimira Vlaeva. All rights reserved.
//

import SwiftUI

struct DraggableView: ViewModifier {
    @State var offset = CGPoint(x: 0, y: 0)
    
    func body(content: Content) -> some View {
        content
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    self.offset.x += value.location.x - value.startLocation.x
                    self.offset.y += value.location.y - value.startLocation.y
            })
            .offset(x: offset.x, y: offset.y)
    }
}
