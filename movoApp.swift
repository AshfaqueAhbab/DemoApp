import SwiftUI

@main
struct movoApp: App {
    @State private var showWorkoutSheet: Bool = false

    var body: some Scene {
        WindowGroup {
            MainTabView(isWorkoutPresented: $showWorkoutSheet)
                .onOpenURL { url in
                    // Triggered when jumping from the shield action
                    if url.scheme == "movo" {
                        showWorkoutSheet = true
                    }
                }
        }
    }
}
