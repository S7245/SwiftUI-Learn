# Day 01 - SwiftUI 声明式 UI 与项目骨架

## 主题

SwiftUI 声明式 UI 与项目骨架。

今天先不急着做复杂界面，而是建立正确心智模型：SwiftUI 的 `View` 是一份轻量的值类型描述，系统根据状态变化决定真实 UI 如何更新。

## 学习重点

1. 理解 `App`、`Scene`、`View`、`body`、`some View` 的职责边界。
2. 区分 SwiftUI 的声明式 UI 与 UIKit 的命令式 UI。
3. 理解 `View` 频繁创建是正常现象，不要把它当成稳定对象生命周期。
4. 建立项目的基础分层：应用入口、壳层、页面、设计系统、预览数据。

## 项目实践

今天的代码提供一个可复制进 Xcode 的静态首页骨架。

建议正式项目目录：

```text
ProxyOpsStudio/
  App/
    ProxyOpsStudioApp.swift
  AppShell/
    AppShellView.swift
  Features/
    Dashboard/
      DashboardHomeView.swift
  DesignSystem/
    AppColor.swift
    AppSpacing.swift
    AppTypography.swift
  PreviewData/
    PreviewNodes.swift
```

仓库中为了避免每天类型重名，所有类型都带 `Day01` 前缀。实际项目中可以去掉 Day 前缀，按正式目录拆分。

## 核心理解

SwiftUI 不是让你手动创建、保存、更新 UI 控件实例，而是让你描述“在当前状态下界面应该是什么样”。`body` 可以被系统反复计算，`View` 结构体可以被频繁创建；真正需要稳定存在的是状态、数据模型和依赖，而不是 View 本身。

## 今日代码

- `Day01_ProjectSkeleton.swift`

## 迁移到 Xcode

1. 新建 SwiftUI App 项目。
2. 将 `Day01_ProjectSkeleton.swift` 复制进项目。
3. 在默认 `ContentView` 中使用：

```swift
Day01AppShellView()
```

4. 运行 Preview，观察首页骨架。

## 自测问题

1. 为什么 SwiftUI 的 `View` 通常是 struct？
2. `body` 为什么可以被频繁计算？
3. `some View` 的作用是什么？
4. 为什么今天的代码没有把业务服务对象放在 View 的 `init` 中？

## 验收标准

1. 项目能成功运行。
2. 首页能在 Xcode Preview 中渲染。
3. 代码里已经出现 AppShell、Dashboard、DesignSystem、PreviewData 的基本分层思想。
4. 你能用自己的话解释：SwiftUI 的 View 是界面描述，而不是长期存活的 UI 实例。
