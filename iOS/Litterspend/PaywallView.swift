import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: Theme.glyph)
                    .font(.system(size: 56))
                    .foregroundStyle(Theme.accent)
                Text("Litterspend Pro")
                    .font(Theme.titleFont)
                    .foregroundStyle(Theme.textPrimary)
                Text("Usage rate calculator predicting next purchase date")
                    .font(Theme.bodyFont)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Spacer().frame(height: 8)
                Button {
                    Task {
                        await purchases.purchase()
                        if purchases.isPurchased { dismiss() }
                    }
                } label: {
                    Text(purchases.product != nil ? "Upgrade — \(purchases.product!.displayPrice)" : "Upgrade")
                        .font(Theme.headlineFont)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                }
                .accessibilityIdentifier("purchaseButton")
                .padding(.horizontal, 24)

                Button("Restore Purchases") {
                    Task { await purchases.restore() }
                }
                .font(Theme.captionFont)
                .foregroundStyle(Theme.textSecondary)

                Button("Not Now") { dismiss() }
                    .accessibilityIdentifier("dismissPaywallButton")
                    .font(Theme.captionFont)
                    .foregroundStyle(Theme.textSecondary)
                    .padding(.top, 4)
            }
            .padding()
        }
        .task { await purchases.load() }
    }
}

#Preview {
    PaywallView().environmentObject(PurchaseManager())
}
