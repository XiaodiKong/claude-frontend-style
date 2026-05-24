# Claude 风格设计规范（AI 提示词版）

> 把这份文档贴到任何前端生成 AI 的对话里，让它按 Claude.com 官网的视觉风格构建界面。整体气质：**温暖、人文、像翻开一本设计精良的书**——纸质米色基底、衬线标题、珊瑚橙点缀、极简而有呼吸感。

---

## 1. 核心设计哲学

- **纸质感的暖色底**——不是纯白，是带温度的米色，长时间看不刺眼
- **衬线 + 无衬线混排**——标题用衬线营造编辑设计感，正文用无衬线保持现代清晰
- **斜体词强调**——标题中关键名词或动词用更细的斜体（如 "Meet your *thinking partner*"），是 Claude 最具辨识度的排版特征
- **珊瑚橙作为唯一彩色点缀**——其余皆中性色，不使用渐变、不使用紫色
- **大量留白**——区块之间有呼吸感，不堆砌
- **极简装饰**——避免炫技效果（粒子、复杂阴影、玻璃拟态），靠排版本身建立质感

---

## 2. 设计令牌（直接复制到 CSS）

```css
:root {
  /* 背景色 */
  --bg-primary: #F0EEE6;       /* 主背景：暖米色 */
  --bg-secondary: #EBE9DF;     /* 次背景：略深米色（分区用） */
  --bg-card: #FAF9F5;          /* 卡片背景 */
  --bg-input: #FFFFFF;         /* 输入框白底 */
  --bg-dark: #262624;          /* 深色区（页脚、深色 CTA） */

  /* 文字色 */
  --text-primary: #1F1E1B;     /* 主文字（接近黑棕） */
  --text-secondary: #5C5A53;   /* 次要文字 */
  --text-muted: #8E8A82;       /* 弱化文字、标签 */
  --text-on-dark: #F0EEE6;     /* 深色背景上的文字 */

  /* 品牌色（唯一彩色） */
  --accent: #CC785C;           /* 珊瑚橙 */
  --accent-hover: #B86848;     /* 深一档 */
  --accent-soft: #E8C5B5;      /* 柔和版，用作弱背景 */

  /* 边框 */
  --border-subtle: rgba(31, 30, 27, 0.08);
  --border-default: rgba(31, 30, 27, 0.14);
  --border-strong: rgba(31, 30, 27, 0.24);

  /* 字体 */
  --font-serif: 'Fraunces', 'Tiempos Headline', Georgia, serif;
  --font-sans: 'DM Sans', 'Styrene B', -apple-system, sans-serif;

  /* 圆角（保守、不夸张） */
  --radius-sm: 6px;
  --radius-md: 10px;
  --radius-lg: 16px;
  --radius-pill: 999px;
}
```

**字体加载（Google Fonts）：**
```html
<link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,300..900;1,9..144,300..900&family=DM+Sans:ital,opsz,wght@0,9..40,400..700;1,9..40,400..700&display=swap" rel="stylesheet">
```

---

## 3. 排版规则

| 层级 | 字体 | 字号 | 字重 | 字距 | 用途 |
|---|---|---|---|---|---|
| H1 | Fraunces | 56px (clamp 40-72) | 400 | -0.02em | 主标题 |
| H2 | Fraunces | 40px | 400 | -0.02em | 区块标题 |
| H3 | Fraunces | 28px | 400 | -0.02em | 卡片标题 |
| Lead | DM Sans | 18px | 400 | normal | 副标题/导语 |
| Body | DM Sans | 16px | 400 | normal | 正文 |
| Small | DM Sans | 14px | 400 | normal | 卡片描述 |
| Label | DM Sans | 12px | 500 | 0.12em + uppercase | 分区标签 |

**关键技巧——斜体强调：**

```html
<h1>Meet your <span class="italic-accent">thinking partner</span></h1>
<h2>The AI for <span class="italic-accent">problem solvers</span></h2>
```

```css
.italic-accent {
  font-style: italic;
  font-weight: 300;  /* 比正常更轻，制造对比 */
}
```

**几乎每个大标题都应该至少有一个词用斜体强调。** 这是 Claude 设计的核心标记。

---

## 4. 按钮规范

按钮高度统一、padding 一致，区别只在**颜色**和**视觉权重**：

### 4.1 主按钮（深色）
- 用途：核心 CTA（如 Try Claude, Start Importing）
- 样式：黑色背景 + 米色文字

```css
.btn-primary {
  background: var(--text-primary);
  color: var(--bg-primary);
  padding: 0.65rem 1.25rem;
  border-radius: var(--radius-sm);
  font-weight: 500;
  font-size: 14px;
  border: none;
  cursor: pointer;
  transition: all 200ms ease;
}
.btn-primary:hover {
  background: #000;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(31, 30, 27, 0.15);
}
```

### 4.2 强调按钮（珊瑚橙）
- 用途：次级强调（如 Ask Claude），通常嵌在输入框右侧
- 样式：橙底白字

```css
.btn-accent {
  background: var(--accent);
  color: #fff;
  /* 其余同上 */
}
.btn-accent:hover {
  background: var(--accent-hover);
}
```

### 4.3 描边按钮
- 用途：次级动作（Model details, Learn more）

```css
.btn-outline {
  background: transparent;
  color: var(--text-primary);
  border: 1px solid var(--border-strong);
}
.btn-outline:hover {
  background: var(--text-primary);
  color: var(--bg-primary);
}
```

### 4.4 胶囊按钮（Pill）
- 用途：功能标签快捷选项（Write / Learn / Code）

```css
.btn-pill {
  background: var(--bg-card);
  border: 1px solid var(--border-default);
  border-radius: var(--radius-pill);
  padding: 0.4rem 0.875rem;
  font-size: 12px;
  font-weight: 500;
  display: inline-flex;
  align-items: center;
  gap: 6px;
}
```

---

## 5. 输入框（Ask Claude 模式）

官网核心交互：**圆角白底卡片 + 内嵌橙色按钮**。

```html
<div class="ask-input">
  <input type="text" placeholder="How can I help you today?" />
  <button class="btn-accent btn-sm">Ask Claude ↑</button>
</div>
```

```css
.ask-input {
  display: flex;
  align-items: center;
  background: #FFFFFF;
  border: 1px solid var(--border-default);
  border-radius: var(--radius-lg);   /* 大圆角是关键 */
  padding: 0.5rem;
  max-width: 480px;
  box-shadow: 0 1px 2px rgba(31, 30, 27, 0.04);
}
.ask-input:focus-within {
  border-color: var(--text-primary);
  box-shadow: 0 4px 12px rgba(31, 30, 27, 0.06);
}
.ask-input input {
  flex: 1;
  border: none;
  outline: none;
  background: transparent;
  padding: 0.5rem 0.75rem;
  font-size: 14px;
}
```

下方常配一行胶囊标签作为快捷选项。

---

## 6. 导航栏

固定顶部，半透明米色背景 + 模糊。结构：**左 logo · 中链接 · 右动作区**。

```css
.navbar {
  position: sticky;
  top: 0;
  background: rgba(240, 238, 230, 0.85);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid var(--border-subtle);
  z-index: 100;
}
```

- Logo：左侧 Claude 字标 + 星芒图标（珊瑚橙）
- 中间链接：Meet Claude · Platform · Solutions · Pricing · Resources（带下拉小箭头）
- 右侧：Login · Contact sales · [Try Claude 主按钮]
- 字号小（14px），字重轻

**星芒图标 SVG（八角星）：**
```html
<svg viewBox="0 0 32 32" fill="currentColor" width="24" height="24" style="color: #CC785C;">
  <path d="M16 0 L18.5 13.5 L32 16 L18.5 18.5 L16 32 L13.5 18.5 L0 16 L13.5 13.5 Z"/>
</svg>
```

---

## 7. 卡片

### 7.1 横向产品卡（模型卡）
左侧标题，右侧描述 + 标签 + CTA。两栏网格。

```css
.model-card {
  background: var(--bg-card);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-lg);
  padding: 1.5rem 2rem;
  display: grid;
  grid-template-columns: 1fr 2fr;
  gap: 1.5rem;
  align-items: center;
  margin-bottom: 0.75rem;
}
```

### 7.2 三列特性卡
图标 + 短标题 + 一段描述，等高排布。

```css
.feature-card {
  background: var(--bg-card);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-lg);
  padding: 1.5rem;
}
```

### 7.3 标签 / Tag
极弱化，仅作信息分类：

```css
.tag {
  font-size: 12px;
  color: var(--text-muted);
  background: var(--bg-primary);
  padding: 0.25rem 0.625rem;
  border-radius: var(--radius-pill);
}
```

---

## 8. 区块结构模板

每个内容区块的标准结构：

```html
<section class="section">
  <p class="section-label">01 · CATEGORY</p>
  <h2>区块标题 <span class="italic-accent">关键词斜体</span></h2>
  <p class="section-desc">简短描述，最多 60 个字符宽度。</p>
  <!-- 内容 -->
</section>
```

```css
.section {
  padding: 6rem 0;
  border-bottom: 1px solid var(--border-subtle);
}
.section-label {
  font-size: 12px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  color: var(--text-muted);
  margin-bottom: 0.75rem;
}
.section-desc {
  max-width: 60ch;
  color: var(--text-secondary);
  margin-bottom: 3rem;
}
```

**间隔交替**：奇数区块 `--bg-primary`，偶数区块 `--bg-secondary`，让长页有节奏。

---

## 9. 页脚

深色，按 5 列展开：品牌区 + 4 列链接。链接灰白色、字号小、行高紧凑。

```css
.footer {
  background: #262624;
  color: #F0EEE6;
  padding: 4rem 0 1.5rem;
}
.footer-grid {
  display: grid;
  grid-template-columns: 2fr repeat(4, 1fr);
  gap: 2rem;
}
.footer h4 {
  font-size: 12px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: #B8B5AB;
}
.footer a {
  color: #F0EEE6;
  opacity: 0.85;
  font-size: 14px;
}
.footer a:hover {
  color: var(--accent);
}
```

---

## 10. 禁忌清单

构建 Claude 风格界面时**避免**以下做法：

- ❌ 使用纯白 `#fff` 作为页面主背景（会失去温度）
- ❌ 紫色/蓝紫渐变（Claude 风格的反面）
- ❌ 标题用粗体（Fraunces 用 weight 400 已经足够）
- ❌ 大圆角按钮（保持 6-10px，胶囊只用于标签）
- ❌ 玻璃拟态、Neumorphism、霓虹光效
- ❌ 多种强调色——只用 `--accent` 一种
- ❌ 用 Inter / Roboto / 系统字体作为主字体
- ❌ 不在标题里加斜体强调（**这是最该坚持的**）
- ❌ 浮夸阴影（最多用 `0 4px 12px rgba(31, 30, 27, 0.06)`）
- ❌ 满屏图标——优先用排版表达，图标只在必要时（功能卡左上）用极简单线

---

## 11. 给 AI 的一句话提示词

如果你只想用一句话让 AI 抓住要点，可以这样写：

> "请按 Claude.com 官网的设计风格构建这个页面：暖米色背景 `#F0EEE6`，珊瑚橙强调色 `#CC785C`，标题用 Fraunces 衬线字体且关键词用 italic + weight 300 强调，正文用 DM Sans，按钮圆角 6px，输入框圆角 16px，深色 CTA 用 `#1F1E1B`。整体风格温暖、人文、留白充足，避免渐变和炫技效果。"

