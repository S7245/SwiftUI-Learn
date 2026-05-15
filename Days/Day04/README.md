# Day 04 - 对齐、弹性与优先级

## 主题

对齐、弹性与优先级

## 学习重点

- alignment
- frame(maxWidth:)
- fixedSize
- layoutPriority
- 自定义 AlignmentGuide

## 项目实践

为 ProxyOps Studio 实现自适应 KPI 卡片区：窄屏单列、宽屏多列、文字不挤压。这个区域会承载代理池可用率、平均延迟、失败请求数、活跃会话数等关键指标，是后续 Dashboard 的核心信息密度区域。

## 核心理解

布局问题多数不是尺寸不对，而是轴向约束、理想尺寸和优先级没想清楚。SwiftUI 的父视图提出尺寸建议，子视图根据自身理想尺寸返回结果；`frame(maxWidth:)`、`fixedSize`、`layoutPriority` 和 alignment guide 都是在影响这个协商过程。

## 参考源

- https://developer.apple.com/documentation/swiftui
- https://developer.apple.com/documentation/observation
- https://developer.apple.com/documentation/swiftui/navigationstack
- https://developer.apple.com/documentation/swiftui/layout
- https://developer.apple.com/documentation/swift/sendable

## 运行/迁移说明

1. 在 Xcode 中打开 SwiftUI App target。
2. 将 `Day04_alignment_priority.swift` 拖入项目。
3. 预览 `Day04AdaptiveKPIDemo`，分别切换普通宽度和窄宽度 Preview，观察 KPI 卡片如何从多列变成单列。
4. 迁移到正式项目时，可以把 `Day04KPIRecord` 放入 Dashboard 模型层，把 `Day04KPICard`、`Day04KPIGrid` 放入组件层。
5. 如果接入远程数据，把 `Day04KPIStore` 替换为真实 Observable store，保持 UI 组件只接收值类型输入。

## 今日代码观察点

- `Day04KPIGrid` 使用 `LazyVGrid` 的 adaptive item，让容器宽度决定列数。
- `Day04KPICard` 对数值使用 `layoutPriority(2)`，让关键指标比辅助说明更晚被压缩。
- 长标题和说明使用 `fixedSize(horizontal: false, vertical: true)`，避免文本在垂直方向被截断。
- 卡片外层使用 `frame(maxWidth: .infinity, alignment: .leading)`，让每列填满可用宽度，但内容仍保持左对齐。
- `Day04MetricRow` 使用自定义 `HorizontalAlignment.day04ValueColumn`，让不同行的数值列按同一参考线对齐。
- 代码中的类型都以 `Day04` 开头，避免与其他天的练习文件发生命名冲突。
