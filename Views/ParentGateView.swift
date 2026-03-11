//
//  ParentGateView.swift
//  MathKidsApp
//
//  Created by Lobov Vitaliy on 11.03.2026.
//

import SwiftUI

struct ParentGateView: View {
    @EnvironmentObject var parentAuthStore: ParentAuthStore
    @State private var attempt = ""
    @State private var errorText: String?
    @EnvironmentObject var router: AppRouter

    var body: some View {
        HStack {
            Button("← Назад") {
                router.goHome()
            }
            .buttonStyle(.bordered)

            Spacer()
        }
        .padding(.horizontal)
        Group {
            if parentAuthStore.isUnlocked {
                ParentDashboardView()
            } else {
                VStack(spacing: 20) {
                    Text("🔐")
                        .font(.system(size: 60))
                    Text("Введите PIN-код")
                        .font(.title.bold())
                    SecureField("PIN", text: $attempt)
#if os(iOS)
                        .keyboardType(.numberPad)
#endif
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 220)
                    if let errorText {
                        Text(errorText)
                            .foregroundColor(.red)
                    }
                    gateButton
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(KidBackgroundView())
            }
        }
        .navigationTitle("Родительский экран")
    }

    @ViewBuilder
    private var gateButton: some View {
        let button = Button("Открыть") {
            if parentAuthStore.unlock(with: attempt) {
                errorText = nil
            } else {
                errorText = "Неверный PIN"
            }
        }

        if #available(macOS 12.0, *) {
            button.buttonStyle(.borderedProminent)
        } else {
            button
        }
    }
}
