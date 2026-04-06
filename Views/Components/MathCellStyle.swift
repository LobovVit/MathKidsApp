import SwiftUI
import UIKit

enum MathCellStyle {
    case normal
    case selected
    case disabled
    case carry
    case carrySelected
    case carryDot
    case carryDotSelected
    case readonly
    case readonlyAccent

    var backgroundColor: Color {
        switch self {
        case .normal:
            return Color.gray.opacity(0.10)
        case .selected:
            return Color.green.opacity(0.22)
        case .disabled:
            return Color.gray.opacity(0.06)
        case .carry:
            return Color.orange.opacity(0.18)
        case .carrySelected:
            return Color.orange.opacity(0.28)
        case .carryDot:
            return Color.yellow.opacity(0.18)
        case .carryDotSelected:
            return Color.yellow.opacity(0.30)
        case .readonly, .readonlyAccent:
            return Color.gray.opacity(0.10)
        }
    }

    var borderColor: Color {
        switch self {
        case .normal:
            return Color.gray.opacity(0.30)
        case .selected:
            return .green
        case .disabled:
            return Color.gray.opacity(0.18)
        case .carry:
            return Color.orange.opacity(0.80)
        case .carrySelected:
            return .orange
        case .carryDot:
            return Color.yellow.opacity(0.85)
        case .carryDotSelected:
            return .yellow
        case .readonly:
            return Color.gray.opacity(0.30)
        case .readonlyAccent:
            return Color.red.opacity(0.35)
        }
    }

    var textColor: Color {
        switch self {
        case .readonlyAccent:
            return Color.red.opacity(0.9)
        default:
            return .primary
        }
    }
}

struct DigitInputCell: UIViewRepresentable {
    @Binding var value: String

    var width: CGFloat = 36
    var height: CGFloat = 42
    var fontSize: CGFloat = 28
    var style: MathCellStyle = .normal
    var isEnabled: Bool = true

    // Оставляем параметр для совместимости вызовов,
    // но реальным firstResponder здесь больше не управляем.
    var isFocused: Bool = false

    var onFocus: (() -> Void)? = nil
    var onDigitEntered: ((String) -> Void)? = nil

    func makeCoordinator() -> Coordinator {
        Coordinator(
            value: $value,
            onFocus: onFocus,
            onDigitEntered: onDigitEntered
        )
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: width, height: height))
        textField.delegate = context.coordinator
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .bold)
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.tintColor = .label
        textField.clipsToBounds = true
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        let normalized = normalize(value)

        if uiView.text != normalized {
            uiView.text = normalized
        }

        uiView.isEnabled = isEnabled
        uiView.textColor = UIColor(style.textColor)
        uiView.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .bold)

        uiView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        uiView.layer.cornerRadius = 8
        uiView.layer.masksToBounds = true
        uiView.layer.borderWidth = 1.3
        uiView.layer.borderColor = UIColor(style.borderColor).cgColor
        uiView.backgroundColor = UIColor(style.backgroundColor)
    }

    private func normalize(_ text: String) -> String {
        let digits = text.filter { $0.isNumber }
        guard let last = digits.last else { return "" }
        return String(last)
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var value: String
        let onFocus: (() -> Void)?
        let onDigitEntered: ((String) -> Void)?

        init(
            value: Binding<String>,
            onFocus: (() -> Void)?,
            onDigitEntered: ((String) -> Void)?
        ) {
            self._value = value
            self.onFocus = onFocus
            self.onDigitEntered = onDigitEntered
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            onFocus?()
        }

        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            let current = textField.text ?? ""

            guard let textRange = Range(range, in: current) else {
                return false
            }

            let updated = current.replacingCharacters(in: textRange, with: string)
            let normalized = normalize(updated)

            textField.text = normalized
            value = normalized
            onDigitEntered?(normalized)

            return false
        }

        private func normalize(_ text: String) -> String {
            let digits = text.filter { $0.isNumber }
            guard let last = digits.last else { return "" }
            return String(last)
        }
    }
}

struct DigitReadonlyCell: View {
    let value: String
    var width: CGFloat = 36
    var height: CGFloat = 42
    var fontSize: CGFloat = 28
    var style: MathCellStyle = .readonly

    var body: some View {
        Text(value)
            .font(.system(size: fontSize, weight: .bold, design: .monospaced))
            .foregroundColor(style.textColor)
            .frame(width: width, height: height)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(style.backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style.borderColor, lineWidth: 1.3)
            )
    }
}

struct CarryDotCell: View {
    let isOn: Bool
    var style: MathCellStyle = .carryDot
    var width: CGFloat = 36
    var height: CGFloat = 28

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(style.backgroundColor)

            RoundedRectangle(cornerRadius: 8)
                .stroke(style.borderColor, lineWidth: 1.3)

            if isOn {
                Circle()
                    .fill(style.textColor)
                    .frame(width: 6, height: 6)
            }
        }
        .frame(width: width, height: height)
    }
}
