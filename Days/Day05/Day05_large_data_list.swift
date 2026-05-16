import SwiftUI
import Observation

enum Day05NodeStatus: String, CaseIterable, Identifiable, Sendable {
    case healthy
    case warning
    case offline

    var id: String { rawValue }

    var title: String {
        switch self {
        case .healthy: return "Healthy"
        case .warning: return "Warning"
        case .offline: return "Offline"
        }
    }

    var symbolName: String {
        switch self {
        case .healthy: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .offline: return "xmark.octagon.fill"
        }
    }

    var tint: Color {
        switch self {
        case .healthy: return .green
        case .warning: return .orange
        case .offline: return .red
        }
    }
}

struct Day05ProxyNode: Identifiable, Sendable {
    let id: String
    let name: String
    let region: String
    let provider: String
    let status: Day05NodeStatus
    let latencyMS: Int
    let failureRate: Double
    let activeSessions: Int
    let lastProbeMinutesAgo: Int
}

struct Day05NodeGroup: Identifiable, Sendable {
    let status: Day05NodeStatus
    let nodes: [Day05ProxyNode]

    var id: Day05NodeStatus { status }
}

@Observable
final class Day05NodeStore {
    var searchText = ""
    var selectedStatus: Day05NodeStatus?
    private(set) var nodes: [Day05ProxyNode] = Day05NodeFactory.makeNodes(count: 5_000)

    var visibleNodes: [Day05ProxyNode] {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        return nodes.filter { node in
            let matchesStatus = selectedStatus.map { node.status == $0 } ?? true
            let matchesSearch = trimmedSearch.isEmpty
                || node.name.localizedCaseInsensitiveContains(trimmedSearch)
                || node.region.localizedCaseInsensitiveContains(trimmedSearch)
                || node.provider.localizedCaseInsensitiveContains(trimmedSearch)
            return matchesStatus && matchesSearch
        }
    }

    var groupedNodes: [Day05NodeGroup] {
        Day05NodeStatus.allCases.compactMap { status in
            let nodesForStatus = visibleNodes.filter { $0.status == status }
            return nodesForStatus.isEmpty ? nil : Day05NodeGroup(status: status, nodes: nodesForStatus)
        }
    }

    var totalCount: Int { nodes.count }

    func shuffleLatency() {
        nodes = nodes.map { node in
            Day05ProxyNode(
                id: node.id,
                name: node.name,
                region: node.region,
                provider: node.provider,
                status: node.status,
                latencyMS: max(35, node.latencyMS + Int.random(in: -18...24)),
                failureRate: node.failureRate,
                activeSessions: node.activeSessions,
                lastProbeMinutesAgo: Int.random(in: 0...14)
            )
        }
    }
}

enum Day05NodeFactory {
    static func makeNodes(count: Int) -> [Day05ProxyNode] {
        let regions = ["Tokyo", "Singapore", "Frankfurt", "Dallas", "Sao Paulo", "Sydney", "London", "Mumbai"]
        let providers = ["AsterNet", "BrightRoute", "CoreProxy", "DeltaEdge"]

        return (0..<count).map { index in
            let status: Day05NodeStatus
            switch index % 10 {
            case 0: status = .offline
            case 1, 2: status = .warning
            default: status = .healthy
            }

            return Day05ProxyNode(
                id: "proxy-\(String(format: "%05d", index))",
                name: "proxy-\(String(format: "%05d", index))",
                region: regions[index % regions.count],
                provider: providers[index % providers.count],
                status: status,
                latencyMS: 48 + (index * 13) % 260,
                failureRate: Double((index * 7) % 95) / 100,
                activeSessions: 12 + (index * 19) % 940,
                lastProbeMinutesAgo: index % 15
            )
        }
    }
}

struct Day05LargeDataListDemo: View {
    @State private var store = Day05NodeStore()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Day05StatusSummaryHeader(nodes: store.visibleNodes, totalCount: store.totalCount)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                Day05StatusFilterBar(selection: $store.selectedStatus)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                        ForEach(store.groupedNodes) { group in
                            Section {
                                ForEach(group.nodes) { node in
                                    Day05ProxyNodeRow(node: node)
                                        .padding(.horizontal, 16)
                                }
                            } header: {
                                Day05NodeSectionHeader(group: group)
                            }
                        }
                    }
                }
                .searchable(text: $store.searchText, prompt: "Filter by node, region, or provider")
            }
            .navigationTitle("Proxy Nodes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        store.shuffleLatency()
                    } label: {
                        Image(systemName: "waveform.path.ecg")
                    }
                    .help("Simulate latency refresh")
                }
            }
        }
    }
}

struct Day05StatusSummaryHeader: View {
    let nodes: [Day05ProxyNode]
    let totalCount: Int

    var body: some View {
        HStack(spacing: 12) {
            Day05SummaryMetric(title: "Visible", value: nodes.count.formatted())
            Day05SummaryMetric(title: "Total", value: totalCount.formatted())
            Day05SummaryMetric(title: "Average", value: "\(averageLatency) ms")
        }
    }

    private var averageLatency: Int {
        guard !nodes.isEmpty else { return 0 }
        let total = nodes.reduce(0) { $0 + $1.latencyMS }
        return total / nodes.count
    }
}

struct Day05SummaryMetric: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.headline.monospacedDigit())
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

struct Day05StatusFilterBar: View {
    @Binding var selection: Day05NodeStatus?

    var body: some View {
        HStack(spacing: 8) {
            Day05StatusChip(title: "All", tint: .blue, isSelected: selection == nil) {
                selection = nil
            }

            ForEach(Day05NodeStatus.allCases) { status in
                Day05StatusChip(title: status.title, tint: status.tint, isSelected: selection == status) {
                    selection = status
                }
            }
        }
    }
}

struct Day05StatusChip: View {
    let title: String
    let tint: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .frame(minWidth: 56)
        }
        .buttonStyle(.plain)
        .foregroundStyle(isSelected ? .white : tint)
        .background(isSelected ? tint : tint.opacity(0.12), in: Capsule())
    }
}

struct Day05NodeSectionHeader: View {
    let group: Day05NodeGroup

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: group.status.symbolName)
                .foregroundStyle(group.status.tint)

            Text(group.status.title)
                .font(.subheadline.weight(.semibold))

            Spacer()

            Text("\(group.nodes.count.formatted()) nodes")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 9)
        .background(.background)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}

struct Day05ProxyNodeRow: View {
    let node: Day05ProxyNode

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Image(systemName: node.status.symbolName)
                .foregroundStyle(node.status.tint)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 4) {
                Text(node.name)
                    .font(.body.weight(.semibold))

                Text("\(node.provider) - \(node.region)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .layoutPriority(1)

            Spacer(minLength: 10)

            Day05NodeStat(value: "\(node.latencyMS)", unit: "ms")
            Day05NodeStat(value: node.failureRate.formatted(.number.precision(.fractionLength(2))), unit: "%")
            Day05NodeStat(value: "\(node.activeSessions)", unit: "sessions")

            Text("\(node.lastProbeMinutesAgo)m")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
                .frame(width: 38, alignment: .trailing)
        }
        .padding(.vertical, 10)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}

struct Day05NodeStat: View {
    let value: String
    let unit: String

    var body: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(value)
                .font(.subheadline.monospacedDigit().weight(.semibold))
                .lineLimit(1)

            Text(unit)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(width: 68, alignment: .trailing)
    }
}

#Preview("Large Data List") {
    Day05LargeDataListDemo()
        .frame(width: 860, height: 760)
}

#Preview("Compact") {
    Day05LargeDataListDemo()
        .frame(width: 390, height: 760)
}
