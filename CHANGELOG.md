# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned
- Variant skills for dark mode / compact internal-tool style
- More component patterns (modals, toasts, navigation drawer)
- Integration examples for Next.js, Astro, SvelteKit

---

## [1.0.0] — 2026-05-24

### Added

**Skill structure**
- `SKILL.md` — Skill entry point with frontmatter, trigger description tuned for high recall on frontend-related prompts
- `references/design-system.md` — Visual design specification (colors, typography, spacing, component patterns)
- `references/development-standards.md` — Production-grade code quality rules with side-by-side anti-pattern examples
- `assets/design-system-demo.html` — Self-contained live demo page rendering every component, copyable styles inline

**Visual design system**
- Warm cream palette (`#F0EEE6` primary, `#EBE9DF` secondary, `#FAF9F5` cards, `#262624` dark surfaces)
- Coral accent (`#CC785C`) as the sole chromatic color
- Fraunces (Google Fonts) for serif headings + DM Sans for body — free alternatives to Tiempos / Styrene
- Italic emphasis pattern for headings (`<span class="italic-accent">`) — Claude.com's most distinctive typographic signature
- Five button variants: primary (dark), accent (coral), outline, ghost, pill
- Ask Claude input pattern (16px radius, embedded coral button)
- Model card layout (two-column horizontal)
- Three-column feature card grid
- Dark footer with five-column structure

**Development standards (10 commandments)**
1. No repetition — same style/logic ≥3× → must abstract
2. Single responsibility — components ≤ 200 lines, props ≤ 7
3. GPU-only animations — `transform` and `opacity` only
4. Semantic HTML — `<button>` / `<a>` not `<div onClick>`
5. All images: `alt` + explicit dimensions + `loading="lazy"`
6. Color contrast ≥ 4.5:1; never convey state by color alone
7. Mobile-first responsive with standardized breakpoints (sm/md/lg/xl/2xl)
8. State lives close — local → lift → URL → global last
9. Keep `:focus` visible (replace with `:focus-visible` if customizing)
10. Self-check before delivery

**Distribution**
- Pre-built `.skill` file for one-click upload to Claude.ai Projects
- Source folder ready for `.claude/skills/` placement in Claude Code projects
- Comprehensive README with team installation instructions
- `publish.sh` for repository initialization and GitHub setup

### Compatibility

- Claude.ai (Pro / Team / Enterprise plans — Skills feature required)
- Claude Code (project-level and user-level skill paths)
- Framework-agnostic standards (React, Vue, Svelte, vanilla HTML/CSS all supported)

---

## Versioning policy

This skill follows semantic versioning:

- **MAJOR** (e.g., 2.0.0) — Breaking changes to design tokens or core rules that would change how Claude generates code in a way teams need to coordinate around
- **MINOR** (e.g., 1.1.0) — New components, new standards rules, new examples; additive and backward-compatible
- **PATCH** (e.g., 1.0.1) — Typo fixes, clarifications, single-rule refinements

When upgrading, check the relevant section above to know what changed.
