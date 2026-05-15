import SwiftUI
import Observation

enum Day03WorkbenchSection: String, CaseIterable, Identifiable, Sendable {
    case dashboard = "Dashboard"
    case proxies = "Proxy Nodes"
    case jobs = "Scrape Jobs"
    case alerts = "Alerts"

    var id: String { rawValue }

    var symbolName: String {
        switch self {
        case .dashboard: return "rectangle.3.group.fill"
        case .proxies: return "network"
        case .jobs: return "tray.full.fill"
        case .alerts: return "bell.badge.fill"
        }
    }
}

struct Day03Metric: Identifiable, Sendable {
    let id = UUID()
    let title: String
    let value: String
    let detail: String
}

@Observable
final class Day03WorkbenchModel {
    var selectedSection: Day03WorkbenchSection = .dashboard
    var isSidebarExpanded = true

    let metrics: [Day03Metric] = [
        Day03Metric(title: "Healthy Nodes", value: "1,284", detail: "Ready for routing"),
        Day03Metric(title: "Average Latency", value: "142 ms", detail: "Across active pools"),
        Day03Metric(title: "Failed Jobs", value: "18", detail: "Needs triage today")
    ]
}

struct Day03WorkbenchDemo: View {
    @State private var model = Day03WorkbenchModel()

    var body: some View {
        NavigationStack {
            Day03WorkbenchShell(model: model)
                .navigationTitle("ProxyOps Studio")
        }
    }
}

struct Day03WorkbenchShell: View {
    @Bindable var model: Day03WorkbenchModel

    var body: some View {
        HStack(spacing: 0) {
            Day03Sidebar(
                selectedSection: $model.selectedSection,
                isExpanded: model.isSidebarExpanded
            )
            .frame(width: model.isSidebarExpanded ? 220 : 72)
            .background(.thinMaterial)

            Divider()

            VStack(spacing: 0) {
                Day03TopToolbar(
                    title: model.selectedSection.rawValue,
                    isSidebarExpanded: $model.isSidebarExpanded
                )

                Divider()

                Day03MainContent(
                    section: model.selectedSection,
                    metrics: model.metrics
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct Day03Sidebar: View {
    @Binding var selectedSection: Day03WorkbenchSection
    let isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(isExpanded ? "ProxyOps" : "PO")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: isExpanded ? .leading : .center)
                .padding(.horizontal, 14)
                .padding(.top, 16)
                .padding(.bottom, 8)

            ForEach(Day03WorkbenchSection.allCases) { section in
                Button {
                    selectedSection = section
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: section.symbolName)
                            .frame(width: 24, height: 24)

                        if isExpanded {
                            Text(section.rawValue)
                                .font(.subheadline.weight(.medium))
                                .lineLimit(1)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: isExpanded ? .leading : .center)
                    .background {
                        if selectedSection == section {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.tint.opacity(0.14))
                        }
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(selectedSection == section ? .tint : .secondary)
                .help(section.rawValue)
            }

            Spacer(minLength: 12)

            Day03SidebarFooter(isExpanded: isExpanded)
        }
        .padding(.horizontal, 8)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct Day03SidebarFooter: View {
    let isExpanded: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "shield.lefthalf.filled")
                .foregroundStyle(.green)

            if isExpanded {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Routing Guard")
                        .font(.caption.weight(.semibold))
                    Text("All policies active")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: isExpanded ? .leading : .center)
    }
}

struct Day03TopToolbar: View {
    let title: String
    @Binding var isSidebarExpanded: Bool

    var body: some View {
        HStack(spacing: 12) {
            Button {
                isSidebarExpanded.toggle()
            } label: {
                Image(systemName: isSidebarExpanded ? "sidebar.left" : "sidebar.right")
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
            .help("Toggle sidebar")

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text("Layout negotiation lab")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 16)

            Day03ToolbarSearch()

            Button {
            } label: {
                Image(systemName: "arrow.clockwise")
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
            .help("Refresh dashboard")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background)
    }
}

struct Day03ToolbarSearch: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            Text("Search proxy, region, job")
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 10)
        .frame(width: 240, height: 34, alignment: .leading)
        .background(.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
    }
}

struct Day03MainContent: View {
    let section: Day03WorkbenchSection
    let metrics: [Day03Metric]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Day03LayoutExplanation()

                HStack(alignment: .top, spacing: 14) {
                    ForEach(metrics) { metric in
                        Day03MetricTile(metric: metric)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Day03WorkArea(section: section)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}

struct Day03LayoutExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("父视图提议，子视图选择，父视图放置")
                .font(.title3.bold())

            Text("The shell proposes fixed width to the sidebar, flexible width to the workspace, and unlimited vertical space to the scroll content. Each child chooses an ideal or required size before the parent places it.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct Day03MetricTile: View {
    let metric: Day03Metric

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(metric.title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(metric.value)
                .font(.system(.title2, design: .rounded).weight(.bold))
                .monospacedDigit()

            Text(metric.detail)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(idealWidth: 180, maxWidth: .infinity, alignment: .leading)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary, lineWidth: 1)
        }
    }
}

struct Day03WorkArea: View {
    let section: Day03WorkbenchSection

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(.secondary.opacity(0.08))

            VStack(alignment: .leading, spacing: 12) {
                Text("\(section.rawValue) workspace")
                    .font(.headline)

                Text("ZStack provides a background plane, VStack controls vertical flow, HStack controls the three-column shell, padding creates local breathing room, and frame communicates how much space each region is willing to accept.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 12) {
                    Day03StatusPill(title: "Required", value: "Sidebar 220 pt")
                    Day03StatusPill(title: "Ideal", value: "Metric 180 pt")
                    Day03StatusPill(title: "Flexible", value: "Workspace infinity")
                }
            }
            .padding(18)
        }
        .frame(maxWidth: .infinity, minHeight: 220, alignment: .topLeading)
    }
}

struct Day03StatusPill: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.caption.monospacedDigit())
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview("Wide Workbench") {
    Day03WorkbenchDemo()
        .frame(width: 920, height: 620)
}

#Preview("Compact Workbench") {
    Day03WorkbenchDemo()
        .frame(width: 520, height: 620)
}
