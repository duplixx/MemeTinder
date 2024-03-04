//
//  spinner.swift
//  MemeTinder
//
//  Created by Shekhar Patel on 02/03/24.
//

import Foundation
import SwiftUI

struct SpinnerView: View {
  @State private var isAnimating = false

  var body: some View {
    VStack {
      Circle()
        .trim(from: 0, to: 0.7)
        .stroke(Color.blue, lineWidth: 4)
        .frame(width: 50, height: 50)
        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
        .animation(Animation.linear(duration: 3).repeatForever(autoreverses: false), value: UUID())
        .onAppear {
          self.isAnimating = true
        }
    }
  }
}
