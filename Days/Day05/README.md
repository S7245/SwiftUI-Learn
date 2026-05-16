# Day 05 - 列表、滚动与大量数据 UI

## 主题

列表、滚动与大量数据 UI

## 学习重点

- ScrollView
- LazyVStack
- ForEach
- Identifiable
- 稳定 identity
- 懒加载边界

## 项目实践

用 5,000 条模拟代理节点数据实现节点列表、状态分组、固定表头。这个练习面向 ProxyOps Studio 的核心运维场景：用户需要在大量代理节点中快速扫描在线状态、延迟、国家地区、失败率和最近探活时间，并能在滚动时持续知道当前分组和列表语义。

## 核心理解

Lazy 容器解决创建成本，但稳定身份和轻量行视图才决定滚动质量。`LazyVStack` 会延迟创建可见区域附近的子视图，但如果 `ForEach` 的 identity 不稳定，或者每一行在 `body` 中做昂贵计算，滚动仍然会抖动、状态会丢失，甚至出现错误动画。

## 参考源

- https://developer.apple.com/documentation/swiftui
- https://developer.apple.com/documentation/observation
- https://developer.apple.com/documentation/swiftui/navigationstack
- https://developer.apple.com/documentation/swiftui/layout
- https://developer.apple.com/documentation/swift/sendable

## 运行/迁移说明

1. 在 Xcode 中打开 SwiftUI App target。
2. 将 `Day05_large_data_list.swift` 拖入项目。
3. 预览 `Day05LargeDataListDemo`，滚动 5,000 条模拟节点，观察分组表头、搜索过滤和行视图是否保持稳定。
4. 迁移到正式项目时，可以把 `Day05ProxyNode`、`Day05NodeStatus` 放入模型层，把 `Day05ProxyNodeRow`、`Day05StatusSummaryHeader` 放入 Dashboard 组件层。
5. 如果后续接入真实网络数据，保持 `id` 来自服务端节点 ID，不要用数组下标或每次刷新生成的 UUID 作为 `ForEach` 身份。

## 今日代码观察点

- `Day05ProxyNode` 遵守 `Identifiable` 和 `Sendable`，使用稳定字符串作为 `id`。
- `Day05NodeStore` 一次性生成 5,000 条模拟数据，并在过滤时只派生轻量数组。
- `Day05LargeDataListDemo` 使用 `ScrollView` + `LazyVStack(pinnedViews: [.sectionHeaders])` 实现大量数据滚动和固定分组表头。
- `ForEach(group.nodes)` 依赖模型稳定 identity，避免滚动过程中行状态错位。
- `Day05ProxyNodeRow` 只接收一个值类型节点，不在行内生成大数组或执行复杂聚合。
- `Day05StatusSummaryHeader` 和 `Day05NodeSectionHeader` 把聚合信息放在列表边界之外，减少每一行的重复计算。
- 代码中的类型都以 `Day05` 开头，避免与其他天的练习文件发生命名冲突。
