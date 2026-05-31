# Dashboard Theme Prompt

> This is the **design brief** for your OwnYourCode dashboard. `/own:theme` reads
> it and regenerates the inline `<style>` block of `dashboard.html` from it —
> with the `frontend-design` plugin if you have it, otherwise with Claude's own
> design skills. Edit this file to change how your dashboard looks, then run
> `/own:theme` and pick **Regenerate**.
>
> You control the VISUAL design only. Never ask for layout/structure or class
> changes here — the dashboard's render contract is fixed (see the command).

---

## Aesthetic direction — "Terminal-Futurism"

**Dark space meets developer aesthetics.** The dashboard should feel like a
premium developer terminal/console: calm, precise, alive, a little futuristic.
Restraint signals quality — hierarchy comes from scale, space, and outline, not
from coloring every box.

### Palette (dark-native — there is no light mode)
- **Backgrounds — a near-black ramp with a faint blue tint** (depth via stacked
  surfaces, not gradients): `#030305` (void) · `#050508` (deep) · `#0a0a0f`
  (surface) · `#0d0d14` (elevated) · `#111118` (card).
- **Accent — terminal green, the ONE accent:** `#22c55e`, brighter `#4ade80`,
  dim `#16a34a`. Use a real **glow** (`rgba(34,197,94,0.4)`) on key accent
  elements (active states, the progress ring, checked boxes) — sparingly.
- **Text — slate ramp:** `#f1f5f9` → `#94a3b8` → `#64748b` → `#475569`.
- **Status / terminal-window chrome:** red `#ff5f56`, yellow `#ffbd2e`, green
  `#27c93f` (these double as priority/status dots).
- **Borders:** hairlines `rgba(148,163,184,0.10)`; accent border
  `rgba(34,197,94,0.30)`.

### Typography
- **Body / display:** `Outfit` (Google Fonts), weights 300–700.
- **The "terminal voice" — everything technical:** `JetBrains Mono` (Google
  Fonts) for labels, numbers, IDs, code, badges, eyebrows. Lean on it; it is the
  identity. Keep a system fallback in the font stack.

### Signature motif — the "ghost numeral"
Big mono numerals (phase numbers, list indices) rendered as **ghosts**: a large
`JetBrains Mono` numeral with a near-invisible fill (an elevated-background
color) plus a 1px hairline `-webkit-text-stroke`. Loud in scale, whisper-quiet
in color. Use this treatment wherever a number marks structure.

### Texture & motion
- A barely-there fractal-noise grain overlay for depth (opacity ~0.025).
- A faint, green-tinted grid on the main canvas.
- Green glows on accent elements; a staggered tile-reveal on load; a spring
  checkbox pop. **All motion must respect `prefers-reduced-motion`.**
- Green text selection; a dark custom scrollbar; ease-out-expo timing.

---

## Anti-AI-UI rules (do NOT violate)
- **No Inter / no bare system-sans** as the primary face. Use the named type
  system above (Outfit + JetBrains Mono).
- **No purple→blue / indigo SaaS gradients.** One deliberate green accent;
  depth from layered surfaces, not from coloring boxes.
- **No uniform 16px-radius-everywhere.** Vary radii with intent.
- **No colored-left-border "alert" cards.** Editorial treatment instead
  (numbered markers, weight contrast, a hairline that warms on hover).
- **No emoji-as-icons, no flat pure-black text, no identical drop shadows.**
- Commit to the aesthetic; treat the output as a draft and audit it against
  these rules.

---

## Technical constraints (the dashboard is a `file://` artifact)
- The dashboard opens by double-click (no local server). Therefore: **all CSS
  must be inline** in the `<style>` block — no external stylesheet `<link>`.
- **Web fonts ARE allowed** (the page is always online — OwnYourCode runs through
  Claude). Load Outfit + JetBrains Mono from Google Fonts via `<link>` in
  `<head>`. Keep system fallbacks for graceful degradation.
- Style only the existing classes the dashboard renders — never rename or remove
  them (that would break the render JS). The command lists the class contract.

---

*Want a different look? Rewrite this brief (keep the Technical constraints
section intact) and run `/own:theme` → Regenerate.*
