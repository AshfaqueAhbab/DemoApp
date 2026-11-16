
import SwiftUI
import Combine

@MainActor
final class EarnedTimeManager: ObservableObject {

    static let shared = EarnedTimeManager()

    @Published private(set) var remainingSeconds = 0

    private let storageKey = "movoEarnedTimeExpiration"
    private var endDate: Date?

    private init() {
        endDate = UserDefaults.standard.object(
            forKey: storageKey
        ) as? Date

        refresh()
    }

    // MARK: - Add Earned Time

    func addTime(minutes: Int) {
        guard minutes > 0 else { return }

        let now = Date()
        let startingDate = max(endDate ?? now, now)

        endDate = startingDate.addingTimeInterval(
            TimeInterval(minutes * 60)
        )

        UserDefaults.standard.set(
            endDate,
            forKey: storageKey
        )

        refresh()
    }

    // MARK: - Update Countdown

    func refresh() {
        guard let endDate = endDate else {
            remainingSeconds = 0
            return
        }

        let remaining = endDate.timeIntervalSinceNow

        if remaining <= 0 {
            remainingSeconds = 0
            self.endDate = nil

            UserDefaults.standard.removeObject(
                forKey: storageKey
            )
        } else {
            remainingSeconds = Int(ceil(remaining))
        }
    }

    // MARK: - Status

    var isUnlocked: Bool {
        remainingSeconds > 0
    }

    var formattedTime: String {
        let hours = remainingSeconds / 3600
        let minutes = (remainingSeconds % 3600) / 60
        let seconds = remainingSeconds % 60

        if hours > 0 {
            return String(
                format: "%02d:%02d:%02d",
                hours, minutes, seconds
            )
        }

        return String(
            format: "%02d:%02d",
            minutes, seconds
        )
    }
}

// MARK: - Countdown Display

struct EarnedTimeStatusView: View {

    @StateObject private var manager = EarnedTimeManager.shared

    private let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {
        VStack(spacing: 16) {

            Image(
                systemName: manager.isUnlocked
                ? "lock.open.fill"
                : "lock.fill"
            )
            .font(.system(size: 40))
            .foregroundStyle(Color.movoGreen)

            Text(
                manager.isUnlocked
                ? "Scroll Time Unlocked"
                : "No Scroll Time Available"
            )
            .font(.title2.bold())

            Text(manager.formattedTime)
                .font(
                    .system(
                        size: 48,
                        weight: .heavy,
                        design: .rounded
                    )
                )
                .monospacedDigit()

            Text(
                manager.isUnlocked
                ? "Time remaining"
                : "Complete a workout to earn time"
            )
            .foregroundStyle(.secondary)

            Text(
                "Demo countdown only. Instagram is not yet blocked by Screen Time."
            )
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .onReceive(timer) { _ in
            manager.refresh()
        }
        .onAppear {
            manager.refresh()
        }
    }
}
