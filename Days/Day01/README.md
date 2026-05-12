# Day 01 - SwiftUI 声明式 UI 与项目骨架

## 主题

SwiftUI 声明式 UI 与项目骨架。

今天的重点不是“画出一个漂亮首页”，而是把 SwiftUI 的第一层地基打稳：你写的 `View` 不是 UIKit 时代那种长期存活、可被你随时拿来改属性的 UI 对象，而是“在当前状态下，界面应该如何呈现”的值类型描述。系统会读取这些描述，结合状态变化、身份、布局规则和渲染管线，决定真实界面如何创建、更新和复用。

这一天会完成 `ProxyOps Studio` 的第一版静态骨架。它还没有真实网络、没有状态流、没有复杂导航，但它已经具备一个高级 SwiftUI 项目最重要的雏形：清晰的组合入口、明确的页面边界、集中管理的设计 token、可独立工作的 Preview 数据。

## 学习重点

1. 理解 `App`、`Scene`、`View`、`body`、`some View` 的职责边界。
2. 理解 SwiftUI 为什么强调声明式 UI：你描述状态对应的界面，而不是命令式地逐步修改控件。
3. 理解 `View` 是轻量值类型描述，不要把它当作稳定生命周期对象。
4. 理解 `body` 是 computed property，系统可以在需要时反复计算它。
5. 理解 `some View` 是不透明返回类型：调用者知道它符合 `View`，但不关心具体组合出的复杂泛型类型。
6. 建立最小但专业的项目分层：App、AppShell、Feature、DesignSystem、PreviewData。

## 项目实践

今天创建全新的 SwiftUI 项目 `ProxyOps Studio`，它是一个 B2B 数据抓取 / 代理节点监控工作台。第一天只做静态骨架，但骨架必须服务后续 50 天的演进。

正式项目建议目录：

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

本仓库中的 Day 示例为了避免每天类型重名，会把所有类型加上 `Day01` 前缀。迁移到真实项目时，可以去掉这些前缀，并按上面的目录拆分文件。

今日代码文件：

- `Day01_ProjectSkeleton.swift`

这个文件包含：

1. `Day01AppShellView`：应用级组合入口。
2. `Day01DashboardHomeView`：Dashboard 页面骨架。
3. `Day01HeaderView`：页面标题和产品定位。
4. `Day01MetricCard`：静态 KPI 卡片。
5. `Day01WorkbenchSection`：工作台主区域占位。
6. `Day01Metric` / `Day01WorkbenchItem`：Preview 用值模型。
7. `Day01PreviewData`：独立 Preview 数据。
8. `Day01Spacing` / `Day01Palette` / `Day01Typography`：最小设计系统。

## 核心理解

SwiftUI 官方文档把 `View` 定义为表示应用界面一部分的类型。更重要的是，View 的 `body` 提供的是内容和行为，而不是一个你手动管理生命周期的控件实例。这个差异会影响后面所有架构决策。

在 UIKit 里，你经常会这样思考：

```swift
let label = UILabel()
label.text = "ProxyOps Studio"
label.textColor = .label
view.addSubview(label)
```

这是一组命令：创建对象、修改属性、加入层级。你负责在合适时机继续更新这个对象。

在 SwiftUI 里，你应该这样思考：

```swift
Text("ProxyOps Studio")
    .font(.largeTitle.bold())
    .foregroundStyle(.primary)
```

这是一份描述：当状态走到这里，界面应该有一个文本，它长这样。系统会把描述变成真实界面，并在状态变化时重新计算必要部分。

所以 Day 1 最重要的结论是：

> View 可以频繁创建，状态和依赖不能随意创建；View 应该轻，模型和服务应该有明确所有权。

这也是为什么今天的示例代码只在 View 中组合 UI，不在 `body` 里做网络请求、数据库读取、文件扫描或复杂计算。真正的数据源和异步工作会在后续 Observation、并发和 Actor 阶段逐步接入。

## 参考源

- https://developer.apple.com/documentation/swiftui
- https://developer.apple.com/documentation/observation
- https://developer.apple.com/documentation/swiftui/navigationstack
- https://developer.apple.com/documentation/swiftui/layout
- https://developer.apple.com/documentation/swift/sendable

这些参考源今天不需要全部深入。Day 1 主要使用 SwiftUI、View、Scene、Layout 的基础概念；Observation、NavigationStack、Sendable 会在后续节点展开。现在提前放入参考源，是为了让你知道这门课不是孤立知识点堆砌，而是从第一天开始就对齐现代 SwiftUI 的完整工程体系。

## 今日目标

完成一个可运行、可预览、可继续演进的静态工作台骨架。

你今天不追求功能数量，而追求四个工程质量：

1. 入口清楚：应用最外层有 AppShell。
2. 页面清楚：Dashboard 是一个独立 Feature。
3. 视觉常量清楚：颜色、间距、字体不要散落在每个组件里。
4. Preview 清楚：没有真实后端也能预览界面。

## 知识展开

### 1. App 是程序入口，不是业务容器

SwiftUI 的 `App` 协议定义应用入口。它的 `body` 返回一个或多个 `Scene`。你可以把 `App` 理解为“应用如何被系统启动和组织窗口”的声明位置。

Day 1 不建议把业务状态、网络服务、数据库初始化全部塞进 `App`。真实项目里，`App` 可以创建顶层依赖，但要尽快交给明确的组合根，比如 `AppShellView` 或专门的 dependency container。

### 2. Scene 是界面生命周期容器

`Scene` 表示一组由系统管理生命周期的 UI。最常见的是 `WindowGroup`。它不是普通 View，而是告诉系统：“这个 App 可以拥有这样一组窗口，每个窗口显示这个根视图。”

今天只使用一个窗口场景。后续如果做 macOS 多窗口、设置窗口、文档窗口，Scene 的价值会更明显。

### 3. View 是描述，不是对象实例仓库

SwiftUI 的 `View` 通过 `body` 描述 UI。每个自定义 View 通常是一个 struct，这会自然提醒你：不要把它当作引用对象来保存长期副作用。

错误倾向：

```swift
struct DashboardView: View {
    let service = ExpensiveNetworkService()

    var body: some View {
        Text(service.currentStatus)
    }
}
```

这段代码的问题不是语法，而是所有权混乱。View 可能被重新创建，重型依赖不应该在这里随 View 生命周期漂移。

更合理的方向是：Day 1 只使用静态 Preview 数据；后续再用 `@State`、`@Observable`、Environment 和依赖注入来管理真实状态。

### 4. body 是计算属性，不是一次性构建函数

`body` 看起来像“创建 UI 的地方”，但它本质是 computed property。系统可以在状态变化、布局变化、环境变化时重新读取它。你应该让 `body` 保持轻量、可预测、无副作用。

适合放在 `body` 里的内容：

- View 组合。
- 简单条件分支。
- 轻量格式化。
- Modifier 链。

不适合放在 `body` 里的内容：

- 网络请求。
- 数据库 IO。
- 大型排序和过滤。
- 随机生成不稳定 identity。
- 修改外部状态。

### 5. some View 隐藏复杂类型，但不隐藏结构

SwiftUI 组合出来的类型非常复杂。比如一个 `VStack` 里嵌套 `Text`、`HStack`、`ForEach`、modifier 后，真实返回类型会变成很长的泛型组合。`some View` 让函数承诺“我返回某个具体但不暴露名称的 View 类型”。

这带来两个好处：

1. 调用方不需要知道复杂泛型类型。
2. 编译器仍然保留静态类型信息，可以优化和检查。

这也是为什么 SwiftUI 不推荐初学者一上来滥用 `AnyView`。`AnyView` 会抹掉类型信息，某些场景有价值，但不是 Day 1 的默认工具。

## 代码示例

在新建 SwiftUI App 后，你可以先把默认 `ContentView` 改成：

```swift
struct ContentView: View {
    var body: some View {
        Day01AppShellView()
    }
}
```

也可以在真实项目中让 App 直接显示 AppShell：

```swift
@main
struct ProxyOpsStudioApp: App {
    var body: some Scene {
        WindowGroup {
            AppShellView()
        }
    }
}
```

注意：本仓库的 Day 示例文件没有直接声明 `@main`，因为一个 Xcode App target 只能有一个入口。示例代码更适合作为学习模块复制进已有项目。

## 项目任务拆解

### 任务 1：建立应用骨架

在 Xcode 中新建 SwiftUI App，名称建议为 `ProxyOpsStudio`。确认能运行默认模板后，再替换根视图。

目标不是一次写完架构，而是先让项目拥有清晰入口：

```swift
struct AppShellView: View {
    var body: some View {
        DashboardHomeView()
    }
}
```

### 任务 2：创建 Dashboard 静态页面

Dashboard 页面暂时只接收静态 metrics。你要习惯把数据从外部传入 View，而不是在 View 内部临时创建一堆真实依赖。

```swift
struct DashboardHomeView: View {
    let metrics: [Metric]

    var body: some View {
        // 描述当前 metrics 对应的界面
    }
}
```

### 任务 3：建立最小设计系统

把间距、颜色、字体集中到小型 enum 中。今天不需要复杂 design token 系统，但要避免每个 View 都散落 `24`、`16`、`.blue`、`.largeTitle`。

这一步的价值不是“少写几个数字”，而是让后续几十天的界面演进有一致的视觉基础。

### 任务 4：建立 Preview 数据

Preview 数据应该和真实网络解耦。Day 1 的 `Day01PreviewData` 只是静态数组，但它会在后续发展成 Preview Matrix：空数据、错误状态、大字体、深色模式、高频刷新。

## 常见误区

1. 把 View 当成 ViewController，在里面保存复杂服务对象。
2. 认为 `body` 只执行一次，于是在里面做重计算。
3. 过早引入复杂 MVVM，把每个小组件都配一个 ViewModel。
4. 为了“灵活”滥用 `AnyView`，反而丢掉 SwiftUI 的类型优势。
5. Preview 只当截图工具，而不是开发反馈工具。
6. 一开始就追求完整业务功能，忽略项目骨架和状态边界。

## 自测问题

1. `App`、`Scene`、`View` 三者分别负责什么？
2. 为什么 SwiftUI 的 View 通常是 struct？
3. `body` 为什么必须保持轻量、无副作用？
4. `some View` 和 `AnyView` 的区别是什么？
5. 为什么今天不在 View 中创建真实网络服务？
6. 如果 `DashboardHomeView` 需要展示 3 个 KPI，数据应该从哪里来？
7. 为什么 PreviewData 是一个正式目录，而不是随便写在某个 View 文件底部？

## 验收标准

1. App 能运行，根界面显示 `ProxyOps Studio`。
2. `Day01AppShellView` 可以作为根视图独立预览。
3. Dashboard 至少包含标题区、KPI 卡片区、工作台占位区。
4. 项目中出现 AppShell、Feature、DesignSystem、PreviewData 四类边界。
5. `body` 中没有网络请求、数据库读取或重型计算。
6. 你能解释：SwiftUI 的 View 是值描述，而不是长期存活的 UI 控件实例。
7. 你能指出今天代码中哪些类型属于“界面描述”，哪些类型属于“静态输入数据”。

## 明日衔接

明天进入 View 组合与 Modifier 顺序。你会把今天的骨架继续拆成更细的组件，并重点理解 modifier 链不是“设置属性”，而是不断生成新的视图描述。尤其要观察 `.padding().background()` 和 `.background().padding()` 的结果为什么不同。
