//
//  ParentSettingsView.swift
//  MathKidsApp
//
//  Created by Lobov Vitaliy on 11.03.2026.
//

import SwiftUI

struct ParentSettingsView: View {
    @EnvironmentObject var parentAuthStore: ParentAuthStore
    @EnvironmentObject var router: AppRouter
    @State private var newPIN = ""
    @State private var infoText = ""

    var body: some View {
        HStack {
            Button("← Назад") {
                router.goHome()
            }
            .buttonStyle(.bordered)

            Spacer()
        }
        .padding(.horizontal)
        Form {
            Section {
                SecureField("Новый PIN", text: $newPIN)
#if os(iOS)
                    .keyboardType(.numberPad)
#endif
                Button("Сохранить новый PIN") {
                    guard !newPIN.isEmpty else { return }
                    parentAuthStore.pinCode = newPIN
                    newPIN = ""
                    infoText = "PIN обновлён"
                }
            } header: {
                Text("PIN-код")
            }

            Section {
                Button("Закрыть родительский экран") {
                    parentAuthStore.lock()
                    infoText = "Экран снова заблокирован"
                }
            } header: {
                Text("Доступ")
            }

            if !infoText.isEmpty {
                Section {
                    Text(infoText)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("PIN и защита")
    }
}
