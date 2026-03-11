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

            Button(action: submitAction) {
                Text("Ответить")
                    .font(.headline)
                    .frame(maxWidth: 240)
                    .padding(.vertical, 12)
            }
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(answerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray.opacity(0.5) : Color.accentColor)
            )
            .disabled(answerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}
