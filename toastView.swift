//
//  toastView.swift
//  MemeTinder
//
//  Created by Shekhar Patel on 02/03/24.
//

import Foundation
import SwiftUI
struct ToastView<Content: View>: View {
    let content: Content
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Spacer()
            if isPresented {
                content
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}
