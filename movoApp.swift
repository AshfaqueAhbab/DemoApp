import SwiftUI

@main
struct movoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .sheet(isPresented: $showWorkoutSheet) {
                WorkoutCameraSheet() // Your CoreML camera workout view[cite: 8, 9]
                }
                .onOpenURL { url in
                // Triggered when jumping from the shield action
                if url.scheme == "movo" {
                    showWorkoutSheet = true
                }
            }
        }
    }
}
