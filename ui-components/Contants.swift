//
//  ResourceNames.swift
//  Example
//
//  Created by Long Pham on 9/7/25.
//

import SwiftUI

struct ResourceHelper {
    static let ICON_BACK = "chevron.left"
    static let ICON_LIVENESS = "person.fill.viewfinder"
    static let ICON_CLOUD = "cloud"
    
    
    static let bundle = Bundle(identifier: "com.joinself.mobile.ui.components")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
    
    static let primaryBlue: Color = .init(hex: "#007AFF")
    static let primaryError: Color = .init(hex: "#FF3B30")
}
