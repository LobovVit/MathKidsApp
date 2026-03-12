import SwiftUI

struct NumberPadAnswerView: View { @Binding var answerText: String; let submitAction: () -> Void; var body: some View { VStack(spacing: 16) { TextField("Ответ", text: $answerText)
#if os(iOS)
.keyboardType(.numberPad)
#endif
.textFieldStyle(RoundedBorderTextFieldStyle()).multilineTextAlignment(.center).font(.system(size: 32, weight: .bold)).frame(maxWidth: 240); Button("Ответить", action: submitAction).buttonStyle(.borderedProminent).controlSize(.large).disabled(answerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) } } }
