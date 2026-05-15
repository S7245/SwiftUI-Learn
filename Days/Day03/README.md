# Day 03 - 布局协商：从 Auto Layout 切换到 SwiftUI

## 主题

布局协商：从 Auto Layout 切换到 SwiftUI

## 学习重点

- Proposed Size
- ideal size
- required size
- HStack
- VStack
- ZStack
- Spacer
- padding
- frame

## 项目实践

搭建三栏工作台：侧边栏、顶部工具栏、主内容区。今天的目标不是做一个完整应用，而是把 ProxyOps Studio 的基本工作台骨架建立起来，并用它观察 SwiftUI 布局协商如何替代 Auto Layout 的约束思维。

## 核心理解

SwiftUI 布局是父视图提议，子视图选择，父视图再放置。你不是写“两个视图之间必须相距多少”的约束网络，而是在描述容器如何向下提出尺寸建议、子视图如何回应、容器最后如何摆放这些结果。

## 参考源

- https://developer.apple.com/documentation/swiftui
- https://developer.apple.com/documentation/observation
- https://developer.apple.com/documentation/swiftui/navigationstack
- https://developer.apple.com/documentation/swiftui/layout
- https://developer.apple.com/documentation/swift/sendable

## 运行/迁移说明

1. 在 Xcode 中打开 SwiftUI App target。
2. 将 `Day03_layout_negotiation.swift` 拖入项目。
3. 预览 `Day03WorkbenchDemo`，分别查看宽屏和窄屏状态。
4. 迁移到正式项目时，可以把 `Day03Sidebar`、`Day03TopToolbar`、`Day03MainContent` 拆入 `AppShell` 或 `DashboardHome` 模块。
5. 后续接入真实导航时，保留“外层决定区域，内层决定内容”的边界，不要让每个业务卡片直接控制工作台整体宽度。

## 今日代码观察点

- `Day03WorkbenchDemo` 使用 `NavigationStack` 承载三栏工作台，保留后续导航演进空间。
- `Day03WorkbenchShell` 通过 `HStack` 划分侧边栏和主区域，用 `VStack` 划分顶部工具栏与内容区。
- 侧边栏使用固定宽度，这是 required size 的教学样例。
- 主内容区使用 `frame(maxWidth: .infinity, maxHeight: .infinity)` 接受父视图剩余空间。
- `Spacer(minLength:)` 用于表达弹性区域，而不是硬编码空白。
- `Day03MetricTile` 用 `idealWidth` 和 `frame(maxWidth:)` 展示“理想尺寸”和“可扩展尺寸”的区别。
