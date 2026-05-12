import SwiftUI

// Day 01 intentionally keeps everything in one file for easy copying.
// In a real app, split these types into AppShell, Features, DesignSystem,
// and PreviewData folders.

struct Day01AppShellView: View {
    var body: some View {
        Day01DashboardHomeView(metrics: Day01PreviewData.metrics)
    }
}

struct Day01DashboardHomeView: View {
    let metrics: [Day01Metric]

    var body: some View {
        VStack(alignment: .leading, spacing: Day01Spacing.section) {
            Day01HeaderView()

            LazyVGrid(columns: Day01DashboardGrid.columns, spacing: Day01Spacing.card) {
                ForEach(metrics) { metric in
                    Day01MetricCard(metric: metric)
                }
            }

            Day01EmptyWorkbenchPanel()
        }
        .padding(Day01Spacing.page)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Day01Color.pageBackground)
    }
}

struct Day01HeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ProxyOps Studio")
                .font(.system(size: 34, weight: .bold, design: .rounded))

            Text("B2B data crawling and proxy monitoring workspace")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }
}

struct Day01MetricCard: View {
    let metric: Day01Metric

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: metric.symbolName)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(metric.tint)

                Spacer()

                Text(metric.trend)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(metric.trendColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(metric.title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(metric.value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .monospacedDigit()
            }
        }
        .padding(Day01Spacing.card)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(.quaternary, lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(metric.title), \(metric.value), \(metric.trend)")
    }
}

struct Day01EmptyWorkbenchPanel: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("Workspace Skeleton", systemImage: "rectangle.3.group")
                    .font(.headline)

                Spacer()

                Text("Day 01")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                Day01ChecklistRow(title: "App shell is the outer composition boundary")
                Day01ChecklistRow(title: "Dashboard page owns only layout description")
                Day01ChecklistRow(title: "Design tokens centralize visual constants")
                Day01ChecklistRow(title: "Preview data keeps UI work independent")
            }
        }
        .padding(Day01Spacing.card)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(.quaternary, lineWidth: 1)
        }
    }
}

struct Day01ChecklistRow: View {
    let title: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
    }
}

struct Day01Metric: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let trend: String
    let symbolName: String
    let tint: Color
    let trendColor: Color
}

enum Day01PreviewData {
    static let metrics: [Day01Metric] = [
        Day01Metric(
            title: "Active Proxy Nodes",
            value: "1,284",
            trend: "+12.5%",
            symbolName: "network",
            tint: .blue,
            trendColor: .green
        ),
        Day01Metric(
            title: "Average Latency",
            value: "84 ms",
            trend: "-8 ms",
            symbolName: "speedometer",
            tint: .orange,
            trendColor: .green
        ),
        Day01Metric(
            title: "Success Rate",
            value: "99.2%",
            trend: "+0.4%",
            symbolName: "checkmark.seal",
            tint: .green,
            trendColor: .green
        )
    ]
}

enum Day01DashboardGrid {
    static let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 220), spacing: Day01Spacing.card)
    ]
}

enum Day01Spacing {
    static let page: CGFloat = 24
    static let section: CGFloat = 24
    static let card: CGFloat = 16
}

enum Day01Color {
    static let pageBackground = Color(uiColor: .secondarySystemBackground)
}

#Preview("Day 01 App Shell") {
    Day01AppShellView()
}
