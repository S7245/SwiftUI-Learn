# Day 06 - 数据驱动导航

## 主题

数据驱动导航

## 学习重点

- NavigationStack
- NavigationPath
- navigationDestination
- 枚举路由
- Hashable 路由状态

## 项目实践

建立 Route 和 Router，实现节点详情、配置页、日志页跳转。

## 核心理解

导航不是 push 一个页面，而是一段可观察、可恢复、可测试的状态。

## 参考源

- https://developer.apple.com/documentation/swiftui
- https://developer.apple.com/documentation/observation
- https://developer.apple.com/documentation/swiftui/navigationstack
- https://developer.apple.com/documentation/swiftui/layout
- https://developer.apple.com/documentation/swift/sendable

## 运行/迁移说明

将 `Day06_data_driven_navigation.swift` 加入一个 SwiftUI App target。示例依赖 SwiftUI 的
`NavigationStack`、`navigationDestination` 和 Observation 的 `@Observable` 宏，适合放在
iOS 17 或更新系统的学习工程中运行。如果项目仍需要兼容更早系统，可以把 `Day06Router`
改成 `ObservableObject`，将 `path` 标记为 `@Published`，并在视图中使用
`@StateObject` 或 `@ObservedObject` 注入。

示例刻意把路由设计成 `Hashable` 枚举，而不是让按钮直接创建目标页面。这样做的收益是：
页面跳转、深链恢复、测试断言和日志记录都围绕同一份状态展开。今天的重点不是让
`NavigationStack` 显示新页面，而是让导航变成可读、可控、可替换的数据模型。

建议练习：

1. 在节点详情页继续跳转到日志页，观察路径数组的变化。
2. 修改 `Day06Route`，增加一个 profile 或 help 路由。
3. 为 `Day06Router` 写单元测试，断言 `showNode`、`showSettings`、`reset` 的路径结果。
4. 尝试把 `codablePath` 存入本地状态，理解恢复导航栈时哪些数据必须稳定。

