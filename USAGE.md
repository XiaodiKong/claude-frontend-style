# 使用指南

> 这份文档是 `README.md` 的补充——README 讲"怎么装"，USAGE 讲"怎么用好、怎么验证、怎么迭代"。

## 目录

1. [验证 Skill 是否生效](#1-验证-skill-是否生效)
2. [推荐的测试 Prompt 集](#2-推荐的测试-prompt-集)
3. [日常使用模式](#3-日常使用模式)
4. [团队协作与迭代](#4-团队协作与迭代)
5. [自定义到团队品牌](#5-自定义到团队品牌)
6. [常见问题排查](#6-常见问题排查)
7. [与其他工具配合](#7-与其他工具配合)

---

## 1. 验证 Skill 是否生效

安装后第一件事——**确认 Claude 真的用上了**。

### 烟雾测试 Prompt

在已安装该 Skill 的 Project / 仓库下，发送：

```
帮我做一个 SaaS 产品的 landing page，
包含 hero 区域（标题 + 副标题 + CTA）、3 个特性卡片、底部 CTA。
```

### 通过标准

观察 Claude 的输出代码：

| 信号 | 含义 | 通过条件 |
|---|---|---|
| 页面背景色 | Skill 是否生效 | 必须是 `#F0EEE6` 暖米色，不能是 `#fff` |
| 标题字体 | Skill 是否生效 | 必须引入 Fraunces（或 Tiempos 系列） |
| 斜体强调 | Claude.com 标志 | 标题里至少有一个词用 `italic-accent` |
| CTA 按钮 | 风格匹配 | 深色 `#1F1E1B` 或珊瑚橙 `#CC785C` |
| 语义标签 | 工程规范 | 用了 `<header>` `<main>` `<section>` |
| 图片属性 | 工程规范 | `<img>` 有 `alt` 和显式 `width`/`height` |
| 响应式 | 工程规范 | 用了 `sm:` / `md:` / `lg:` 标准断点 |

**6/7 以上通过 = Skill 正常工作**。

### 没生效怎么办

- 检查 Skill 是否真的装上了（Claude.ai → Project Settings → Skills 列表）
- 在 prompt 里显式提示：`请使用 claude-frontend-style skill`
- 检查 SKILL.md 的 `description` 字段是否被破坏（YAML 解析失败会导致 Skill 不可发现）

---

## 2. 推荐的测试 Prompt 集

每次升级 Skill 后跑一遍这组 prompt，能快速发现回归问题。

### 测试 1 — 视觉风格（Hero 页）
```
做一个 AI 助手产品的官网首页，要有英雄区、产品特性、客户证言、定价方案、页脚。
```
**关注**：是否完整用上 Claude.com 视觉语言。

### 测试 2 — 工程规范（仪表板）
```
做一个数据分析仪表板：左侧导航、顶部用户菜单、4 个数据卡片、1 个折线图区域、1 个数据表。
```
**关注**：组件拆分是否合理、语义 HTML、响应式断点、状态管理选择。

### 测试 3 — 可访问性（表单）
```
做一个注册表单：邮箱、密码、确认密码、用户协议勾选、提交按钮。要带验证错误提示。
```
**关注**：`<label>` 配对、`aria-*` 用法、错误提示不只用红色、`:focus-visible`。

### 测试 4 — 性能（图片密集页）
```
做一个旅行博客文章页：封面大图 + 5 个段落 + 每段配一张图 + 底部相关推荐 6 张卡片。
```
**关注**：所有 `<img>` 是否有 `alt` + `width/height` + `loading="lazy"`、`srcset` 处理。

### 测试 5 — 响应式（电商列表）
```
做一个商品列表页：顶部筛选栏 + 商品网格（手机 1 列、平板 2 列、桌面 4 列）。
```
**关注**：是否用 `repeat(auto-fit, minmax())` 而非堆三个媒体查询。

---

## 3. 日常使用模式

### 模式 A：直接交付（最常见）

```
你：做个 X 页面
Claude：[自动应用 skill，输出符合规范的代码]
```

最理想的状态——你不用提到 skill 的存在，Claude 自动用。

### 模式 B：显式强调（Skill 没自动触发时）

```
你：做个 X 页面，按 claude-frontend-style 的规范来
```

适用于 Claude 似乎没用上 skill 的情况。看 SKILL.md description 是否需要调整。

### 模式 C：部分覆盖（要稍微偏离风格）

```
你：用 claude-frontend-style 的工程标准做这个页面，
   但视觉上用深色模式（保留珊瑚橙作为强调色）
```

明确指出哪些保留、哪些修改。Claude 会优先满足你的具体指令。

### 模式 D：禁用（不需要这套风格）

```
你：忽略 claude-frontend-style，按苹果设计语言做
```

明确禁用，Claude 会用其他风格。

---

## 4. 团队协作与迭代

### 单一来源原则

**所有人都从 git 仓库取 Skill**，不要发邮件分发 `.skill` 文件——会出现版本碎片。

推荐：

- Claude Code 用户：直接 `git submodule` 或 `git subtree` 进项目
- Claude.ai 用户：每次仓库更新后重新下载 `.skill` 文件覆盖上传

### 谁来维护

建议指定 1-2 个"前端规范守护者"——他们负责：

- review 规则修改 PR
- 定期跑测试 Prompt 集，发现 Claude 输出退化时调查原因
- 决定新增规则 vs. 让现有规则更严格

### 改进流程

```
发现问题 → 写一条测试 prompt 能复现 → 改 SKILL.md / references → 跑测试集验证 → PR → review → merge → tag 新版本
```

最重要的是**测试 prompt 必须先写**——这样后续能验证规则修改是否真的起作用。

### 何时升 MINOR、何时升 MAJOR

- 新增一条规则（如"图标必须有 `aria-label`"）→ MINOR
- 改变设计 token（如换主色）→ MAJOR（团队代码会因此被建议重写）
- 调整 description 让触发更准 → PATCH

---

## 5. 自定义到团队品牌

### 改颜色（最常见）

**只改 4 个文件就够：**

1. `SKILL.md` 中 "Core visual identity" 段的 CSS 变量
2. `references/design-system.md` 中颜色表
3. `assets/design-system-demo.html` 中 `:root` 变量
4. `CHANGELOG.md` 加新版本记录

例：把品牌色从珊瑚橙改成绿色 `#2D7D6F`：

```diff
- --accent: #CC785C;
- --accent-hover: #B86848;
+ --accent: #2D7D6F;
+ --accent-hover: #1F5F54;
```

### 改字体

如果团队有付费字体（如 Söhne / Tiempos 正版），把 Google Fonts 加载行换成你的字体托管 URL：

```diff
- <link href="https://fonts.googleapis.com/css2?family=Fraunces..." rel="stylesheet">
+ <link href="https://fonts.team.com/sohne+tiempos.css" rel="stylesheet">
```

然后改 SKILL.md 中的 `--font-serif` 和 `--font-sans`。

### 添加团队特有规则

在 `references/development-standards.md` 第 10 章前加一节，比如：

```markdown
## 11. 团队特有规则

### 11.1 状态管理强制 Zustand
我们团队所有跨组件状态必须用 Zustand，不用 Redux/Jotai/Valtio。

### 11.2 表单必须用 react-hook-form
所有表单不允许手写 useState 管理字段。
```

然后在 SKILL.md 的"reading order"段加一句"对于状态和表单相关任务，重点阅读 §11"。

### 重新打包发布

修改完成后：

```bash
# 在仓库父目录运行
python -m scripts.package_skill claude-frontend-style/ ./
git add . && git commit -m "v1.1.0: change accent color to forest green"
git tag v1.1.0
git push && git push --tags
```

---

## 6. 常见问题排查

### Q1：Claude 输出的样式看起来"差不多但不对"

**症状**：色调相近但不是 `#F0EEE6`，字体相似但不是 Fraunces

**原因**：Skill 触发了但 Claude 在凭记忆"近似"应用

**解决**：在 prompt 末尾加 `请严格按 SKILL.md 中的 design tokens，不要近似`

### Q2：长页面前面合规、后面退化

**症状**：第一屏严格按规范，往下走开始出现硬编码颜色、缺 `alt`、丢失斜体强调

**原因**：长生成中 Claude 上下文权重稀释，规则强度下降

**解决**：
- 分段生成（先 hero、再特性区、再 CTA），每段单独问一次
- 或在每次请求前重申"提醒：使用 claude-frontend-style，含自检"

### Q3：Skill 没被自动触发

**症状**：明明问的是前端任务，输出却用了通用风格

**原因**：description 中没匹配到用户的措辞

**解决**：
- 临时方案：prompt 里显式写 "use claude-frontend-style skill"
- 永久方案：去 `SKILL.md` 的 description 加上用户用过的关键词

### Q4：代码量超长，比手写还啰嗦

**症状**：100 行能搞定的事 Claude 写了 400 行

**原因**：Claude 没读到 development-standards 中的"代码精简"规则

**解决**：在 prompt 加一句 `严格遵守 §1（代码精简，重复 ≥3 次必须抽象）`

### Q5：自检清单被忽略

**症状**：Claude 没在输出末尾做 30 项自检

**原因**：Claude 倾向于"假装完成"

**解决**：在 prompt 显式要求 `输出代码后必须完整列出第 10 节的自检清单结果，每项标 ✅ 或 ❌`

---

## 7. 与其他工具配合

### 配合 Claude Code 的 `/init` 或 CLAUDE.md

在项目根 `CLAUDE.md` 中加一句：

```markdown
## Frontend
所有前端代码必须遵循 .claude/skills/claude-frontend-style 中的规范。
```

这样即使 Skill 没自动触发，Claude 看 CLAUDE.md 时也会被提醒。

### 配合 ESLint / Prettier

Skill 管"生成时"的规范，ESLint 管"提交时"的检查。两者互补：

```json
// .eslintrc 可以加这些规则配合
{
  "rules": {
    "jsx-a11y/alt-text": "error",
    "jsx-a11y/anchor-is-valid": "error",
    "react/jsx-key": "error"
  }
}
```

Claude 生成的代码本来就应该过 ESLint——如果没过，记录下来作为反馈，下次升级 Skill 时强化对应规则。

### 配合设计稿

如果你有 Figma 设计稿，把设计稿截图和 prompt 一起发：

```
[附 Figma 截图]
按这张设计稿做实现，参考 claude-frontend-style 的代码标准（语义 HTML、可访问性、性能）。
视觉风格以截图为准，不按 Claude.com 风格。
```

明确告诉 Claude 哪部分听 Skill、哪部分听设计稿。

---

## 配套文档

- [`README.md`](./README.md) — 项目介绍与快速安装
- [`CHANGELOG.md`](./CHANGELOG.md) — 版本历史
- [`SKILL.md`](./SKILL.md) — Skill 入口（Claude 实际读的文件）
- [`references/design-system.md`](./references/design-system.md) — 视觉规范
- [`references/development-standards.md`](./references/development-standards.md) — 工程规范
- [`assets/design-system-demo.html`](./assets/design-system-demo.html) — 可视化示例
