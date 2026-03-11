import SwiftUI

struct NumberPadAnswerView: View {
    @Binding var answerText: String
    let submitAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            TextField("Ответ", text: $answerText)
#if os(iOS)
                .keyboardType(.numberPad)
#endif
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .font(.system(size: 32, weight: .bold))
                .frame(maxWidth: 240)

            Button("Ответить", action: submitAction)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.accentColor)
                .cornerRadius(12)
                .opacity(answerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)
                .disabled(answerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}
