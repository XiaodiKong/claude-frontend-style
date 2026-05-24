# Claude Frontend Style

> Claude.com 的视觉设计语言 + 生产级前端工程规范，打包成可分享的 Claude Skill。

让你团队里所有 Claude 实例生成的前端代码都长得一样、写得一样规范——**自动触发、零配置、git 单一来源**。

---

## ✨ 这个 Skill 做了什么

**视觉层**：每次 Claude 写前端 UI，自动应用：
- 暖米色背景 `#F0EEE6` + 珊瑚橙强调 `#CC785C`
- 衬线标题（Fraunces）+ 关键词斜体强调（Claude.com 招牌特征）
- 5 种统一按钮形态、Ask Claude 风格输入框、卡片与网格

**工程层**：每次输出代码自动遵守：
- 重复样式 ≥3 次必须抽象 / 组件 ≤ 200 行
- 语义 HTML / 完整可访问性 / GPU 加速动画
- 移动优先 + 标准断点 / 状态就近 / 服务端数据走 React Query
- **30 项自检清单**

完整规则见 [`USAGE.md`](./USAGE.md) 和 [`references/`](./references/)。

---

## 🚀 快速安装

### Claude.ai（一键）

1. 下载本仓库的 [`claude-frontend-style.skill`](./claude-frontend-style.skill)
2. claude.ai → 任意 Project → Settings → Skills → Upload skill
3. 选择 `.skill` 文件，完成

### Claude Code（项目级）

```bash
mkdir -p .claude/skills
git submodule add https://github.com/XiaodiKong/claude-frontend-style.git .claude/skills/claude-frontend-style
git commit -m "Add Claude frontend style skill"
```

团队成员 `git pull` 后立即生效。

### Claude Code（全局）

```bash
git clone https://github.com/XiaodiKong/claude-frontend-style.git ~/.claude/skills/claude-frontend-style
```

任何项目下都会自动触发。

---

## ✅ 验证是否生效

在已装好 Skill 的环境发送：

> 帮我做一个 SaaS 产品的 landing page，包含 hero、3 个特性卡片、底部 CTA。

如果输出代码包含 `#F0EEE6` 背景 + Fraunces 字体 + 斜体强调标题 + 珊瑚橙 CTA——Skill 已生效。

更完整的测试 prompt 集见 [`USAGE.md` §2](./USAGE.md#2-推荐的测试-prompt-集)。

---

## 📁 仓库结构

```
claude-frontend-style/
├── SKILL.md                          ← Claude 实际读的入口文件
├── README.md                         ← 你正在看
├── USAGE.md                          ← 详细使用 / 测试 / 迭代指南
├── CHANGELOG.md                      ← 版本历史
├── LICENSE                           ← MIT
├── publish.sh                        ← 一键发布脚本
├── claude-frontend-style.skill       ← Claude.ai 可上传的打包文件
├── references/
│   ├── design-system.md              ← 完整视觉规范
│   └── development-standards.md      ← 完整工程规范（含反例）
└── assets/
    └── design-system-demo.html       ← 浏览器可打开的组件示例
```

---

## 🎯 设计原则

**视觉**：温暖、人文、像翻开一本设计精良的书——纸质米色底、衬线标题、唯一彩色点缀、大量留白。

**工程**：可读性 > 巧妙 ，可访问性是底线不是加分项 ，状态放在能用到它的最低层级 ，性能默认开启而不是事后优化。

---

## 🔧 自定义到你的品牌

需要换成团队品牌色 / 字体？只改 4 个文件即可：

```diff
- --accent: #CC785C;     /* SKILL.md, design-system.md, demo.html */
+ --accent: #你的品牌色;
```

详细步骤见 [`USAGE.md` §5](./USAGE.md#5-自定义到团队品牌)。

---

## 📖 文档导航

| 我想… | 看哪个文件 |
|---|---|
| 快速了解 + 安装 | 这份 README |
| 验证 Skill / 学习测试方法 / 排查问题 | [`USAGE.md`](./USAGE.md) |
| 看版本变更 | [`CHANGELOG.md`](./CHANGELOG.md) |
| 改设计 token（颜色字体等） | [`SKILL.md`](./SKILL.md) |
| 查视觉规范细节 | [`references/design-system.md`](./references/design-system.md) |
| 查工程规范细节 | [`references/development-standards.md`](./references/development-standards.md) |
| 看组件实际渲染 | 浏览器打开 [`assets/design-system-demo.html`](./assets/design-system-demo.html) |

---

## 🤝 贡献

发现 Claude 在某类问题上反复出错？欢迎提 PR：

1. 写一个能复现问题的测试 prompt
2. 在 `references/development-standards.md` 加反例 + 正例
3. （可选）在 `SKILL.md` 加强相应规则
4. PR 描述里贴上 Claude 改进前后的输出对比

---

## 📜 License

[MIT](./LICENSE) — 个人 / 商业 / 衍生作品自由使用，无任何限制。

---

## 🙏 致谢

- 设计语言提取自 [claude.com](https://claude.com) 的视觉系统
- Skill 格式遵循 [Anthropic Claude Skills](https://docs.claude.com) 规范
- 衬线字体使用免费替代 [Fraunces](https://fonts.google.com/specimen/Fraunces) (替代 Tiempos)
- 无衬线字体使用免费替代 [DM Sans](https://fonts.google.com/specimen/DM+Sans) (替代 Styrene)

