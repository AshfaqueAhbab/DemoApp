import SwiftUI
import Combine

struct HistoryEntry: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let detail: String
    let date: Date
    let deltaMinutes: Int   // positive = earned, negative = used

    var isPositive: Bool { deltaMinutes > 0 }
    var deltaText: String { "\(isPositive ? "+" : "-")\(abs(deltaMinutes)) min" }
    var subtitle: String { "\(date.formatted(date: .omitted, time: .shortened)) · \(detail)" }
}

/// Single source of truth for the minutes shown across every tab.
///
/// available = dailyAllowance + earnedToday - usedToday
///
/// Hooks for teammates:
///  - Timer / Screen Time: update `usedToday` as the user spends time in limited apps.
///  - Screen Time: read `availableMinutes` to decide when to shield apps.
///  - Workout flow: calls `logWorkout(_:)` when the rep goal is reached.
final class AppState: ObservableObject {
    @Published var dailyAllowance: Int = 30
    @Published var earnedToday: Int = 35
    @Published var usedToday: Int = 25
    @Published var history: [HistoryEntry] = AppState.seedHistory()

    var availableMinutes: Int { max(0, dailyAllowance + earnedToday - usedToday) }
    var totalBudget: Int { dailyAllowance + earnedToday }
    var remainingFraction: Double {
        totalBudget > 0 ? min(1, Double(availableMinutes) / Double(totalBudget)) : 0
    }

    /// Called when a workout is completed. Adds the reward and records it in history.
    func logWorkout(_ exercise: Exercise) {
        earnedToday += exercise.rewardMinutes
        history.insert(
            HistoryEntry(icon: exercise.icon,
                         title: exercise.displayName,
                         detail: "\(exercise.targetReps) reps",
                         date: Date(),
                         deltaMinutes: exercise.rewardMinutes),
            at: 0
        )
    }

    /// Hook for Timer / Screen Time: call when limited apps were used.
    func recordUsage(minutes: Int, source: String = "Social apps") {
        guard minutes > 0 else { return }
        usedToday += minutes
        history.insert(
            HistoryEntry(icon: "iphone", title: source, detail: "Screen time",
                         date: Date(), deltaMinutes: -minutes),
            at: 0
        )
    }

    /// Demo helper (Profile tab) so you can re-run the demo from scratch.
    func resetDemo() {
        dailyAllowance = 30
        earnedToday = 35
        usedToday = 25
        history = AppState.seedHistory()
    }

    // MARK: - Sample data (matches the seeded totals: earned 35, used 25)
    private static func time(_ hour: Int, _ minute: Int) -> Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) ?? Date()
    }

    private static func seedHistory() -> [HistoryEntry] {
        [
            HistoryEntry(icon: Exercise.pushUps.icon, title: "Push-ups", detail: "10 reps",
                         date: time(9, 12), deltaMinutes: 15),
            HistoryEntry(icon: "iphone", title: "Social apps", detail: "Screen time",
                         date: time(8, 40), deltaMinutes: -25),
            HistoryEntry(icon: Exercise.squats.icon, title: "Squats", detail: "20 reps",
                         date: time(8, 15), deltaMinutes: 10),
            HistoryEntry(icon: Exercise.abs.icon, title: "Abs", detail: "15 reps",
                         date: time(7, 50), deltaMinutes: 10)
        ]
    }
}
