import SwiftUI

struct KidBackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.12), Color.pink.opacity(0.10), Color.yellow.opacity(0.08)]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .overlay(
                VStack {
                    HStack { Text("☁️").font(.system(size: 24)); Spacer(); Text("🌈").font(.system(size: 26)) }
                        .padding(.horizontal, 18)
                        .padding(.top, 10)
                    Spacer()
                    HStack { Text("⭐️").font(.system(size: 20)); Spacer(); Text("🧸").font(.system(size: 22)); Spacer(); Text("🎈").font(.system(size: 20)) }
                        .padding(.horizontal, 18)
                        .padding(.bottom, 10)
                }
            )
            .ignoresSafeArea()
    }
}
