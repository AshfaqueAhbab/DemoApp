import SwiftUI

/// Placeholder sheet for choosing limited and always-allowed apps.
/// TODO (Screen Time): replace the body with Apple's app picker once Screen Time access is set up.
struct ManageAppsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color.movoGreen)
            Text("Choose your apps")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.movoDark)
            Text("Pick which apps get locked, and which stay available no matter what.")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button("Done") { dismiss() }
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.movoDark)
                .clipShape(Capsule())
                .padding(.horizontal, 32)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.movoBackground.ignoresSafeArea())
        .presentationDetents([.medium])
    }
}
