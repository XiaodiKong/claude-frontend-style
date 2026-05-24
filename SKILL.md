---
name: claude-frontend-style
description: Build polished frontend interfaces in the Claude.com design language—warm cream backgrounds, coral accent, serif headings with italic emphasis—while following strict code quality standards (no repeated styles, semantic HTML, accessibility, performance, mobile-first responsive). Use this skill whenever the user asks to build, design, style, or create ANY web UI, landing page, dashboard, component, React/Vue/Tailwind code, marketing page, or visual interface—even if they don't explicitly say "Claude style." This skill ensures the output looks like Claude.com AND meets production code quality standards.
---

# Claude Frontend Style

A skill for generating frontend code that visually matches the Claude.com aesthetic AND meets production-grade code quality standards. Combines visual design system with strict development rules.

## When this skill runs

Apply this skill whenever you're producing HTML, CSS, JSX, Vue templates, or any frontend code that has user-visible UI—including landing pages, dashboards, components, forms, and full applications. The skill has two pillars that must both apply:

1. **Visual style** (looks like Claude.com): warm cream background, coral accent, serif headings with italic emphasis, plenty of whitespace
2. **Code standards** (production-quality code): no duplication, semantic HTML, accessibility, mobile-first responsive, performance defaults

## Reading order

For most tasks, read both reference files before writing any code:

1. **`references/design-system.md`** — Read when the task involves visual styling, layout, colors, typography, or component appearance. Contains design tokens, font stack, button/card/input patterns.
2. **`references/development-standards.md`** — Read for ALL frontend code generation, regardless of visual scope. Contains the 10 commandments, anti-patterns with examples, and the self-check list.

If the task is heavily visual (designing a page from scratch), additionally view `assets/design-system-demo.html` to see all components rendered together.

## The 10 commandments (always apply)

These are non-negotiable for every piece of frontend code:

1. **No repetition.** Same style/logic appearing 3+ times → must abstract (CSS variables, components, utility classes).
2. **Single responsibility.** Each component does one thing; max 200 lines; max 7 props.
3. **GPU animations only.** Animate `transform` and `opacity`—never `width`, `height`, `top`, `left`, or `margin`.
4. **Semantic HTML.** Clickables are `<button>` or `<a>`, never `<div onClick>`. Use `<header>`, `<nav>`, `<main>`, `<section>`, `<footer>`.
5. **All images have `alt`** + explicit `width`/`height` + `loading="lazy"` for below-fold.
6. **Color contrast ≥ 4.5:1** for body text. Never convey state by color alone.
7. **Mobile-first responsive.** Use standard breakpoints only: `sm:640px md:768px lg:1024px xl:1280px 2xl:1536px`. Prefer `clamp()` over multiple breakpoints.
8. **State lives close.** Local first → lift only when shared → URL for shareable → global store last. Server state always via React Query/SWR.
9. **Keep `:focus` visible.** If you remove the default outline, provide a `:focus-visible` replacement.
10. **Self-check before delivery.** Run the full checklist (in development-standards.md §10).

## Core visual identity (Claude.com aesthetic)

Apply these exact tokens whenever generating UI. Do not deviate without explicit request:

```css
:root {
  /* Background */
  --bg-primary: #F0EEE6;       /* warm cream - main */
  --bg-secondary: #EBE9DF;     /* slightly darker - section alt */
  --bg-card: #FAF9F5;          /* card surface */
  --bg-dark: #262624;          /* footer / dark CTA */

  /* Text */
  --text-primary: #1F1E1B;     /* near-black brown */
  --text-secondary: #5C5A53;
  --text-muted: #8E8A82;

  /* Brand (the only chromatic color) */
  --accent: #CC785C;           /* signature coral */
  --accent-hover: #B86848;

  /* Borders */
  --border-subtle: rgba(31, 30, 27, 0.08);
  --border-default: rgba(31, 30, 27, 0.14);

  /* Fonts */
  --font-serif: 'Fraunces', 'Tiempos Headline', Georgia, serif;
  --font-sans: 'DM Sans', -apple-system, sans-serif;

  /* Radii */
  --radius-sm: 6px;     /* buttons */
  --radius-md: 10px;    /* cards */
  --radius-lg: 16px;    /* inputs, large cards */
  --radius-pill: 999px; /* tags */
}
```

**Font loading (Google Fonts):**
```html
<link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,300..900;1,9..144,300..900&family=DM+Sans:ital,opsz,wght@0,9..40,400..700;1,9..40,400..700&display=swap" rel="stylesheet">
```

## The italic emphasis pattern (most distinctive)

**Every major heading should have at least one word in italic + lighter weight.** This is the single most recognizable Claude.com signature:

```html
<h1>Meet your <span class="italic-accent">thinking partner</span></h1>
<h2>The AI for <span class="italic-accent">problem solvers</span></h2>
<h3>Keep <span class="italic-accent">thinking</span> with</h3>
```

```css
h1, h2, h3 {
  font-family: var(--font-serif);
  font-weight: 400;
  letter-spacing: -0.02em;
}
.italic-accent {
  font-style: italic;
  font-weight: 300;
}
```

If you produce headings without italic emphasis, the page won't read as "Claude style." For functional UI (forms, dashboards) the italic accent is optional, but for marketing/landing/hero sections it should always appear.

## Buttons (5 variants)

Stick to these five button forms. Same padding/radius across all—only color and weight vary:

| Variant | Use case | Style |
|---|---|---|
| `primary` | Main CTA (Try, Submit, Save) | `bg: --text-primary; color: --bg-primary` |
| `accent` | Secondary emphasis (Ask Claude) | `bg: --accent; color: white` |
| `outline` | Tertiary actions | `border + transparent bg` |
| `ghost` | Nav/toolbar | `no border, hover: bg-subtle` |
| `pill` | Tags/shortcuts | `radius-pill; subtle background` |

Base spec: `padding: 0.65rem 1.25rem; font-size: 14px; font-weight: 500; border-radius: 6px;`

## Forbidden patterns

Producing any of these means the output doesn't match Claude style:

- ❌ Pure white `#fff` page background (loses warmth → use `#F0EEE6`)
- ❌ Purple/blue gradients (Claude's visual antithesis)
- ❌ Bold heading weights (Fraunces weight 400 is enough)
- ❌ Inter / Roboto as primary font (use Fraunces + DM Sans)
- ❌ Glassmorphism, neumorphism, neon glows
- ❌ Multiple accent colors (only `--accent` for emphasis)
- ❌ Showy shadows (max: `0 4px 12px rgba(31, 30, 27, 0.06)`)
- ❌ Icon-heavy interfaces (prefer typography; icons only where functional)

## Output expectations

When generating a Claude-style frontend:

1. Start with the design tokens block (above) at the top of `:root`
2. Load Fraunces + DM Sans from Google Fonts
3. Use `--bg-primary` as page background, not `#fff`
4. Headings: Fraunces 400, with at least one word `.italic-accent` (italic + weight 300)
5. CTAs: `primary` button (dark) or `accent` button (coral)
6. Sections: alternate `--bg-primary` and `--bg-secondary` for rhythm
7. Footer: dark background `--bg-dark` with cream text

After writing the code, run the self-check from `references/development-standards.md` §10.

## File structure of this skill

```
claude-frontend-style/
├── SKILL.md                       ← you are here
├── references/
│   ├── design-system.md           ← full visual design spec
│   └── development-standards.md   ← code quality rules with examples
└── assets/
    └── design-system-demo.html    ← live component reference
```

When in doubt about a visual question, view the demo HTML. When in doubt about code quality, consult development-standards.md.
