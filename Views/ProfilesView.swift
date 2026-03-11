//
//  ProfilesView.swift
//  MathKidsApp
//
//  Created by Lobov Vitaliy on 11.03.2026.
//

import SwiftUI

struct ProfilesView: View {
    @EnvironmentObject var profilesStore: ProfilesStore
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
        List {
            ForEach(profilesStore.profiles) { profile in
                NavigationLink {
                    ChildProfileView(profileID: profile.id)
                } label: {
                    HStack {
                        Text(profile.avatar).font(.system(size: 34))
                        VStack(alignment: .leading) {
                            Text(profile.name).font(.headline)
                            Text("Возраст: \(profile.age) · \(profile.selectedLevel.title)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if profilesStore.selectedProfileID == profile.id {
                            Text("Активный")
                                .font(.caption)
                                .padding(6)
                                .background(Capsule().fill(Color.blue.opacity(0.15)))
                        }
                    }
                }
                .profileDeleteActions {
                    profilesStore.deleteProfile(profile)
                }
            }

            Button {
                profilesStore.addProfile()
            } label: {
                Label("Добавить профиль", systemImage: "plus.circle.fill")
            }
        }
        .navigationTitle("Профили детей")
    }
}
private extension View {
    @ViewBuilder
    func profileDeleteActions(_ action: @escaping () -> Void) -> some View {
        if #available(macOS 12.0, *) {
            swipeActions {
                Button(role: .destructive, action: action) {
                    Label("Удалить", systemImage: "trash")
                }
            }
        } else {
            contextMenu {
                Button(action: action) {
                    Label("Удалить", systemImage: "trash")
                }
            }
        }
    }
}

