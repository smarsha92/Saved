//
//  FABButton.swift
//
//  Created by Play to Xcode
//

import SwiftUI

struct FABButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 77, height: 73)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.green)
                )
        }
        .scaleEffect(0.8)
        .frame(width: 77, height: 73)
        .position(x: 164, y: 351)
        .zIndex(10)
        .allowsHitTesting(true)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.2)
            .ignoresSafeArea()
        
        FABButton {
            print("FAB tapped")
        }
    }
}
