import SwiftUI

@main
struct movoApp: App {
    @StateObject private var appState = AppState()
    @State private var showWorkoutSheet: Bool = false

    var body: some Scene {
        WindowGroup {
            MainTabView(isWorkoutPresented: $showWorkoutSheet)
                .environmentObject(appState)
                .onOpenURL { url in
                    // Triggered when jumping from the shield action
                    if url.scheme == "movo" {
                        showWorkoutSheet = true
                    }
                }
        }
    }
}
