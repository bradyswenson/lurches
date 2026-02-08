# Lurches: Game Design Document

**Version:** 0.1 — Initial Design  
**Platform:** Console (Swift) → iOS  
**Genre:** Genetic simulation sandbox  
**Vibe:** "Nostalgic terrarium you can smite"

---

## 1. Concept

Lurches is a genetic simulation game where the player seeds a toroidal ASCII world with creatures called Lurches, configures terrain and environmental parameters, then watches life unfold — intervening as a god when they choose. The core joy is in watching emergent behavior arise from simple rules: natural selection, genetic drift, competition, cooperation, and extinction — then throwing a wrench into it and seeing what happens.

The player is not trying to win. They're cultivating a world and observing the consequences of their design choices.

---

## 2. The World

### 2.1 Grid

- **Toroidal topology** — wraps horizontally and vertically (no edges, no corners)
- **Configurable size** — default 80×40 (fits a standard terminal), scalable up to 200×100
- **Each cell** contains exactly one terrain type and at most one Lurch

### 2.2 Terrain Types

Each terrain type has base characteristics that the player can tune before simulation start.

| Char | Terrain    | Food Regen | Move Cost | Safety | Visibility | Special                        |
|------|-----------|------------|-----------|--------|------------|--------------------------------|
| `~`  | Deep Water | 3          | 4         | 2      | High       | Drowning risk without Swim gene|
| `.`  | Plains     | 2          | 1         | 2      | High       | Exposed — easy to find, easy to be found |
| `#`  | Forest     | 4          | 2         | 4      | Low        | Good foraging, hard to spot prey/threats |
| `^`  | Mountain   | 1          | 4         | 5      | High       | Fortress terrain, scarce food  |
| `"`  | Swamp      | 3          | 3         | 1      | Low        | Rich food, high disease risk   |
| `░`  | Desert     | 0          | 2         | 3      | High       | Requires water reserves, drains energy |
| `≈`  | Shallows   | 2          | 2         | 3      | High       | Transition water/land, mild    |
| `♠`  | Ruins      | 1          | 1         | 2      | Low        | Random event spawns (good and bad) |

**Terrain stats are player-configurable** at world creation. Defaults above are starting points.

### 2.3 Food Model

- Each terrain cell has a **food level** (0–10) that regenerates each round based on the terrain's Food Regen rate, up to a cap
- When a Lurch eats, it depletes the cell's food by an amount proportional to its size/hunger
- Overpopulated areas get stripped bare → forces migration or starvation
- Some terrains support **seasonal variation** (optional advanced setting): food regen fluctuates over long cycles

### 2.4 Map Generation

Player chooses from:
- **Random** — seeded noise-based generation (Perlin-ish), player sets terrain distribution percentages
- **Biome** — clustered terrain types (continent with desert interior, forested coasts, mountain ridges)
- **Custom** — paint-your-own map (stretch goal / iOS feature)
- **Presets** — "Island", "Pangaea", "Archipelago", "Ring World", "The Crucible" (all desert with a tiny oasis)

---

## 3. The Lurches

### 3.1 Representation

Every Lurch is rendered as `@` — the classic symbol. **Color indicates their dominant genetic trait** (the gene with the highest value), preserving the 1994 original's visual language:

| Color          | ANSI Code | Dominant Trait | Rationale                        |
|----------------|-----------|----------------|----------------------------------|
| Red            | `\e[31m`  | Strength       | Aggression, power                |
| Blue           | `\e[34m`  | Intelligence   | Calm, calculating                |
| Green          | `\e[32m`  | Vitality       | Life force, endurance            |
| Magenta        | `\e[35m`  | Fertility      | Reproductive drive               |
| Cyan           | `\e[36m`  | Speed          | Quick, electric                  |
| Yellow         | `\e[33m`  | Adaptability   | Versatile, shifting              |
| White          | `\e[37m`  | Perception     | Alert, aware                     |
| Bright White   | `\e[97m`  | Size           | Imposing, dominant               |

**Brightness/style indicates health state:**
- **Bold/Bright** — healthy, well-fed
- **Normal** — moderate condition
- **Dim** — hungry, tired, or injured
- **Blinking** — critical (near death)
- **Inverse** — sleeping (stands out as inactive)

When two genes are tied or very close (within 0.05), the Lurch flickers between colors on alternating rounds — visually marking it as a hybrid/generalist.

On the grid, you can immediately read the population: a cluster of red `@` symbols means a warrior colony; a scattering of blue among green means thinkers surviving among the hardy. When a lineage starts dominating, the map shifts color — that's natural selection made visible.

### 3.2 Genetic Attributes

Every Lurch has a **genome** — a set of heritable traits, each represented as a float (0.0–1.0) that maps to an effective stat range.

| Gene          | Effect                                                        | Tradeoff                        |
|---------------|---------------------------------------------------------------|---------------------------------|
| Vitality      | Max HP, starvation resistance, lifespan                       | Higher metabolism (needs more food) |
| Speed         | Tiles moved per round, flee success rate                      | Burns more energy per move      |
| Strength      | Combat damage, carrying capacity                              | Higher food requirement         |
| Intelligence  | Decision quality, pathfinding range, threat assessment        | Slower reproduction (gestation) |
| Fertility     | Reproduction success rate, litter size potential               | Offspring start weaker          |
| Adaptability  | Resistance to disease, temperature, terrain penalties          | Jack of all trades, master of none |
| Perception    | Detection range for food, threats, mates                       | Sensory overload? (stress in crowded areas) |
| Size          | HP bonus, combat advantage, intimidation                       | Needs more food, easier to spot |

### 3.3 Derived/Dynamic Stats (Not Heritable)

| Stat     | Description                                    |
|----------|------------------------------------------------|
| Hunger   | 0–100, depletes each round, eat to replenish   |
| Energy   | 0–100, depletes from actions, sleep to replenish|
| HP       | Based on Vitality × Size, heals slowly          |
| Age      | Increments each round, max lifespan from Vitality|
| Stress   | Rises from threats, hunger, crowding; affects decisions |

### 3.4 Initial Seeding

The player configures:
- **Population count** — how many Lurches start (e.g., 10–100)
- **Stat distribution** — set mean and variance for each gene
  - Example: "High strength, low intelligence, moderate spread" → warrior species
  - Example: "All stats moderate, high variance" → diverse starting population
- **Placement** — random, clustered (tribe), or ring (spread evenly around the torus)

The initial population is generated using these parameters with random variation — no two Lurches are identical.

---

## 4. Genetics & Reproduction

### 4.1 Sexual Reproduction

- Two Lurches must be **adjacent** (8-directional) and both choose the Reproduce action
- Both must meet minimum thresholds: Energy > 30, Hunger < 70, Age > juvenile threshold
- **Mate selection** — higher-INT Lurches prefer mates with complementary or high stats; low-INT Lurches mate with whoever's adjacent
- Success probability based on average Fertility of both parents

### 4.2 Inheritance

Each offspring gene is determined by:

```
offspring_gene = blend(parent_a_gene, parent_b_gene) + mutation
```

Where:
- `blend` — weighted random between the two parent values (not just average — creates more variance)
- `mutation` — small random offset, normally distributed, magnitude controlled by global **Mutation Rate** setting
- Rare **macro-mutations** — low probability of a gene jumping dramatically (this is how you get `*` mutant Lurches)

### 4.3 Offspring

- Placed on an adjacent empty cell (if none available, reproduction fails)
- Start as **juveniles** — reduced stats for N rounds, cannot reproduce
- Inherit a blended ASCII character from parents, or get a new one if a macro-mutation occurs

### 4.4 Genetic Drift Over Time

With these mechanics, the population will naturally:
- Speciate if geographically separated (mountain range divides population → two lineages diverge)
- Converge if environmental pressure favors specific traits
- Go extinct if poorly adapted to changing conditions
- Produce occasional mutant outliers that either die fast or found new lineages

---

## 5. Decision Engine (Lurch AI)

### 5.1 Available Actions

Each round, every Lurch picks exactly one action:

| Action     | Cost       | Effect                                         |
|------------|------------|-------------------------------------------------|
| Eat        | 1 Energy   | Consume food from current cell, reduce Hunger   |
| Move       | Speed-based| Move 1–N cells toward a target                  |
| Fight      | 10 Energy  | Attack adjacent Lurch, damage based on Strength |
| Sleep      | 0          | Restore Energy, slightly restore HP, vulnerable |
| Reproduce  | 20 Energy  | Attempt to mate with adjacent Lurch             |
| Hide       | 2 Energy   | Reduce visibility, avoid fights                 |
| Do Nothing | 0          | Conserve energy, slight hunger increase          |

### 5.2 Decision Quality (Intelligence)

Intelligence doesn't just make Lurches "better" — it changes HOW they decide:

- **INT 0.0–0.2 (Instinctive):** Purely reactive. If hungry, eat. If threatened, fight or flee (coin flip). Random movement. Mates with anyone adjacent.
- **INT 0.3–0.5 (Aware):** Can assess immediate surroundings. Moves toward visible food. Flees from stronger opponents. Prefers hiding over fighting when weak.
- **INT 0.6–0.8 (Strategic):** Pathfinds toward food-rich areas. Evaluates mate quality. Retreats to safe terrain when injured. Stockpiles energy before reproducing.
- **INT 0.9–1.0 (Brilliant):** Plans multiple rounds ahead. Avoids traps (swamp disease, desert without reserves). Seeks optimal mates. May form rudimentary "territorial" behavior — returns to known-good cells.

### 5.3 Stress & Decision Corruption

High stress degrades effective Intelligence:
- A brilliant Lurch at max stress behaves like an instinctive one
- Stress sources: hunger > 70, adjacent threats, HP < 30%, crowding
- Stress relief: eating, sleeping, being in safe terrain, solitude

### 5.4 Kin Warning (Emergent Altruism)

Lurches with **INT ≥ 0.6** can emit a **danger signal** when they detect a threat (aggressive adjacent Lurch, disease, low food). The signal propagates to all Lurches within Perception range that share genetic similarity (>70% genome overlap — i.e., relatives).

Warned Lurches get a temporary decision bonus:
- Increased likelihood to flee or hide
- Avoid moving toward the danger source
- Does NOT override their own decision engine — it's a bias, not a command

This creates emergent kin selection: smart Lurches protect their lineage, and family groups that cluster together survive better — but clustering also means competing for food. A natural tension.

Low-INT Lurches ignore warnings entirely. They blunder into danger, but they also don't waste energy signaling — which can be an advantage in resource-scarce environments.

---

## 6. Combat

- Initiated when a Lurch chooses Fight targeting an adjacent Lurch
- **Damage** = attacker Strength × (0.5 + random(0.5)) — some variance
- **Defense** = defender Size × 0.3 + terrain Safety bonus
- **Net damage** = max(0, Damage - Defense) applied to defender HP
- **Flee check** — defender can attempt to flee next round (Speed vs attacker Speed)
- **Death** — HP reaches 0, Lurch is removed, cell becomes empty

---

## 7. Death & Lifecycle

Lurches can die from:

| Cause        | Condition                                    |
|-------------|----------------------------------------------|
| Starvation   | Hunger reaches 100                           |
| Combat       | HP reaches 0 from another Lurch's attack     |
| Old Age      | Age exceeds lifespan (Vitality-based)        |
| Disease      | Contracted in swamp or from adjacent sick Lurch |
| Drowning     | In deep water without Swim adaptation (Adaptability check) |
| Exposure     | Extended time in desert without energy reserves |
| Disaster     | Player-triggered event (meteor, earthquake, etc.) |

When a Lurch dies, the cell simply becomes empty and available for movement or reproduction.

---

## 8. God Mode: Player Interventions

The player can pause the simulation at any time and trigger interventions. These are the tools of chaos:

### 8.1 Environmental Events

| Event          | Effect                                                    | Scope           |
|----------------|-----------------------------------------------------------|-----------------|
| Drought        | Food regen halved globally for N rounds                   | Global          |
| Flood          | Water tiles expand by 1 cell ring for N rounds            | Global          |
| Wildfire       | Forest tiles burn to plains in a spreading radius         | Regional        |
| Earthquake     | Terrain type scrambled in a radius, mountains may form/collapse | Regional   |
| Meteor         | Destroys all life and terrain in blast radius, creates crater | Point        |
| Ice Age        | All food regen reduced, desert becomes tundra (safe but barren) | Global     |
| Fertile Season | Food regen doubled globally for N rounds                  | Global          |

### 8.2 Biological Events

| Event            | Effect                                                   |
|------------------|----------------------------------------------------------|
| Virus            | Spreads between adjacent Lurches, varying lethality, some gain immunity |
| Mutation Burst   | Mutation rate spikes for N rounds — wild offspring        |
| Fertility Wave   | All Lurches get temporary fertility boost                 |
| Genetic Bottleneck| Kill N% of population randomly — simulates catastrophe   |
| Plague           | Targets Lurches with low Adaptability, spreads fast       |
| Rejuvenation     | All living Lurches gain temporary Vitality boost          |

### 8.3 Direct Manipulation

- **Place food** on any cell
- **Place/remove terrain** — terraform
- **Smite** a specific Lurch (lightning bolt)
- **Bless** a specific Lurch (heal, feed, stat boost)
- **Teleport** a Lurch to any cell
- **Build wall** — place impassable terrain to divide populations (force speciation!)

---

## 9. Display & UI (Console)

### 9.1 Main View

```
╔══════════════════════════════════════════════════════╗
║  LURCHES                          Round: 247  ▶ x2  ║
╠══════════════════════════════════════════════════════╣
║ ~~~..##^^""^^##..~~~..##^^""^^##..~~~..##^^""^^##..  ║
║ ~~...#^^^""^^^#...~~..@#^^^""^^^#...~~...#^^^""^^^#  ║
║ ~....##^^@"^^##....~....##^^""^^##....~....##^^""^^  ║
║ ......####@####..........#########..........########  ║
║ .......▒▒▒▒▒..@....▒▒▒▒▒░░░░░▒▒▒▒▒..▒▒▒▒▒░░░░░▒▒  ║
║ ..▒▒▒▒▒░░@░░▒▒▒▒▒..▒▒▒▒▒░░░░░▒▒▒▒▒..▒▒▒▒▒░░░░░▒▒  ║
║ ~~...#^^^""^^^#...~~...#@^^""^^^#...~~...#^^^""^^^#  ║
║ ~~~..##^^""^^##..~~~..##^^""^^##..~~~..##^^""^^##..  ║
╠══════════════════════════════════════════════════════╣
║ Pop: 23 │ Avg Age: 34 │ Births: 89 │ Deaths: 71     ║
║ Food Avail: 67% │ Dominant Trait: Strength (Red)     ║
╠══════════════════════════════════════════════════════╣
║ [SPACE] Pause  [+/-] Speed  [G] God Mode  [S] Stats ║
║ [F] Follow Lurch  [H] History  [T] Timeline  [Q] Quit║
╚══════════════════════════════════════════════════════╝
```

*(In the actual console, each `@` would be ANSI-colored — red for Strength-dominant, blue for Intelligence-dominant, etc.)*

### 9.2 Info Panels (Toggle)

**Lurch Inspector** (select a Lurch with arrow keys or click in iOS):
```
┌─ LURCH #42 "?" ──────────────────┐
│ Age: 67/120  HP: 34/80           │
│ Hunger: 45  Energy: 72  Stress: 23│
│                                   │
│ VIT: ████████░░ 0.82              │
│ SPD: ███░░░░░░░ 0.31              │
│ STR: █████░░░░░ 0.52              │
│ INT: ███████░░░ 0.74              │
│ FER: ██░░░░░░░░ 0.21              │
│ ADP: ██████░░░░ 0.63              │
│ PER: ████░░░░░░ 0.41              │
│ SIZ: ██████░░░░ 0.58              │
│                                   │
│ Parents: #12 × #7                 │
│ Children: #56, #61, #63           │
│ Last Action: Move → Forest        │
│ Next Likely: Eat (hungry)         │
│ Terrain: Forest (#)               │
└───────────────────────────────────┘
```

**Population Graph** (sparkline style in console):
```
Population over time:
10 ▁▂▃▅▆█▇▆▅▃▂▃▅▇████▇▆▅▃▁▁▂▃▅▆▇██▇▅ 23
   Round 1                        Round 247
```

### 9.3 Event Log

```
[R247] Lurch #42 ate in forest (hunger: 45→20)
[R247] Lurch #18 attacked Lurch #31 (12 dmg)
[R246] Lurch #31 died (combat, age 45)
[R246] Lurch #12 × #7 → offspring #63 born
[R245] DROUGHT began (50 rounds remaining)
```

### 9.4 God Mode Menu

```
╔══ GOD MODE ═══════════════════╗
║ [1] Drought      [6] Meteor   ║
║ [2] Flood        [7] Virus    ║
║ [3] Wildfire     [8] Plague   ║
║ [4] Earthquake   [9] Mutate   ║
║ [5] Ice Age      [0] Fertile  ║
║                                ║
║ [P] Place Food   [W] Wall     ║
║ [L] Smite Lurch  [B] Bless    ║
║ [R] Remove Terrain             ║
║ [ESC] Exit God Mode            ║
╚════════════════════════════════╝
```

---

## 10. Simulation Flow

```
1. SETUP PHASE
   └── Player configures: map size, terrain, Lurch population, genetic parameters

2. SIMULATION LOOP (each round):
   a. Environment Update
      ├── Food regeneration per cell
      ├── Active event effects (drought, flood, etc.)
      └── Disease spread checks
   
   b. Lurch Decision Phase (all Lurches simultaneously plan)
      ├── Each Lurch evaluates state (hunger, energy, HP, surroundings)
      ├── Intelligence-weighted decision tree selects action
      └── Conflicts queued (two Lurches want same cell, fight targeting)
   
   c. Action Resolution Phase (resolve in order)
      ├── Fights resolve first (determines who lives)
      ├── Movement resolves (collision = bounce back or fight)
      ├── Eating resolves
      ├── Reproduction resolves
      └── Sleep/Hide/Nothing resolves
   
   d. Status Update
      ├── Hunger increments
      ├── Energy adjusts
      ├── Age increments
      ├── Death checks (starvation, old age, disease, exposure)
      └── Corpse food drops
   
   e. Display Update
      └── Render grid, update stats, log events

3. GOD MODE (player can pause and intervene at any point)
```

---

## 11. Configuration & Presets

### 11.1 World Presets

| Preset       | Description                                           |
|-------------|-------------------------------------------------------|
| Eden         | Lush forest/plains, abundant food, mild — watch them thrive |
| The Crucible | Mostly desert with tiny oasis — brutal competition    |
| Archipelago  | Islands of land in deep water — isolated populations diverge |
| Ring World   | Habitable ring around a deadly center                 |
| Pangaea      | One big continent, diverse biomes                     |
| Waterworld   | Mostly water with scattered land — swim or die        |

### 11.2 Lurch Presets

| Preset       | Description                                           |
|-------------|-------------------------------------------------------|
| Balanced     | Moderate stats, moderate variance                     |
| Warriors     | High STR/VIT, low INT/FER                             |
| Thinkers     | High INT/PER, low STR/SPD                             |
| Breeders     | High FER/ADP, low everything else                     |
| Chaos        | All stats random with maximum variance                |
| Specialists  | Two subpopulations with opposite stat profiles        |

---

## 12. Stretch Goals & Future Features

### v1.1 — Polish
- [ ] **Save/Load** — snapshot simulation state
- [ ] **Speed control refinement** — round-by-round step, 2x, 5x, 10x, max

### v2 — Depth
- [ ] **Family tree viewer** — visual lineage graph
- [ ] **Species tracker** — when populations diverge enough genetically, classify as new species
- [ ] **Challenge scenarios** — "Keep 5 alive for 200 rounds on The Crucible", etc.
- [ ] **Seasonal cycles** — automated food regen fluctuation over long periods
- [ ] **Tool use** — very high-INT Lurches can reinforce terrain or build shelter
- [ ] **Multi-species mode** — seed two species with different base genomes
- [ ] **Seed sharing** — export a compact seed so others can run the same starting conditions
- [ ] **Multi-Lurch cells** — allow stacking, changes population dynamics entirely

### v3 — iOS
- [ ] **Touch to inspect** — tap a Lurch, pinch to zoom, swipe to scroll
- [ ] **Haptic feedback** — rumble on extinction events, earthquakes, deaths
- [ ] **Sound** — ambient generative audio that responds to simulation state
- [ ] **Custom map painter** — draw your own terrain with touch
- [ ] **Achievements** — "Survive 1000 rounds", "Population hit 100", "Single Lurch lived 200 rounds"
- [ ] **Lurch naming** — auto-generated names ("Grak the Strong", "Nimble Pip")
- [ ] **Time-lapse replay** — rewatch a simulation at high speed

---

## 13. v1 Scope — What We're Building

To keep us focused, here's exactly what's in and out for the first playable version:

### In ✓
- Toroidal grid with configurable size and all 8 terrain types
- Seeded map generation (random + presets)
- Lurches as `@` symbols, color-coded by dominant trait
- Full genetic system: 8 genes, sexual reproduction, inheritance with mutation
- Intelligence-tiered decision engine (4 tiers)
- Stress system affecting decisions
- Kin warning for smart Lurches
- Combat, eating, movement, sleep, hide, reproduce, do nothing
- Death from all 7 causes
- God mode: all environmental events, biological events, direct manipulation
- Event log
- Population stats bar
- Lurch inspector (select and view details)
- Population sparkline graph
- Keyboard controls, pause/resume, speed control
- Seeded RNG for reproducibility

### Out ✗ (future versions)
- Challenge scenarios / win conditions
- Save/Load
- Multi-species
- Tool use / building
- Predators / NPC creatures
- iOS port
- Sound / haptics
- Family tree viewer
- Achievements
- Lurch naming

---

## 14. Technical Architecture (Swift)

### 13.1 Module Structure

```
Lurches/
├── Core/
│   ├── World.swift          — Grid, terrain, toroidal math
│   ├── Lurch.swift          — Creature model, genome
│   ├── Genetics.swift       — Inheritance, mutation, crossover
│   ├── DecisionEngine.swift — AI behavior per intelligence tier
│   ├── Combat.swift         — Fight resolution
│   ├── Simulation.swift     — Main loop, round processing
│   └── Events.swift         — God mode events, environmental effects
├── Console/
│   ├── Renderer.swift       — ASCII rendering, ANSI colors
│   ├── Input.swift          — Keyboard handling
│   └── main.swift           — Entry point
├── Shared/
│   ├── Config.swift         — All tuneable parameters
│   ├── RNG.swift            — Seeded random number generator
│   └── History.swift        — Event log, statistics tracking
└── (Future) iOS/
    ├── GameView.swift       — SwiftUI with monospace font rendering
    └── Controls.swift       — Touch-based god mode
```

### 13.2 Key Design Decisions

- **Seeded RNG** — every simulation is reproducible given the same seed. Players can share seeds.
- **Core module is platform-agnostic** — no UI code in Core. Console and iOS are just different renderers.
- **ECS-lite** — Lurches are structs with component-like properties, processed by system-like functions. Not a full ECS but inspired by it.
- **Simultaneous decisions, sequential resolution** — all Lurches "think" at once, then actions resolve in priority order. This prevents turn-order advantages.

---

## 15. Open Questions

1. ~~Win condition~~ — **Resolved: Pure sandbox for v1.**
2. ~~Inter-Lurch communication~~ — **Resolved: Yes.** Kin warning system (see §5.4).
3. **Tool use / building** — Deferred to v2.
4. ~~Predators~~ — **Resolved: No predators.**
5. **Multi-species** — Deferred.
6. ~~Seasonal cycles~~ — **Resolved: Not in v1.** God mode events serve this purpose for now.
7. ~~Population cap~~ — **Resolved: Natural cap.** One Lurch per cell, so the grid size IS the cap. Multi-Lurch cells could be explored later.
8. ~~Death animation~~ — **Resolved: Yes.** Brief flash/blink when a Lurch dies for visual feedback.
9. **Seed sharing** — Undecided. Seeded RNG is in v1 for reproducibility, but the sharing format/UX is TBD.
10. **Speed controls / time travel** — Ideas from playtesting:
    - "Skip to next event" button that fast-forwards until something interesting happens (population milestone, trait flip, death spike)
    - "Alert me when population drops below X" watchpoint system
    - Slider-based speed control (continuous instead of discrete levels)
    - "Jump to round N" for replaying seeded simulations
    - Configurable auto-pause triggers (e.g., pause when dominant trait changes, when population crosses threshold)
