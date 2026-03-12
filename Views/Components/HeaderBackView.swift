import SwiftUI

struct HeaderBackView: View { let title: String; @EnvironmentObject var router: AppRouter; var body: some View { HStack { Button("← Назад") { router.goHome() }.buttonStyle(.bordered); Spacer(); Text(title).font(.headline); Spacer(); Color.clear.frame(width: 80, height: 1) }.padding(.horizontal).padding(.top, 4) } }
