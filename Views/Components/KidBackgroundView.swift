import SwiftUI

struct KidBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.blue.opacity(0.15),
                Color.pink.opacity(0.12),
                Color.yellow.opacity(0.10)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(
            VStack {
                HStack {
                    Text("☁️").font(.system(size: 40))
                    Spacer()
                    Text("🌈").font(.system(size: 44))
                }
                .padding()

                Spacer()

                HStack {
                    Text("⭐️").font(.system(size: 30))
                    Spacer()
                    Text("🧸").font(.system(size: 34))
                    Spacer()
                    Text("🎈").font(.system(size: 30))
                }
                .padding()
            }
        )
        .ignoresSafeArea()
    }
}
