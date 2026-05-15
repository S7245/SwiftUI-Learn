import SwiftUI
import Observation

enum Day04KPIKind: String, CaseIterable, Identifiable, Sendable {
    case availability
    case latency
    case failureRate
    case activeSessions

    var id: String { rawValue }

    var title: String {
        switch self {
        case .availability: return "Proxy Availability"
        case .latency: return "Average Latency"
        case .failureRate: return "Failed Requests"
        case .activeSessions: return "Active Sessions"
        }
    }

    var symbolName: String {
        switch self {
        case .availability: return "checkmark.seal.fill"
        case .latency: return "speedometer"
        case .failureRate: return "exclamationmark.triangle.fill"
        case .activeSessions: return "person.2.wave.2.fill"
        }
    }

    var tint: Color {
        switch self {
        case .availability: return .green
        case .latency: return .blue
        case .failureRate: return .orange
        case .activeSessions: return .purple
        }
    }
}

struct Day04KPIRecord: Identifiable, Sendable {
    let id = UUID()
    let kind: Day04KPIKind
    let value: String
    let unit: String
    let detail: String
    let trend: String
    let target: String
}

@Observable
final class Day04KPIStore {
    var records: [Day04KPIRecord] = [
        Day04KPIRecord(
            kind: .availability,
            value: "99.92",
            unit: "%",
            detail: "Residential pool kept enough healthy exits during the last hour.",
            trend: "+0.18% vs yesterday",
            target: "SLO 99.5%"
        ),
        Day04KPIRecord(
            kind: .latency,
            value: "148",
            unit: "ms",
            detail: "Weighted by successful requests across APAC and US regions.",
            trend: "-12 ms after routing change",
            target: "Target < 180 ms"
        ),
        Day04KPIRecord(
            kind: .failureRate,
            value: "0.41",
            unit: "%",
            detail: "Timeouts are concentrated in one datacenter provider.",
            trend: "+0.07% needs review",
            target: "Alert > 1%"
        ),
        Day04KPIRecord(
            kind: .activeSessions,
            value: "18.4K",
            unit: "",
            detail: "Concurrent scrape sessions using monitored proxy nodes.",
            trend: "+2.1K during peak crawl",
            target: "Capacity 25K"
        )
    ]
}

private enum Day04ValueColumnAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context[.leading]
    }
}

extension HorizontalAlignment {
    static let day04ValueColumn = HorizontalAlignment(Day04ValueColumnAlignment.self)
}

struct Day04AdaptiveKPIDemo: View {
    @State private var store = Day04KPIStore()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Day04DashboardHeader()

                    Day04KPIGrid(records: store.records)

                    Day04MetricComparison(records: store.records)
                }
                .padding(20)
            }
            .navigationTitle("ProxyOps Studio")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        store.records.shuffle()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }
                    .help("Shuffle KPI cards")
                }
            }
        }
    }
}

struct Day04DashboardHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Operations Dashboard")
                .font(.title.bold())
                .fixedSize(horizontal: false, vertical: true)

            Text("KPI cards stay readable because important values receive priority, long explanations can grow vertically, and each card fills the grid column without forcing its text to stretch.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct Day04KPIGrid: View {
    let records: [Day04KPIRecord]

    private var columns: [GridItem] {
        [
            GridItem(
                .adaptive(minimum: 220, maximum: 320),
                spacing: 14,
                alignment: .topLeading
            )
        ]
    }

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 14) {
            ForEach(records) { record in
                Day04KPICard(record: record)
            }
        }
    }
}

struct Day04KPICard: View {
    let record: Day04KPIRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Image(systemName: record.kind.symbolName)
                    .foregroundStyle(record.kind.tint)
                    .font(.system(size: 17, weight: .semibold))
                    .frame(width: 28, height: 28)
                    .background(record.kind.tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

                Text(record.kind.title)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(1)

                Spacer(minLength: 8)
            }

            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(record.value)
                    .font(.system(.largeTitle, design: .rounded).weight(.bold))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                    .layoutPriority(2)

                if !record.unit.isEmpty {
                    Text(record.unit)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .layoutPriority(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(record.detail)
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text(record.trend)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(record.kind.tint)
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(1)

                Spacer(minLength: 8)

                Text(record.target)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 210, alignment: .topLeading)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(record.kind.tint.opacity(0.22), lineWidth: 1)
        }
    }
}

struct Day04MetricComparison: View {
    let records: [Day04KPIRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Aligned review rows")
                .font(.headline)

            VStack(alignment: .day04ValueColumn, spacing: 10) {
                ForEach(records) { record in
                    Day04MetricRow(record: record)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct Day04MetricRow: View {
    let record: Day04KPIRecord

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(record.kind.title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .frame(width: 150, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)

            Text(record.valueWithUnit)
                .font(.body.monospacedDigit().weight(.semibold))
                .alignmentGuide(.day04ValueColumn) { dimensions in
                    dimensions[.leading]
                }
                .layoutPriority(2)

            Text(record.target)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension Day04KPIRecord {
    var valueWithUnit: String {
        unit.isEmpty ? value : "\(value) \(unit)"
    }
}

#Preview("Regular Width") {
    Day04AdaptiveKPIDemo()
        .frame(width: 760, height: 720)
}

#Preview("Narrow Width") {
    Day04AdaptiveKPIDemo()
        .frame(width: 340, height: 720)
}
