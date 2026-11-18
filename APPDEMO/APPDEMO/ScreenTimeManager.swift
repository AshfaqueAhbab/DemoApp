
import SwiftUI
import FamilyControls

import Combine

@MainActor
final class ScreenTimeManager: ObservableObject {

    @Published var selection = FamilyActivitySelection()
    @Published var isPickerPresented = false

    @Published var isAuthorized =
        AuthorizationCenter.shared.authorizationStatus == .approved

    @Published var statusMessage = "Screen Time is not connected yet."

    func requestAuthorization() {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(
                    for: .individual
                )

                isAuthorized =
                    AuthorizationCenter.shared.authorizationStatus == .approved

                if isAuthorized {
                    statusMessage = "Screen Time access granted!"
                    isPickerPresented = true
                }

            } catch {
                statusMessage =
                    "Authorization failed: \(error.localizedDescription)"
            }
        }
    }
}

struct ScreenTimeSetupView: View {

    @StateObject private var manager = ScreenTimeManager()

    var body: some View {
        VStack(spacing: 20) {

            Image(systemName: "hourglass")
                .font(.system(size: 45))
                .foregroundStyle(Color.movoGreen)

            Text("Connect Screen Time")
                .font(.title.bold())

            Text(manager.statusMessage)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button {
                manager.requestAuthorization()
            } label: {
                Text(
                    manager.isAuthorized
                    ? "Choose Apps to Limit"
                    : "Enable Screen Time"
                )
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.movoGreen)
                .clipShape(Capsule())
            }

            if manager.isAuthorized {
                Text(
                    "\(manager.selection.applicationTokens.count) apps selected"
                )
                .font(.subheadline)
            }
        }
        .padding(24)
        .familyActivityPicker(
            isPresented: $manager.isPickerPresented,
            selection: $manager.selection
        )
    }
}
