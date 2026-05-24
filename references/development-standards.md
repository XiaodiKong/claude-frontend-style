# 前端开发标准（完整版）

> 这是 AI 生成前端代码的完整规范文档，含示例代码、反例对照、决策依据。  
> 配套精简版：`frontend-standards-prompt.md`（用于贴 prompt）。  
> 本文档与 `claude-style-guide.md`（设计规范）配套使用。

---

## 目录

1. [代码精简：拒绝重复](#1-代码精简拒绝重复)
2. [组件设计：单一职责与可复用](#2-组件设计单一职责与可复用)
3. [性能优化：默认开启](#3-性能优化默认开启)
4. [可访问性 a11y：不可妥协的最低线](#4-可访问性-a11y不可妥协的最低线)
5. [响应式布局：移动优先](#5-响应式布局移动优先)
6. [状态管理：就近原则](#6-状态管理就近原则)
7. [HTML 语义化](#7-html-语义化)
8. [CSS 编写规范](#8-css-编写规范)
9. [命名约定](#9-命名约定)
10. [自检清单](#10-自检清单)

---

## 1. 代码精简：拒绝重复

### 核心原则

**DRY（Don't Repeat Yourself）：相同的样式 / 逻辑 / 结构出现 3 次以上 → 必须抽象。**

抽象的形式按优先级：
1. 设计令牌（CSS 变量 / Tailwind theme）
2. 工具类 / mixin
3. 组件

### 1.1 设计令牌优先

**❌ 反例：硬编码**
```css
.button-primary { background: #1F1E1B; color: #F0EEE6; }
.card-header   { color: #1F1E1B; border: 1px solid #1F1E1B; }
.text-label    { color: #1F1E1B; }
/* 每次改主色都得全局替换 */
```

**✅ 正例：用 token**
```css
:root {
  --color-primary: #1F1E1B;
  --color-bg: #F0EEE6;
}
.button-primary { background: var(--color-primary); color: var(--color-bg); }
.card-header   { color: var(--color-primary); border: 1px solid var(--color-primary); }
.text-label    { color: var(--color-primary); }
```

### 1.2 Tailwind 中的复用

**❌ 反例：到处复制 utility 串**
```jsx
<button className="px-4 py-2 bg-stone-900 text-stone-50 rounded-md font-medium hover:bg-black transition">Save</button>
<button className="px-4 py-2 bg-stone-900 text-stone-50 rounded-md font-medium hover:bg-black transition">Submit</button>
<button className="px-4 py-2 bg-stone-900 text-stone-50 rounded-md font-medium hover:bg-black transition">Confirm</button>
```

**✅ 正例 A：抽组件**
```jsx
const Button = ({ children, ...props }) => (
  <button
    className="px-4 py-2 bg-stone-900 text-stone-50 rounded-md font-medium hover:bg-black transition"
    {...props}
  >
    {children}
  </button>
);

<Button>Save</Button>
<Button>Submit</Button>
```

**✅ 正例 B：用 `@apply`（不想拆组件时）**
```css
@layer components {
  .btn-primary {
    @apply px-4 py-2 bg-stone-900 text-stone-50 rounded-md font-medium hover:bg-black transition;
  }
}
```

### 1.3 相似但不同 → 用 prop 而非复制

**❌ 反例：写 3 份**
```jsx
<ButtonPrimary />     // 黑底
<ButtonSecondary />   // 描边
<ButtonAccent />      // 橙色
// 三个文件，95% 代码相同
```

**✅ 正例：一个组件 + variant**
```jsx
<Button variant="primary" />
<Button variant="outline" />
<Button variant="accent" />

const Button = ({ variant = 'primary', children, ...props }) => {
  const variants = {
    primary: 'bg-stone-900 text-stone-50 hover:bg-black',
    outline: 'border border-stone-900 text-stone-900 hover:bg-stone-900 hover:text-stone-50',
    accent:  'bg-orange-600 text-white hover:bg-orange-700',
  };
  return (
    <button className={`px-4 py-2 rounded-md font-medium transition ${variants[variant]}`} {...props}>
      {children}
    </button>
  );
};
```

### 1.4 何时**不**该抽象

⚠️ **过度抽象比重复还糟。** 出现以下信号时停手：

- 抽象用的人少于 2 个调用点 → 等出现第 3 次再抽
- 抽象的 prop 比内容还多 → 说明抽错了边界
- 抽象后调用方需要传入大段配置才能用 → 应该是组合而非配置

---

## 2. 组件设计：单一职责与可复用

### 2.1 三层心智模型

借鉴 Atomic Design，但只保留三层：

```
原子 (atoms)         Button, Input, Icon, Tag
   ↓
分子 (molecules)     SearchBar = Input + Button
   ↓
有机体 (organisms)   Header = Logo + Nav + SearchBar + UserMenu
```

**规则：**
- 原子组件**不依赖**任何业务，纯 UI
- 分子组件可以由多个原子组合
- 有机体可以有业务逻辑（数据获取、状态）

### 2.2 容器 / 展示分离

**❌ 反例：耦合**
```jsx
function UserList() {
  const [users, setUsers] = useState([]);
  useEffect(() => { fetch('/api/users').then(r => r.json()).then(setUsers); }, []);
  
  return (
    <div className="grid grid-cols-3 gap-4">
      {users.map(u => (
        <div className="rounded-lg border p-4">
          <img src={u.avatar} className="w-12 h-12 rounded-full" />
          <h3>{u.name}</h3>
          <p>{u.email}</p>
        </div>
      ))}
    </div>
  );
}
// 想在另一个页面复用卡片样式 → 没法用
```

**✅ 正例：拆分**
```jsx
// 展示组件：纯 UI，可在任何地方复用
function UserCard({ user }) {
  return (
    <div className="rounded-lg border p-4">
      <img src={user.avatar} alt={`${user.name}'s avatar`} className="w-12 h-12 rounded-full" />
      <h3>{user.name}</h3>
      <p>{user.email}</p>
    </div>
  );
}

// 容器组件：负责数据
function UserListPage() {
  const { data: users = [] } = useQuery('users', () => fetch('/api/users').then(r => r.json()));
  return (
    <div className="grid grid-cols-3 gap-4">
      {users.map(u => <UserCard key={u.id} user={u} />)}
    </div>
  );
}
```

### 2.3 用组合替代配置

**❌ 反例：用一堆 prop 描述结构**
```jsx
<Card
  title="Opus 4.7"
  showAvatar={true}
  avatarUrl="..."
  tags={['fast', 'smart']}
  actionLabel="Try"
  actionVariant="primary"
  showFooter={true}
  footerText="Released today"
/>
```

**✅ 正例：用 children / slot 组合**
```jsx
<Card>
  <Card.Header>
    <h3>Opus 4.7</h3>
    <TagList tags={['fast', 'smart']} />
  </Card.Header>
  <Card.Body>Most powerful model for ambitious projects.</Card.Body>
  <Card.Footer>
    <Button variant="primary">Try</Button>
    <span className="text-xs text-stone-500">Released today</span>
  </Card.Footer>
</Card>
```

### 2.4 文件大小红线

| 行数 | 状态 |
|---|---|
| < 100 | 健康 |
| 100–200 | 关注 |
| 200–300 | 应该拆 |
| > 300 | **必须拆** |

### 2.5 命名意图清晰

**❌ 反例：含糊命名**
```jsx
<Wrapper>
  <Container>
    <Box>
      <Item />
    </Box>
  </Container>
</Wrapper>
```

**✅ 正例：表达意图**
```jsx
<PageLayout>
  <ContentSection>
    <ProductGrid>
      <ProductCard />
    </ProductGrid>
  </ContentSection>
</PageLayout>
```

---

## 3. 性能优化：默认开启

### 3.1 图片

**所有规则缺一不可。**

```html
<!-- ❌ 反例 -->
<img src="hero.jpg" />

<!-- ✅ 正例 -->
<img
  src="hero.webp"
  alt="产品概览：三种模型对比"
  width="800"          <!-- 防 CLS 必须 -->
  height="450"
  loading="lazy"        <!-- 首屏外的图 -->
  decoding="async"
  srcset="hero@1x.webp 800w, hero@2x.webp 1600w"
  sizes="(max-width: 768px) 100vw, 800px"
/>
```

**首屏关键图加 `fetchpriority="high"`，移除 `loading="lazy"`。**

格式选择：
- **照片** → AVIF / WebP（比 JPEG 小 30%）
- **图标** → SVG（可缩放，可控）
- **UI 截图** → WebP

### 3.2 动画：只动 GPU 加速属性

**只有这两类属性会被 GPU 合成，不触发布局：**

```
✅ transform: translate / scale / rotate
✅ opacity
```

**❌ 反例：动 layout 属性（卡顿元凶）**
```css
.card:hover {
  margin-top: -4px;    /* 触发整页 reflow */
  width: 110%;         /* 触发布局重排 */
  top: -4px;           /* 同上 */
}
```

**✅ 正例：动 transform**
```css
.card {
  transition: transform 200ms ease;
}
.card:hover {
  transform: translateY(-4px) scale(1.02);
}
```

### 3.3 渲染优化

**长列表用虚拟滚动**：>50 项的列表都该考虑（`react-virtuoso` / `@tanstack/react-virtual`）。

**懒加载首屏外组件**：
```jsx
const HeavyChart = lazy(() => import('./HeavyChart'));

<Suspense fallback={<Skeleton />}>
  <HeavyChart />
</Suspense>
```

**避免不必要的 re-render**：
- 把昂贵的计算放 `useMemo`
- 把传给子组件的函数放 `useCallback`（仅当子组件用 `React.memo` 时才有用）
- ⚠️ 不要无脑全部 memo——memo 本身也有成本

### 3.4 字体加载

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
  href="https://fonts.googleapis.com/css2?family=Fraunces&display=swap"
  rel="stylesheet"
/>
```

`display=swap` 必加——文字先用系统字体显示，避免 FOIT（不可见文字）。

### 3.5 Bundle 体积

经验门槛：
- 单页 JS < 200KB（gzipped）
- 大依赖（图表库、富文本编辑器）必须动态导入
- 用 `import { specific } from 'lib'` 而非 `import * as lib`

---

## 4. 可访问性 a11y：不可妥协的最低线

### 4.1 语义 HTML 是基石

**❌ 反例：div 大杂烩**
```html
<div onclick="submit()">提交</div>
<div onclick="goHome()">首页</div>
<div class="title">页面标题</div>
```
键盘用户无法 Tab 到这些元素，屏幕阅读器无法识别。

**✅ 正例：语义元素**
```html
<button type="button" onclick="submit()">提交</button>
<a href="/">首页</a>
<h1>页面标题</h1>
```

| 用途 | 用什么 | 不用什么 |
|---|---|---|
| 触发动作 | `<button>` | `<div onClick>` |
| 跳转链接 | `<a href>` | `<div onClick>` |
| 表单 | `<form>` + `<input>` + `<label>` | div 模拟 |
| 标题 | `<h1>`-`<h6>` | `<div class="title">` |
| 列表 | `<ul>` / `<ol>` + `<li>` | `<div>` 堆 |

### 4.2 图片 alt

```html
<img src="hero.jpg" alt="三人围桌讨论产品方案" />  <!-- ✅ 信息性 -->
<img src="decoration.svg" alt="" />               <!-- ✅ 装饰性，空 alt -->
<img src="logo.svg" alt="Claude 标志" />          <!-- ✅ 功能性 -->
```

**`alt` 不能省**，省了屏幕阅读器会念文件名。

### 4.3 表单

```html
<!-- ✅ 显式 label -->
<label for="email">邮箱</label>
<input id="email" type="email" required />

<!-- ✅ 包裹式 label（不需要 for） -->
<label>
  邮箱
  <input type="email" required />
</label>

<!-- ✅ 没有可见 label 时用 aria-label -->
<input type="search" aria-label="搜索文档" placeholder="搜索..." />
```

### 4.4 颜色对比度

| 内容 | 最低对比度 |
|---|---|
| 正文（< 18px） | 4.5:1 |
| 大字（≥ 18px 或 14px bold） | 3:1 |
| UI 元素（按钮边框等） | 3:1 |

工具：Chrome DevTools → 检查元素 → 颜色选择器会显示对比度。

**❌ 永远不要只用颜色传达状态：**
```html
<span style="color: red">提交失败</span>  <!-- 色盲看不到 -->
```

**✅ 配图标或文字：**
```html
<span style="color: red"><span aria-hidden="true">⚠</span> 错误：提交失败</span>
```

### 4.5 键盘导航

- 所有交互元素必须能用 Tab 到达
- `:focus` 不能完全移除——若要换样式，至少替换为 `:focus-visible`：

```css
/* ❌ 禁忌 */
button:focus { outline: none; }

/* ✅ 替换为更美观的可见 focus */
button:focus-visible {
  outline: 2px solid var(--accent);
  outline-offset: 2px;
}
```

- Modal 打开时焦点要陷阱在 modal 内，按 ESC 关闭

### 4.6 ARIA 用法

ARIA 是补充语义、不是替代。**第一选择永远是语义 HTML。**

常用场景：
```html
<!-- 不可见标签 -->
<button aria-label="关闭对话框">✕</button>

<!-- 实时区域（动态更新提示） -->
<div role="status" aria-live="polite">数据已保存</div>
<div role="alert">提交失败</div>

<!-- 展开/折叠 -->
<button aria-expanded="false" aria-controls="menu-list">菜单</button>
<ul id="menu-list" hidden>...</ul>
```

---

## 5. 响应式布局：移动优先

### 5.1 标准断点

```css
/* 移动优先：默认 = 最小屏 */
.card { padding: 1rem; }

/* 向上覆盖 */
@media (min-width: 640px)  { .card { padding: 1.5rem; } }  /* sm 大手机 */
@media (min-width: 768px)  { .card { padding: 2rem; } }    /* md 平板 */
@media (min-width: 1024px) { .card { padding: 2.5rem; } }  /* lg 笔记本 */
@media (min-width: 1280px) { /* xl 桌面 */ }
@media (min-width: 1536px) { /* 2xl 大屏 */ }
```

⚠️ **不要混用 `min-width` 和 `max-width`，统一移动优先用 `min-width`。**

### 5.2 用 clamp 减少断点

**❌ 反例：4 个断点改字号**
```css
h1 { font-size: 24px; }
@media (min-width: 640px)  { h1 { font-size: 32px; } }
@media (min-width: 1024px) { h1 { font-size: 48px; } }
@media (min-width: 1536px) { h1 { font-size: 64px; } }
```

**✅ 正例：一行 clamp**
```css
h1 { font-size: clamp(1.5rem, 4vw + 1rem, 4rem); }
/* min, fluid, max */
```

### 5.3 自适应网格

**❌ 反例：3 个断点写网格列数**
```css
.grid { grid-template-columns: 1fr; }
@media (min-width: 768px)  { .grid { grid-template-columns: 1fr 1fr; } }
@media (min-width: 1024px) { .grid { grid-template-columns: repeat(3, 1fr); } }
```

**✅ 正例：自动适配**
```css
.grid {
  display: grid;
  gap: 1rem;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
}
```
卡片自动按容器宽度排，280px 是单卡最小宽度。

### 5.4 容器查询（现代浏览器）

```css
.card-wrapper { container-type: inline-size; }

.card { display: block; }
@container (min-width: 400px) {
  .card { display: flex; gap: 1rem; }
}
```

让组件根据**自身容器宽度**变化，而不是窗口宽度——比媒体查询灵活。

### 5.5 单组件断点上限

**一个组件超过 3 个断点 → 信号：要么设计太复杂，要么该拆。**

---

## 6. 状态管理：就近原则

### 6.1 决策树

```
需要这个状态吗？
├─ 仅一个组件用？ → useState 本地
├─ 父子两层用？  → 提升到父级
├─ 兄弟组件共享？ → 提升到最低公共祖先
├─ 跨多页/可分享？ → URL 参数
├─ 全应用都用？  → Context（少量）/ 全局 store（频繁/复杂）
└─ 来自服务器？  → React Query / SWR（永远不进全局 store）
```

### 6.2 服务端状态独立管理

**❌ 反例：把请求数据塞 Redux**
```js
// 自己写 fetch + loading + error + cache + revalidate……
const [users, setUsers] = useState([]);
const [loading, setLoading] = useState(false);
const [error, setError] = useState(null);

useEffect(() => {
  setLoading(true);
  fetch('/api/users')
    .then(r => r.json())
    .then(setUsers)
    .catch(setError)
    .finally(() => setLoading(false));
}, []);
```

**✅ 正例：用 React Query / SWR**
```js
const { data: users, isLoading, error } = useQuery({
  queryKey: ['users'],
  queryFn: () => fetch('/api/users').then(r => r.json()),
});
// 自带缓存、去重、重试、后台刷新
```

### 6.3 派生状态不要存

**❌ 反例：存第二份**
```js
const [items, setItems] = useState([...]);
const [count, setCount] = useState(items.length);  // 多余！
// 每次改 items 都得记得同步 count
```

**✅ 正例：直接计算**
```js
const [items, setItems] = useState([...]);
const count = items.length;  // 或贵了用 useMemo
```

### 6.4 表单状态

简单表单 → `useState`  
复杂表单（验证、嵌套字段）→ `react-hook-form` / `formik`  

**永远不要进全局 store。** 表单状态是临时的、局部的。

### 6.5 URL 是免费的状态存储

可分享、可刷新、可前进后退——这些场景必须用 URL：

- 列表筛选条件（`?status=active&sort=date`）
- 分页（`?page=3`）
- 标签切换（`?tab=billing`）
- 搜索关键词（`?q=claude`）
- Modal 状态（如果要支持深链接）

---

## 7. HTML 语义化

### 7.1 页面骨架

```html
<body>
  <header>
    <nav><!-- 主导航 --></nav>
  </header>
  
  <main>  <!-- 一页只能有一个 -->
    <article>
      <h1>页面主标题</h1>
      <section>
        <h2>章节</h2>
        <p>...</p>
      </section>
    </article>
    
    <aside>
      <!-- 侧边栏 / 辅助内容 -->
    </aside>
  </main>
  
  <footer>
    <!-- 页脚 -->
  </footer>
</body>
```

### 7.2 标题层级

- 每页有且只有一个 `<h1>`
- 层级不能跳：`h2` 后只能是 `h3`，不能直接 `h4`
- 不要用标题做样式（要大字就改 CSS）

### 7.3 列表

```html
<!-- ✅ 真的是列表 -->
<ul>
  <li>项 1</li>
  <li>项 2</li>
</ul>

<!-- ❌ 不是 -->
<div class="list">
  <div class="item">项 1</div>
  <div class="item">项 2</div>
</div>
```

---

## 8. CSS 编写规范

### 8.1 属性书写顺序

```css
.card {
  /* 1. 定位 */
  position: relative;
  top: 0;
  z-index: 1;
  
  /* 2. 显示 */
  display: flex;
  flex-direction: column;
  gap: 1rem;
  
  /* 3. 盒模型 */
  width: 100%;
  max-width: 480px;
  padding: 1.5rem;
  margin: 0 auto;
  
  /* 4. 排版 */
  font-family: var(--font-serif);
  font-size: 1rem;
  color: var(--text-primary);
  
  /* 5. 视觉 */
  background: var(--bg-card);
  border: 1px solid var(--border-subtle);
  border-radius: 12px;
  
  /* 6. 动效 */
  transform: translateZ(0);
  transition: transform 200ms ease;
}
```

### 8.2 选择器层级

- 单层类选择器为主：`.card`
- BEM 命名：`.card__header` / `.card--featured`
- **避免选择器超过 3 层**：`.page .content .card .title` ❌
- **避免标签 + 类**：`button.primary` → 直接 `.btn-primary`
- **避免 id 选择器**：`#header` 优先级太高，难覆盖

### 8.3 单位

| 用途 | 单位 |
|---|---|
| 字号、间距 | `rem`（响应根字号） |
| 内部小尺寸 | `em`（相对父字号） |
| 边框 | `px` |
| 容器宽度 | `%` / `vw` / `clamp()` |
| 高度 | 优先 `auto`，必要时 `vh` / `dvh` |

⚠️ 移动端注意：`100vh` 在 iOS Safari 会被工具栏挤压，用 `100dvh`。

---

## 9. 命名约定

### 9.1 表

| 类型 | 规则 | 示例 |
|---|---|---|
| React 组件 | PascalCase | `UserCard`, `SearchInput` |
| 函数 / 变量 | camelCase | `handleClick`, `userName` |
| Hook | `use*` | `useAuth`, `useDebounce` |
| CSS 类 | kebab-case / BEM | `user-card`, `user-card__title` |
| CSS 变量 | `--kebab-case` | `--text-primary` |
| 常量 | UPPER_SNAKE | `MAX_RETRY`, `API_BASE_URL` |
| 文件 | kebab-case 或匹配导出 | `user-card.tsx` 或 `UserCard.tsx` |
| 事件处理器 | `handle*` | `handleSubmit`, `handleChange` |
| 事件 prop | `on*` | `onSubmit`, `onChange` |
| 布尔变量 | `is*` / `has*` / `can*` / `should*` | `isLoading`, `hasError` |

### 9.2 函数命名表达意图

**❌ 反例：动词模糊**
```js
function process(data) {...}
function handleData(d) {...}
function doStuff() {...}
```

**✅ 正例：动词具体**
```js
function calculateTotalPrice(items) {...}
function validateEmailFormat(email) {...}
function fetchUserProfile(userId) {...}
```

### 9.3 布尔变量不要双重否定

```js
// ❌
const notDisabled = true;
if (!notDisabled) { ... }

// ✅
const isEnabled = true;
if (isEnabled) { ... }
```

---

## 10. 自检清单

生成代码完成后，逐项核对：

### 代码质量
- [ ] 重复 ≥3 次的样式 / 逻辑都抽出来了
- [ ] 最长的组件 < 200 行
- [ ] 组件 props ≤ 7 个
- [ ] 命名都表达意图，没有 Wrapper/Container/Box 这种含糊词

### 可访问性
- [ ] 所有 `<img>` 都有 `alt` 属性
- [ ] 所有可点击元素是 `<button>` 或 `<a>`，没有 `<div onClick>`
- [ ] 所有 `<input>` 都有 `<label>` 或 `aria-label`
- [ ] 标题层级 h1→h2→h3 连续，未跳级
- [ ] 颜色对比度 ≥ 4.5:1（正文）
- [ ] 没有移除 `:focus` outline（或有 `:focus-visible` 替代）
- [ ] 状态信息不只靠颜色传达

### 性能
- [ ] 所有 `<img>` 都有显式 `width` / `height`
- [ ] 首屏外的图加了 `loading="lazy"`
- [ ] 动画只动 `transform` / `opacity`
- [ ] 长列表（>50 项）用了虚拟滚动
- [ ] 大组件用了 lazy import

### 响应式
- [ ] 用的是标准断点（sm/md/lg/xl）
- [ ] 移动优先（`min-width` 而非 `max-width`）
- [ ] 单组件断点 ≤ 3 个
- [ ] 流式尺寸优先（`clamp` / `auto-fit`）

### 状态
- [ ] 状态放在能用到它的最低层级
- [ ] 服务端数据用 React Query/SWR，没塞全局 store
- [ ] 没有派生状态被存了第二份
- [ ] 可分享的状态用了 URL

### HTML / CSS
- [ ] 用了语义标签（header/nav/main/section/article/footer）
- [ ] 每页只有一个 `<h1>`、一个 `<main>`
- [ ] CSS 属性按 定位→显示→盒模型→排版→视觉→动效 排序
- [ ] 选择器层级 ≤ 3
- [ ] 字号、间距用 rem；边框用 px

**任何一项 ❌ → 重写到通过为止。**

---

## 附录：技术栈对照速查

### Tailwind 中的实践

```jsx
// ✅ 抽组件
const Button = ({ variant, ...props }) => {
  const v = {
    primary: 'bg-stone-900 text-stone-50 hover:bg-black',
    accent:  'bg-orange-600 text-white hover:bg-orange-700',
  };
  return <button className={`px-4 py-2 rounded-md ${v[variant]}`} {...props} />;
};

// ✅ 用 cn / clsx 处理条件 class
import { cn } from '@/lib/utils';
<div className={cn('base-class', isActive && 'active-class')} />

// ✅ tailwind.config.js 里定义 theme
theme: {
  extend: {
    colors: { brand: '#CC785C' },
    fontFamily: { serif: ['Fraunces', 'Georgia'] },
  }
}
```

### React 中的实践

```jsx
// ✅ 函数组件 + Hooks
// ✅ 解构 props，给默认值
function UserCard({ user, onSelect, isSelected = false }) { ... }

// ✅ 列表加 key（用 id，不用 index）
{users.map(u => <UserCard key={u.id} user={u} />)}

// ✅ 条件渲染清晰
{isLoading ? <Skeleton /> : <Content />}
{error && <ErrorBanner error={error} />}
```

### 纯 HTML/CSS 中的实践

```html
<!-- ✅ 用 CSS 变量替代 SASS 变量，省构建 -->
<style>
  :root { --primary: #1F1E1B; }
</style>

<!-- ✅ 用 CSS nesting（现代浏览器原生支持） -->
<style>
  .card {
    padding: 1rem;
    & .title { font-weight: 600; }
    &:hover { transform: translateY(-2px); }
  }
</style>
```

---

**配套文档：**
- `claude-style-guide.md` — 视觉设计规范
- `claude-design-system.html` — 设计系统组件展示
- `frontend-standards-prompt.md` — 精简版（贴 prompt 用）
