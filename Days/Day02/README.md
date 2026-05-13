# Day 02 - View 组合与 Modifier 顺序

## 主题

View 组合与 Modifier 顺序

## 学习重点

- ViewBuilder
- 条件视图
- Group
- @ViewBuilder 函数
- modifier 链式顺序
- 提取子 View

## 项目实践

为 ProxyOps Studio 实现一组可复用的基础组件：`StatusBadge`、`MetricCard`、`SectionHeader`、`IconButton`。这些组件会在后续节点监控列表、KPI 工作台、详情页和配置面板中反复出现。

## 核心理解

Modifier 不是简单属性设置，而是不断包裹、转换视图描述。`.padding().background()` 和 `.background().padding()` 的结果不同，因为前者先扩大内容区域再绘制背景，后者先给原始内容绘制背景再扩大外部间距。

## 参考源

- https://developer.apple.com/documentation/swiftui
- https://developer.apple.com/documentation/observation
- https://developer.apple.com/documentation/swiftui/navigationstack
- https://developer.apple.com/documentation/swiftui/layout
- https://developer.apple.com/documentation/swift/sendable

## 运行/迁移说明

1. 在 Xcode 中新建或打开 SwiftUI App。
2. 将 `Day02_view_composition.swift` 拖入项目 target。
3. 打开 Preview，预览 `Day02DashboardCompositionDemo`。
4. 若迁移到正式项目，建议把本文件拆成 `StatusBadge.swift`、`MetricCard.swift`、`SectionHeader.swift`、`IconButton.swift` 和 `DashboardCompositionDemo.swift`。
5. 后续接入真实状态数据时，保持组件输入为值类型或简单参数，不要让基础组件直接读取全局状态。

## 今日代码观察点

- `Day02StatusBadge` 通过枚举状态决定颜色和文案，避免把状态样式散落到业务页面。
- `Day02MetricCard` 接收一个 `@ViewBuilder footer`，让卡片既有统一外框，又允许调用方替换底部区域。
- `Day02SectionHeader` 使用条件视图，只在存在 subtitle 或 action 时渲染对应区域。
- `Day02ModifierOrderStudy` 用两个相似文本直观看到 modifier 顺序差异。
- `Day02IconButton` 把图标按钮的尺寸、命中区域和可访问标签固定下来，避免每个页面手写不同风格。
