import SwiftUI

struct ConfettiView: View {
    private let pieces = Array(0..<18)
    private let colors: [Color] = [.pink, .yellow, .green, .blue, .orange]

    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { timeline in
                let elapsed = timeline.date.timeIntervalSinceReferenceDate

                ZStack {
                    ForEach(pieces, id: \.self) { index in
                        ConfettiPiece(
                            color: colors[index % colors.count],
                            phase: piecePhase(for: index, elapsed: elapsed),
                            size: pieceSize(for: index),
                            containerHeight: geometry.size.height,
                            xPosition: pieceXPosition(for: index, width: geometry.size.width),
                            rotation: pieceRotation(for: index, elapsed: elapsed)
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }

    private func piecePhase(for index: Int, elapsed: TimeInterval) -> CGFloat {
        let speed = 0.35 + Double(index % 5) * 0.08
        return CGFloat((elapsed * speed).truncatingRemainder(dividingBy: 1))
    }

    private func pieceSize(for index: Int) -> CGSize {
        let width = CGFloat(10 + (index % 3) * 4)
        let height = CGFloat(14 + (index % 4) * 3)
        return CGSize(width: width, height: height)
    }

    private func pieceXPosition(for index: Int, width: CGFloat) -> CGFloat {
        let normalized = CGFloat((index * 37) % 100) / 100
        return 24 + normalized * max(width - 48, 1)
    }

    private func pieceRotation(for index: Int, elapsed: TimeInterval) -> Angle {
        .degrees((elapsed * Double(90 + index * 11)).truncatingRemainder(dividingBy: 360))
    }
}

private struct ConfettiPiece: View {
    let color: Color
    let phase: CGFloat
    let size: CGSize
    let containerHeight: CGFloat
    let xPosition: CGFloat
    let rotation: Angle

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(color.gradient)
            .frame(width: size.width, height: size.height)
            .rotationEffect(rotation)
            .position(x: xPosition, y: CGFloat(-20) + phase * max(containerHeight + 40, 1))
            .opacity(1 - phase * 0.15)
    }
}
