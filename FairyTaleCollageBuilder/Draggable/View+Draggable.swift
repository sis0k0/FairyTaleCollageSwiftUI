//
//  View+Draggable.swift
//  FairyTaleCollageBuilder
//
//  Created by Stanimira Vlaeva on 29.08.20.
//  Copyright © 2020 Stanimira Vlaeva. All rights reserved.
//

import SwiftUI

extension View {
    func draggable() -> some View {
        return modifier(DraggableView())
    }
}
