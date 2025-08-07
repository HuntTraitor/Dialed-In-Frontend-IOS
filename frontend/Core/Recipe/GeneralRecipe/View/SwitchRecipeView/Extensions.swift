//
//  Extensions.swift
//  DialedIn
//
//  Created by Hunter Tratar on 8/7/25.
//

import SwiftUI

extension View {
    func brownShade(for index: Int, total: Int) -> Color {
        let brownShades: [Color] = [
            Color(red: 0.55, green: 0.27, blue: 0.07),
            Color(red: 0.65, green: 0.37, blue: 0.17),
            Color(red: 0.75, green: 0.47, blue: 0.27),
            Color(red: 0.85, green: 0.57, blue: 0.37),
            Color(red: 0.90, green: 0.67, blue: 0.47),
            Color(red: 0.93, green: 0.77, blue: 0.57)
        ]
        
        if total <= brownShades.count {
            return brownShades[index]
        } else {
            let ratio = Double(index) / Double(total - 1)
            let lightness = 0.4 + (ratio * 0.5)
            return Color(red: lightness, green: lightness * 0.7, blue: lightness * 0.3)
        }
    }
    
    func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

