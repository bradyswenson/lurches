# LURCHES

*A genetic simulation sandbox with an ASCII attitude.*

**[Play it live at lurches.net](https://lurches.net)**

Seed a toroidal world with creatures called Lurches. Watch them eat, fight, cooperate, teach, build settlements, form war bands, and evolve — then throw a meteor at them and see what survives.

## What is this?

Lurches is a single-file HTML/JS simulation where 7 heritable genes drive emergent behavior across an ASCII grid. Creatures make decisions based on their intelligence, form social structures based on their personality, and pass their genes to the next generation through natural selection.

There's no goal. You're cultivating a world and observing the consequences — or playing god when things get too peaceful.

## Quick start

Open `lurches.html` in any browser. Pick a map, set the population, and hit **Begin Simulation**. Press `Space` to start, `+/-` to change speed, and `G` for God Mode.

Or just visit **[lurches.net](https://lurches.net)**.

## The 7 genes

Every Lurch carries 7 genes (0.0 to 1.0) that determine what it is, what it does, and how long it lasts:

| Gene | What it does | The cost |
|------|-------------|----------|
| **VIT** | Disease resistance, passive healing, cold tolerance | Metabolism |
| **SPD** | Movement speed, flee success | Burns energy |
| **STR** | Attack damage, fight initiation | Hungry |
| **INT** | Decision quality, teaching, discovery | No combat bonus |
| **ADP** | Terrain resistance, environmental adaptation | Highest metabolism |
| **PER** | Scan range, threat detection, cooperation | Crowd stress |
| **SIZ** | Max HP, combat power | Needs the most food |

A Lurch's color on the grid shows its dominant gene — the one with the highest value.

## Emergent behavior

The simulation produces social structures from simple rules:

**Settlements** — Lurches with high INT + PER cooperate instead of fight. When they cluster together, they farm nearby tiles, defend each other, teach more effectively, and resist crowding stress. They settle in place and build self-sustaining communities.

**War bands** — Lurches with high STR + SIZ are aggressive. When brutes cluster near other brutes, they get a pack bonus: more damage per ally, bigger spoils from kills. They naturally form raiding parties.

**The tension** — Settlements create food-rich territory. War bands create the force to take it. The two strategies coexist, compete, and trade dominance over thousands of rounds.

## God Mode

Press `G` to intervene. Drop meteors, trigger plagues, start ice ages, or bless your favorite Lurch. The severity slider goes from "gentle nudge" (1) to "apocalyptic" (10).

## Deeper reading

- **[Genetics & Evolution](docs/genetics.md)** — Inheritance, mutation, frequency-dependent selection, fertility, specialization penalty
- **[Behavior & Intelligence](docs/behavior.md)** — Decision tiers, teaching, discovery, stress, kin warning
- **[Combat & Cooperation](docs/combat-and-cooperation.md)** — Fighting, war bands, cooperative defense, settlements, food cultivation
- **[Terrain & World](docs/terrain.md)** — Map presets, terrain types, food model, enhanced terrain

## Architecture

The entire game is a single HTML file (`lurches.html`) — no build step, no dependencies, no framework. Canvas rendering, seeded RNG, and about 3,500 lines of vanilla JS.

Deployed to [Fly.io](https://fly.io) via nginx in a Docker container.

## Controls

| Key | Action |
|-----|--------|
| `Space` | Pause / Resume |
| `+ / -` | Speed (5 levels) |
| `G` | God Mode |
| `?` | Help guide |
| `F` | Follow a Lurch |
| `N` | Step one round |
| `Arrow keys` | Scroll |
| Click | Inspect a Lurch |

## License

MIT
