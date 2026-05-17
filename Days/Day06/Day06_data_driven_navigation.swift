import SwiftUI
import Observation

struct Day06LearningNode: Identifiable, Hashable, Sendable {
    let id: UUID
    var title: String
    var summary: String
    var status: Day06NodeStatus

    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        status: Day06NodeStatus
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.status = status
    }
}

enum Day06NodeStatus: String, CaseIterable, Hashable, Sendable {
    case planned = "待学习"
    case active = "学习中"
    case reviewed = "已复盘"

    var tint: Color {
        switch self {
        case .planned:
            return .secondary
        case .active:
            return .blue
        case .reviewed:
            return .green
        }
    }
}

enum Day06Route: Hashable, Sendable {
    case nodeDetail(id: Day06LearningNode.ID)
    case settings
    case logs(filter: Day06LogFilter)
}

enum Day06LogFilter: String, CaseIterable, Hashable, Sendable {
    case all = "全部"
    case navigation = "导航"
    case restore = "恢复"
}

@Observable
final class Day06Router {
    var path = NavigationPath()
    private(set) var events: [String] = []

    func showNode(_ node: Day06LearningNode) {
        path.append(Day06Route.nodeDetail(id: node.id))
        record("打开节点详情：\(node.title)")
    }

    func showSettings() {
        path.append(Day06Route.settings)
        record("打开配置页")
    }

    func showLogs(filter: Day06LogFilter = .all) {
        path.append(Day06Route.logs(filter: filter))
        record("打开日志页：\(filter.rawValue)")
    }

    func replace(with routes: [Day06Route]) {
        path = NavigationPath(routes)
        record("用 \(routes.count) 个路由替换导航栈")
    }

    func reset() {
        path = NavigationPath()
        record("返回根页面")
    }

    func removeLast() {
        guard !path.isEmpty else { return }
        path.removeLast()
        record("移除最后一个路由")
    }

    private func record(_ message: String) {
        events.insert(message, at: 0)
    }
}

struct Day06DataDrivenNavigationView: View {
    @State private var router = Day06Router()
    private let nodes = Day06SampleData.nodes

    var body: some View {
        NavigationStack(path: $router.path) {
            Day06NodeListView(nodes: nodes, router: router)
                .navigationTitle("Day 06")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            router.showLogs(filter: .navigation)
                        } label: {
                            Label("日志", systemImage: "list.bullet.rectangle")
                        }

                        Button {
                            router.showSettings()
                        } label: {
                            Label("配置", systemImage: "slider.horizontal.3")
                        }
                    }
                }
                .navigationDestination(for: Day06Route.self) { route in
                    switch route {
                    case .nodeDetail(let id):
                        Day06NodeDetailView(
                            node: nodes.first { $0.id == id },
                            router: router
                        )
                    case .settings:
                        Day06SettingsView(router: router)
                    case .logs(let filter):
                        Day06LogView(filter: filter, router: router)
                    }
                }
        }
    }
}

struct Day06NodeListView: View {
    let nodes: [Day06LearningNode]
    let router: Day06Router

    var body: some View {
        List {
            Section("课程节点") {
                ForEach(nodes) { node in
                    Button {
                        router.showNode(node)
                    } label: {
                        Day06NodeRow(node: node)
                    }
                    .buttonStyle(.plain)
                }
            }

            Section("状态驱动操作") {
                Button("查看全部日志") {
                    router.showLogs()
                }

                Button("模拟深链：配置页 > 恢复日志") {
                    router.replace(with: [
                        .settings,
                        .logs(filter: .restore)
                    ])
                }
            }
        }
    }
}

struct Day06NodeRow: View {
    let node: Day06LearningNode

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(node.status.tint)
                .frame(width: 12, height: 12)

            VStack(alignment: .leading, spacing: 4) {
                Text(node.title)
                    .font(.headline)

                Text(node.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 6)
    }
}

struct Day06NodeDetailView: View {
    let node: Day06LearningNode?
    let router: Day06Router

    var body: some View {
        Group {
            if let node {
                List {
                    Section("节点") {
                        LabeledContent("标题", value: node.title)
                        LabeledContent("状态", value: node.status.rawValue)
                    }

                    Section("说明") {
                        Text(node.summary)
                    }

                    Section("继续动作") {
                        Button("查看该节点导航日志") {
                            router.showLogs(filter: .navigation)
                        }

                        Button("打开配置页") {
                            router.showSettings()
                        }
                    }
                }
                .navigationTitle(node.title)
            } else {
                ContentUnavailableView(
                    "节点不存在",
                    systemImage: "exclamationmark.triangle",
                    description: Text("路由状态中的节点 ID 没有匹配到当前数据源。")
                )
            }
        }
    }
}

struct Day06SettingsView: View {
    let router: Day06Router
    @State private var restoreLastPath = true
    @State private var logNavigation = true

    var body: some View {
        Form {
            Section("导航配置") {
                Toggle("恢复上次导航栈", isOn: $restoreLastPath)
                Toggle("记录导航事件", isOn: $logNavigation)
            }

            Section("调试") {
                Button("查看恢复日志") {
                    router.showLogs(filter: .restore)
                }

                Button("清空路径并回到根页面", role: .destructive) {
                    router.reset()
                }
            }
        }
        .navigationTitle("配置")
    }
}

struct Day06LogView: View {
    let filter: Day06LogFilter
    let router: Day06Router

    private var visibleEvents: [String] {
        switch filter {
        case .all:
            return router.events
        case .navigation:
            return router.events.filter { $0.contains("打开") }
        case .restore:
            return router.events.filter { $0.contains("恢复") || $0.contains("替换") }
        }
    }

    var body: some View {
        List {
            Picker("过滤", selection: .constant(filter)) {
                ForEach(Day06LogFilter.allCases, id: \.self) { item in
                    Text(item.rawValue).tag(item)
                }
            }
            .pickerStyle(.segmented)

            Section("事件") {
                if visibleEvents.isEmpty {
                    ContentUnavailableView(
                        "暂无日志",
                        systemImage: "tray",
                        description: Text("执行一次跳转后，这里会显示由 Router 记录的状态变化。")
                    )
                } else {
                    ForEach(visibleEvents, id: \.self) { event in
                        Text(event)
                    }
                }
            }
        }
        .navigationTitle("日志")
    }
}

enum Day06SampleData {
    static let nodes: [Day06LearningNode] = [
        Day06LearningNode(
            title: "NavigationStack",
            summary: "使用路径绑定描述栈结构，让 SwiftUI 根据状态呈现目标页面。",
            status: .active
        ),
        Day06LearningNode(
            title: "枚举路由",
            summary: "把页面类型和必要参数收敛到 Hashable 枚举中，降低字符串路由的错误率。",
            status: .planned
        ),
        Day06LearningNode(
            title: "路径恢复",
            summary: "用稳定的路由状态表达深链或恢复入口，而不是保存 View 实例。",
            status: .planned
        ),
        Day06LearningNode(
            title: "导航测试",
            summary: "断言 Router 的 path 变化，比点击后查找页面标题更接近业务意图。",
            status: .reviewed
        )
    ]
}

#Preview {
    Day06DataDrivenNavigationView()
}
