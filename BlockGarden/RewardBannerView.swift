import SwiftUI

struct RewardBannerView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.94))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
    }
}
