import SwiftUI

// Day 01 keeps the sample in one file so it can be copied into a fresh
// SwiftUI project. In a production project, split these types into AppShell,
// Features/Dashboard, DesignSystem, and PreviewData folders.

struct Day01AppShellView: View {
    var body: some View {
        Day01DashboardHomeView(snapshot: Day01PreviewData.dashboardSnapshot)
    }
}

struct Day01DashboardHomeView: View {
    let snapshot: Day01DashboardSnapshot

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Day01Spacing.section) {
                Day01HeaderView(snapshot: snapshot)
                Day01MetricGrid(metrics: snapshot.metrics)
                Day01WorkbenchSection(items: snapshot.workbenchItems)
            }
            .padding(Day01Spacing.page)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .background(Day01Palette.pageBackground)
    }
}

struct Day01HeaderView: View {
    let snapshot: Day01DashboardSnapshot

    var body: some View {
        HStack(alignment: .top, spacing: Day01Spacing.card) {
            VStack(alignment: .leading, spacing: 8) {
                Text(snapshot.productName)
                    .font(Day01Typography.hero)
                    .foregroundStyle(.primary)

                Text(snapshot.subtitle)
                    .font(Day01Typography.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: Day01Spacing.card)

            Day01BuildBadge(text: snapshot.buildLabel)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(snapshot.productName). \(snapshot.subtitle). \(snapshot.buildLabel).")
    }
}

struct Day01BuildBadge: View {
    let text: String

    var body: some View {
        Text(text)
            .font(Day01Typography.badge)
            .foregroundStyle(.blue)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.blue.opacity(0.12), in: Capsule())
            .overlay {
                Capsule()
                    .stroke(.blue.opacity(0.25), lineWidth: 1)
            }
    }
}

struct Day01MetricGrid: View {
    let metrics: [Day01Metric]

    var body: some View {
        LazyVGrid(columns: Day01DashboardGrid.columns, spacing: Day01Spacing.card) {
            ForEach(metrics) { metric in
                Day01MetricCard(metric: metric)
            }
        }
    }
}

struct Day01MetricCard: View {
    let metric: Day01Metric

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center) {
                Day01SymbolTile(systemName: metric.symbolName, tint: metric.tint)

                Spacer()

                Text(metric.trend)
                    .font(Day01Typography.badge)
                    .foregroundStyle(metric.trendColor)
                    .monospacedDigit()
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(metric.title)
                    .font(Day01Typography.caption)
                    .foregroundStyle(.secondary)

                Text(metric.value)
                    .font(Day01Typography.metric)
                    .foregroundStyle(.primary)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(metric.explanation)
                    .font(Day01Typography.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(Day01Spacing.card)
        .frame(maxWidth: .infinity, minHeight: 168, alignment: .topLeading)
        .background(.background, in: RoundedRectangle(cornerRadius: Day01Corner.card, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: Day01Corner.card, style: .continuous)
                .stroke(.quaternary, lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(metric.title), \(metric.value), \(metric.trend). \(metric.explanation)")
    }
}

struct Day01SymbolTile: View {
    let systemName: String
    let tint: Color

    var body: some View {
        Image(systemName: systemName)
            .font(.title3.weight(.semibold))
            .foregroundStyle(tint)
            .frame(width: 36, height: 36)
            .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct Day01WorkbenchSection: View {
    let items: [Day01WorkbenchItem]

    var body: some View {
        VStack(alignment: .leading, spacing: Day01Spacing.card) {
            HStack(alignment: .center) {
                Label("Workspace Skeleton", systemImage: "rectangle.3.group")
                    .font(Day01Typography.sectionTitle)

                Spacer()

                Text("Static preview data")
                    .font(Day01Typography.caption)
                    .foregroundStyle(.secondary)
            }

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                ForEach(items) { item in
                    Day01WorkbenchRow(item: item)
                }
            }
        }
        .padding(Day01Spacing.card)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background, in: RoundedRectangle(cornerRadius: Day01Corner.card, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: Day01Corner.card, style: .continuous)
                .stroke(.quaternary, lineWidth: 1)
        }
    }
}

struct Day01WorkbenchRow: View {
    let item: Day01WorkbenchItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: item.symbolName)
                .font(.body.weight(.semibold))
                .foregroundStyle(item.tint)
                .frame(width: 28, height: 28)
                .background(item.tint.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(Day01Typography.rowTitle)

                Text(item.detail)
                    .font(Day01Typography.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

struct Day01DashboardSnapshot {
    let productName: String
    let subtitle: String
    let buildLabel: String
    let metrics: [Day01Metric]
    let workbenchItems: [Day01WorkbenchItem]
}

struct Day01Metric: Identifiable {
    let id: String
    let title: String
    let value: String
    let trend: String
    let explanation: String
    let symbolName: String
    let tint: Color
    let trendColor: Color
}

struct Day01WorkbenchItem: Identifiable {
    let id: String
    let title: String
    let detail: String
    let symbolName: String
    let tint: Color
}

enum Day01PreviewData {
    static let dashboardSnapshot = Day01DashboardSnapshot(
        productName: "ProxyOps Studio",
        subtitle: "B2B data crawling and proxy monitoring workspace",
        buildLabel: "Day 01 skeleton",
        metrics: [
            Day01Metric(
                id: "active-nodes",
                title: "Active Proxy Nodes",
                value: "1,284",
                trend: "+12.5%",
                explanation: "Static preview value that will become live node state later.",
                symbolName: "network",
                tint: .blue,
                trendColor: .green
            ),
            Day01Metric(
                id: "latency",
                title: "Average Latency",
                value: "84 ms",
                trend: "-8 ms",
                explanation: "A placeholder for future high-frequency metrics.",
                symbolName: "speedometer",
                tint: .orange,
                trendColor: .green
            ),
            Day01Metric(
                id: "success-rate",
                title: "Success Rate",
                value: "99.2%",
                trend: "+0.4%",
                explanation: "A derived number that should not be stored twice later.",
                symbolName: "checkmark.seal",
                tint: .green,
                trendColor: .green
            )
        ],
        workbenchItems: [
            Day01WorkbenchItem(
                id: "app-shell",
                title: "AppShell is the composition boundary",
                detail: "The shell decides which feature appears at the root without owning heavy business work.",
                symbolName: "square.stack.3d.up",
                tint: .blue
            ),
            Day01WorkbenchItem(
                id: "dashboard",
                title: "Dashboard describes the current UI state",
                detail: "The page receives a snapshot and turns it into view hierarchy descriptions.",
                symbolName: "chart.bar.doc.horizontal",
                tint: .purple
            ),
            Day01WorkbenchItem(
                id: "design-system",
                title: "Design tokens prevent visual drift",
                detail: "Spacing, corner radius, typography, and colors are centralized from day one.",
                symbolName: "slider.horizontal.3",
                tint: .orange
            ),
            Day01WorkbenchItem(
                id: "preview-data",
                title: "Preview data keeps UI iteration independent",
                detail: "Static sample values let you build UI before wiring real networking or storage.",
                symbolName: "eye",
                tint: .green
            )
        ]
    )
}

enum Day01DashboardGrid {
    static let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 230), spacing: Day01Spacing.card, alignment: .top)
    ]
}

enum Day01Spacing {
    static let page: CGFloat = 24
    static let section: CGFloat = 24
    static let card: CGFloat = 16
}

enum Day01Corner {
    static let card: CGFloat = 8
}

enum Day01Palette {
    static let pageBackground = Color(uiColor: .secondarySystemBackground)
}

enum Day01Typography {
    static let hero = Font.system(size: 34, weight: .bold, design: .rounded)
    static let sectionTitle = Font.headline
    static let metric = Font.system(size: 30, weight: .bold, design: .rounded)
    static let rowTitle = Font.subheadline.weight(.semibold)
    static let body = Font.callout
    static let caption = Font.caption
    static let badge = Font.caption.weight(.semibold)
}

#Preview("Day 01 App Shell") {
    Day01AppShellView()
}

#Preview("Day 01 Narrow Width") {
    Day01AppShellView()
        .frame(width: 390)
}
