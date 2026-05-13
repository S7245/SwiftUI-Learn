import SwiftUI

enum Day02ProxyStatus: String, CaseIterable, Identifiable {
    case healthy
    case warning
    case failed
    case unknown

    var id: String { rawValue }

    var title: String {
        switch self {
        case .healthy: return "Healthy"
        case .warning: return "Warning"
        case .failed: return "Failed"
        case .unknown: return "Unknown"
        }
    }

    var symbolName: String {
        switch self {
        case .healthy: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .failed: return "xmark.octagon.fill"
        case .unknown: return "questionmark.circle.fill"
        }
    }

    var tint: Color {
        switch self {
        case .healthy: return .green
        case .warning: return .orange
        case .failed: return .red
        case .unknown: return .secondary
        }
    }
}

struct Day02StatusBadge: View {
    let status: Day02ProxyStatus
    var isCompact = false

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: status.symbolName)
                .imageScale(.small)

            if !isCompact {
                Text(status.title)
                    .font(.caption.weight(.semibold))
            }
        }
        .foregroundStyle(status.tint)
        .padding(.horizontal, isCompact ? 7 : 10)
        .padding(.vertical, 5)
        .background(status.tint.opacity(0.12), in: Capsule())
        .overlay {
            Capsule()
                .stroke(status.tint.opacity(0.22), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Proxy status \(status.title)")
    }
}

struct Day02MetricCard<Footer: View>: View {
    let title: String
    let value: String
    let trend: String
    let status: Day02ProxyStatus
    @ViewBuilder var footer: Footer

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Day02SectionHeader(title: title, subtitle: trend) {
                Day02StatusBadge(status: status, isCompact: true)
            }

            Text(value)
                .font(.system(.largeTitle, design: .rounded).weight(.bold))
                .monospacedDigit()
                .contentTransition(.numericText())

            footer
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary, lineWidth: 1)
        }
    }
}

struct Day02SectionHeader<Action: View>: View {
    let title: String
    var subtitle: String?
    @ViewBuilder var action: Action

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)

                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 12)

            action
        }
    }
}

struct Day02IconButton: View {
    let systemName: String
    let label: String
    var role: ButtonRole?
    var action: () -> Void = {}

    var body: some View {
        Button(role: role, action: action) {
            Image(systemName: systemName)
                .font(.system(size: 15, weight: .semibold))
                .frame(width: 34, height: 34)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary, lineWidth: 1)
        }
        .accessibilityLabel(label)
        .help(label)
    }
}

struct Day02ProxyRow: View {
    let name: String
    let region: String
    let latency: Int
    let status: Day02ProxyStatus

    var body: some View {
        HStack(spacing: 12) {
            Day02StatusBadge(status: status, isCompact: true)

            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(.subheadline.weight(.semibold))
                Text(region)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(latency) ms")
                .font(.callout.monospacedDigit())
                .foregroundStyle(latency > 220 ? .orange : .secondary)

            Day02IconButton(systemName: "slider.horizontal.3", label: "Configure \(name)")
        }
        .padding(.vertical, 9)
    }
}

struct Day02ModifierOrderStudy: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("padding before background")
                .padding(10)
                .background(.blue.opacity(0.16), in: RoundedRectangle(cornerRadius: 8))

            Text("background before padding")
                .background(.blue.opacity(0.16), in: RoundedRectangle(cornerRadius: 8))
                .padding(10)
        }
        .font(.caption.weight(.medium))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct Day02DashboardCompositionDemo: View {
    private let rows: [(String, String, Int, Day02ProxyStatus)] = [
        ("sg-residential-01", "Singapore / Residential", 92, .healthy),
        ("jp-mobile-12", "Tokyo / Mobile", 188, .warning),
        ("us-dc-07", "Virginia / Datacenter", 241, .failed)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    metricGrid

                    Group {
                        Day02SectionHeader(title: "Proxy Nodes", subtitle: "Composable rows with stable inputs") {
                            Day02IconButton(systemName: "arrow.clockwise", label: "Refresh nodes")
                        }

                        VStack(spacing: 0) {
                            ForEach(rows, id: \.0) { row in
                                Day02ProxyRow(name: row.0, region: row.1, latency: row.2, status: row.3)

                                if row.0 != rows.last?.0 {
                                    Divider()
                                }
                            }
                        }
                        .padding(.horizontal, 14)
                        .background(.background, in: RoundedRectangle(cornerRadius: 8))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.quaternary, lineWidth: 1)
                        }
                    }

                    Day02ModifierOrderStudy()
                }
                .padding(20)
            }
            .navigationTitle("ProxyOps Studio")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Day02IconButton(systemName: "line.3.horizontal.decrease.circle", label: "Open filters")
                    Day02IconButton(systemName: "plus", label: "Add proxy")
                }
            }
        }
    }

    @ViewBuilder
    private var metricGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 220), spacing: 12)], spacing: 12) {
            Day02MetricCard(title: "Available Nodes", value: "4,812", trend: "+128 today", status: .healthy) {
                Text("Footer is injected by the caller with @ViewBuilder.")
            }

            Day02MetricCard(title: "Median Latency", value: "126 ms", trend: "p50 across active nodes", status: .warning) {
                HStack {
                    Text("Socks5")
                    Spacer()
                    Text("HTTP")
                }
            }
        }
    }
}

struct Day02DashboardCompositionDemo_Previews: PreviewProvider {
    static var previews: some View {
        Day02DashboardCompositionDemo()
    }
}
