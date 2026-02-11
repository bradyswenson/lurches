---
name: sim-game-design
description: "Full-lifecycle simulation game design and implementation. Use this skill whenever building simulation games, agent-based systems, genetic/evolution sandboxes, ecosystem simulations, cellular automata, economy sims, or any game where entities follow rules and emergent behavior arises from simple mechanics. Also trigger when the user wants to analyze, balance, debug, or extend an existing simulation — even if they just say 'why isn't trait X working' or 'the agents aren't behaving right.' Covers architecture, mechanics design, emergent behavior patterns, rendering, UI, and iterative polish."
---

# Simulation Game Design & Implementation

A comprehensive skill for building simulation games from concept to playable product. Distilled from real-world experience building a genetic simulation sandbox (~5,000 lines, single-file HTML/JS) with emergent evolution, combat, cooperation, academies, and god-mode disasters.

This skill applies to any agent-based simulation: genetic evolution, ecosystem dynamics, economy simulations, cellular automata, social simulations, or custom rule-based sandbox games.

## When You Need This Skill

- Building a new simulation game from scratch
- Designing agent decision-making systems that produce emergent behavior
- Implementing genetics, inheritance, or trait systems
- Creating rendering pipelines for grid or agent-based worlds
- Building UI for real-time simulation monitoring
- Debugging "why doesn't behavior X emerge?" problems
- Balancing traits, resources, or agent strategies
- Adding disasters, events, or player intervention systems

## Architecture: How to Structure a Simulation Game

### The Core Loop

Every simulation game is a loop that runs phases in strict order. The phase order matters because later phases depend on earlier results. A typical tick:

1. **Environment** — regenerate resources, advance weather/events
2. **Social/group effects** — teaching, cooperation, group bonuses (compute before decisions so agents act on current social state)
3. **Decisions** — each agent chooses an action based on its perception and state
4. **Conflict resolution** — resolve fights, competitions, or interactions
5. **Movement** — execute movement decisions
6. **Resource consumption** — eating, energy use
7. **Reproduction** — eligible agents produce offspring
8. **Status update** — aging, decay, hazard checks, death
9. **Bookkeeping** — population tracking, milestones, logging

Resist the temptation to merge phases. Keeping them separate makes debugging possible and lets you reason about cause and effect. When something unexpected emerges, you can trace it to a specific phase.

### Single-File vs. Multi-File

For simulations under ~8,000 lines, a single HTML file with embedded CSS and JS works surprisingly well. Benefits: zero build tooling, instant reload, easy to share, self-contained. Organize with clear comment banners between sections:

```
// ============================================================
// SECTION NAME
// ============================================================
```

Typical section order: Styles → HTML markup → RNG → Config → World → Entities → Genetics → Decision Engine → Events → Simulation → Renderer → UI → Input → Launch.

For larger projects, split along system boundaries (world.js, agents.js, renderer.js, etc.) but keep the phase-ordered tick loop in one place.

### Seeded Random Number Generator

Reproducibility is essential for debugging, sharing, and saved games. Use a seeded PRNG (like a mulberry32 or xoshiro implementation) and thread it through every random decision in the simulation. Never use `Math.random()` for gameplay logic.

```javascript
function mulberry32(a) {
  return function() {
    a |= 0; a = a + 0x6D2B79F5 | 0;
    var t = Math.imul(a ^ a >>> 15, 1 | a);
    t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t;
    return ((t ^ t >>> 14) >>> 0) / 4294967296;
  };
}
const rng = mulberry32(seed);
```

This lets players replay interesting simulations, share seeds with each other, and gives you deterministic reproduction of bugs.

### The CONFIG Object

Centralize every tunable number in a single CONFIG object. Never scatter magic numbers through your code. This is the single most important thing you can do for balance iteration.

```javascript
const CONFIG = {
  gridW: 80, gridH: 40,
  population: 200,
  mutationRate: 0.05,
  birthRate: 0.5,
  hungerPerRound: 1.5,
  starvationThreshold: 100,
  baseLifespan: 80,
  maxLifespan: 200,
  // ... every number that affects gameplay
};
```

When something feels "off" in playtesting, the answer is almost always a CONFIG value. If you find yourself wanting to change a number that isn't in CONFIG, move it there first.

## Designing Agents That Produce Emergence

### The Agent Entity

Keep agent state flat and transparent. Avoid deep nesting or complex inheritance hierarchies — a simple object with clearly named properties is easier to debug and balance.

Essential agent properties:
- **Identity**: id, position, lineage (parents, children)
- **Genome/traits**: the heritable characteristics that differentiate individuals
- **Vitals**: HP, hunger, energy, stress, age — the survival meters
- **State flags**: sleeping, hidden, diseased, juvenile — behavioral modifiers
- **Social state**: group memberships, cooldowns, glow/visual indicators
- **Derived stats**: computed from genome (max HP, perception range, move speed) — recalculate sparingly

### Decision Engines: Tiered Intelligence

The most powerful pattern for emergent behavior is **tiered decision-making** — agents at different capability levels make fundamentally different choices. This creates natural behavioral diversity without scripting it.

**Low tier (reactive)**: Short perception range, simple if-then logic. See food → eat. See threat → coin-flip fight or flee. See mate → reproduce. These agents are efficient and direct.

**Mid tier (aware)**: Wider perception, basic threat avoidance, can seek specific targets. They start trading immediate reward for safety.

**High tier (strategic)**: Full perception range, multi-factor evaluation, group coordination. They optimize but at a cost — more decision phases means slower action cycles.

The key insight: **higher intelligence should add constraints, not just bonuses.** Smart agents that evaluate 7 factors before eating will sometimes starve while dumb agents that just eat whatever's nearby thrive. This tension between sophistication and efficiency is what makes the simulation interesting.

### Why Traits Don't Always Dominate

If you design a trait that seems genetically advantageous but it never dominates the population, look for these structural causes:

1. **Behavioral tax**: Does the trait make agents do MORE things (evaluate threats, seek groups, lock into positions) that slow down basic survival actions?
2. **Mobility vs. clustering**: Traits that encourage clustering (intelligence, cooperation) sacrifice mate-finding if reproduction requires physical proximity.
3. **Phase-order disadvantage**: If combat resolves before cooperation benefits apply, fighters will always have a first-mover advantage.
4. **Juvenile reset**: If offspring don't inherit the parent's *effective* bonuses (group effects, accumulated social capital), every generation starts from scratch.
5. **Stress vulnerability**: If a trait's benefits degrade under stress, and the situations where the trait matters most are stressful, it's self-defeating.

These aren't bugs — they create realistic evolutionary tradeoffs. But know which tradeoffs you're creating intentionally vs. accidentally.

## Genetics & Inheritance

### Blended vs. Mendelian

For simulation games, blended inheritance (continuous [0,1] trait values) is usually better than Mendelian (dominant/recessive alleles). It's simpler to implement, easier to visualize, and produces smoother evolutionary gradients. Save Mendelian genetics for biology-education games.

### Crossover with Frequency-Dependent Bias

Pure random blending leads to boring convergence. Add frequency-dependent inheritance to keep things interesting:

- **Rare traits inherit stronger**: When a trait is under-represented, bias the blend toward the higher parent. This prevents rare but useful traits from disappearing.
- **Dominant traits regress**: When a trait is over-represented (3x+ expected), bias toward the lower parent. This prevents monoculture.

This is the most important single mechanic for maintaining genetic diversity. Without it, populations converge to a single optimal genotype and the simulation dies.

### Mutation Rates and Crisis Bursts

Base mutation should be low enough that offspring resemble parents (3-8% per gene). But during population crashes, increase both variance and macro-mutation chance dramatically. This simulates adaptive radiation — the survivors need genetic diversity to find new niches.

### Nurturing and Cultural Inheritance

Pure genetic inheritance means every generation starts from zero socially. Adding cultural inheritance (e.g., children born in an academy get an INT boost) creates compounding advantages for established communities. This is how you make institutions matter in the simulation.

## World & Terrain

### Toroidal Wrapping

Wrap the world in both dimensions (modulo arithmetic). Edge effects kill emergence — agents pile up at borders, populations split artificially. Toroidal worlds have no edges, so spatial patterns emerge naturally.

### Terrain as Selective Pressure

Each terrain type should create a different survival calculus:
- **Food availability**: Some terrains are rich, others barren
- **Movement cost**: Swamps slow movement, plains are fast
- **Safety**: Forests hide, open terrain exposes
- **Hazards**: Disease, drowning, energy drain — terrain-specific risks
- **Upgradability**: Let smart agents transform terrain (desert → farmland). This creates a feedback loop where intelligence literally reshapes the world.

### Spatial Indexing

For grids up to ~100x100, a simple sparse lookup grid (one agent per cell) with O(1) access is sufficient. Don't over-engineer spatial data structures for small-to-medium simulations.

## Events & Disasters

### Severity Scaling

Every event should scale with a severity parameter (1-10). Low severity = localized/mild, high severity = catastrophic. This gives players (or god-mode) granular control.

Design events as ecosystem shocks that test adaptation:
- **Resource events** (drought, famine): test metabolic efficiency, cooperation
- **Destruction events** (meteor, earthquake): test spatial distribution, recovery speed
- **Biological events** (plague, mutation burst): test genetic diversity, immunity
- **Climate events** (ice age, flood): test adaptability, terrain preference

### Recovery Dynamics

After a population crash, trigger temporary reproduction boosts and reduced aggression. Without these, small populations spiral to extinction too easily. The recovery mechanics create the dramatic arcs that make simulation games compelling — crash, bottleneck, adaptive radiation, new equilibrium.

## Rendering

### Canvas Character Rendering

For grid-based simulations, rendering each agent as a colored character (like '@') on a dark background is both performant and atmospheric. Color encodes the dominant trait; alpha encodes health state.

Layer your rendering:
1. **Terrain background** (cell bgColor + food tint)
2. **Event overlays** (ice, drought shimmer)
3. **Agent characters** (colored by dominant trait)
4. **VFX glows** (combat red, cooperation blue, wisdom gold)
5. **Selection highlight** (yellow border on inspected cell)

### Toggleable VFX Layers

Make visual overlays (combat heat, cooperation networks, wisdom glows) independently toggleable. Players will spend hours just watching the VFX patterns to understand what's happening. The glows ARE the game's narrative — battles flash red, villages pulse blue, academies glow gold.

Use position-based hashing for synchronized pulse effects — agents near each other should pulse together, creating visible clusters.

### Performance

Cull rendering to the visible viewport. Use typed arrays (Float32Array) for per-cell data. Decay VFX in-place (multiply by 0.75-0.85 per frame) rather than filtering arrays. For populations under 1000 on grids under 100x100, these basics are sufficient — don't optimize prematurely.

## UI for Simulation Games

### The Information Hierarchy

Players need information at multiple scales:

1. **Ambient** (always visible): Population count, day/round number, simulation speed
2. **Trends** (glanceable): Population sparkline, trait distribution bars, food availability
3. **Detail on demand** (click to inspect): Individual agent stats, genome, lineage, activity
4. **History** (scrollable): Event log, timeline milestones, cause-of-death tracking
5. **Intervention** (god mode): Event triggers, severity controls, direct manipulation

### Floating Tooltip Inspector

A floating tooltip that follows the selected agent is the single best UI element for simulation games. It creates an emotional connection — you're watching YOUR creature navigate the world. Include:
- Identity (ID, age, generation)
- Vitals (HP, hunger, energy, stress)
- Genome bars (color-coded trait values)
- Current action and decision reasoning
- Terrain info at current position

When the inspected agent dies, play a brief death animation (skull, fade, flash) before closing. This tiny detail makes death feel meaningful.

### Timeline Milestones

Log significant events with round numbers: population crashes, dominant trait shifts, notable births, terrain discoveries. Make agent IDs clickable to jump to inspection. This gives the simulation a narrative — players can scroll back and reconstruct the history of their world.

## Setup Screen & Saved Seeds

### The Setup Screen

A good setup screen lets players customize their experience without overwhelming them. Keep it focused:

- **Essential controls**: World size, population count, mutation rate, map preset. These should have sensible defaults so new players can just hit "Begin."
- **Advanced controls**: Birth rate, specific trait weights, custom seeds. Show these but don't require interaction.
- **Visual identity**: The setup screen IS the game's first impression. Give it the same visual treatment as the game itself — same color palette, same typography, same atmosphere. A utilitarian setup screen undercuts the experience.

Use custom-styled form elements (div-based dropdowns, styled range sliders) rather than native browser controls. Native `<select>` and `<input type="range">` elements can't be fully themed and will break visual cohesion, especially in dark-themed games.

### Saved Seeds System

Let players save and replay interesting simulation runs. Store seed configurations in localStorage with metadata: the seed number, map preset, and optionally a snapshot of what made that run interesting (days survived, population peak, notable events).

A "Saved Seeds" modal accessible from the setup screen lets players build a personal library of favorite simulations. Each saved seed should launch the game directly with the stored configuration — clicking a saved seed is equivalent to hitting "Begin" with those exact settings.

## Iterative Polish Workflow

### The Screenshot Loop

The fastest way to polish simulation UI:
1. Run the game, take a screenshot of the issue
2. Describe exactly what needs to change
3. Make the targeted CSS/JS edit
4. Re-check visually
5. Repeat

Don't try to design the whole UI upfront. Build the minimum, then polish through rapid visual iteration. The game will tell you what it needs.

### Consistency Passes

After adding features, do consistency passes:
- Color palette: Pick a small palette and use it everywhere
- Font sizing: 2-3 sizes max (labels, values, titles)
- Spacing: Consistent padding/margins across all panels
- Borders: Same weight and color for related elements
- Hover states: Every interactive element should respond to hover

### Custom Dropdowns and Styled Inputs

Native browser form elements (select dropdowns, range sliders) break visual cohesion in dark-themed games. Replace them with custom implementations:
- **Dropdowns**: Custom div-based dropdown with click handlers and a hidden input for the value
- **Range sliders**: Custom -webkit-slider-thumb and -webkit-slider-runnable-track styling
- Style everything to match your game's color palette

## Balance Philosophy

### Emergence Over Scripts

Never script specific outcomes. Instead, create mechanics with clear incentive structures and let the outcomes emerge. If you want cooperation to arise, make it individually advantageous (food sharing when you have excess, mutual healing). If you want territorial behavior, make resources scarce and defensible.

### The Three Questions

When a behavior isn't emerging as expected, ask:
1. **Is the incentive actually there?** Trace the math. Does high INT actually produce more surviving offspring, or do the bonuses get eaten by behavioral overhead?
2. **Is there a structural barrier?** Phase ordering, mobility constraints, juvenile vulnerability — something in the architecture may prevent the trait from expressing its advantage.
3. **Is the counter-strategy too strong?** If brutes kill thinkers before thinkers can reproduce, the selection pressure never gets to act.

### Trait Distribution Monitoring

Always display real-time trait distribution (bar chart of dominant genes). This is your primary balance diagnostic. If a trait never breaks 10%, something is structurally suppressing it. If a trait hits 60%+, its counter-strategy is too weak.

For more detailed analysis guidance, see `references/balance-analysis.md`.

## Commit Discipline

Commit after each coherent feature, not after each line change. Group related changes by theme:
- "Death animation, sidebar polish, trait color update, milestone threshold" — coherent visual polish pass
- "Setup screen overhaul: themed UI, custom dropdown, saved seeds modal" — coherent feature
- "Decision engine refactor: tiered intelligence, perception cones, threat evaluation" — coherent system

Push when a feature cluster is complete and tested. Don't push half-finished mechanics.
