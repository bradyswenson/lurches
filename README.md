# LURCHES

A genetic simulation sandbox with an ASCII attitude

_In the summer of 1992, two boys, between playing basketball and NES, wrote Pascal games on a 486 with 4 MB RAM and a dial-up modem. One of the games we wrote was Lurches, and now Claudue helped me manifest the nostalgia. Enjoy!_  

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
| **VIT** | Disease resistance, passive healing, cold tolerance, 10% slower hunger | Metabolism |
| **SPD** | Movement speed, flee success, +10% food efficiency from foraging | Burns energy |
| **STR** | Attack damage, fight initiation, counter-strike trigger | Hungry |
| **INT** | Decision quality, teaching, discovery, stress reduction, +10% food efficiency from foraging | No combat bonus |
| **ADP** | Terrain resistance, environmental adaptation | Highest metabolism |
| **PER** | Scan range, threat detection, cooperation, +10% dodge chance | Crowd stress |
| **SIZ** | Max HP, combat power, counter-strike trigger | Needs the most food |

A Lurch's color on the grid shows its dominant gene — the one with the highest value.

## Balance parameters

**Combat** — Attack multiplier 30, defense multiplier 20 (1.5:1 ratio). Evasion based on INT + SPD + PER (up to ~45% dodge chance). High STR/SIZ defenders counter-strike. Fight costs 15 energy; attacker takes 18 stress.

**Cooperation** — Cooperative defense is percentage-based (15% per ally, max 60%). Settlement fertility bonus +25% for cooperators near cooperators.

**Food & Metabolism** — Smart (INT) and fast (SPD) foragers gain +10% food efficiency. VIT reduces hunger accumulation by 10%. Teaching grants +30% food efficiency. Food regenerates at 35% per round.

**Genetics** — Fertility tapers from 60% to 90% of max age. Inheritance uses frequency-dependent selection with dominance penalty at 3x expected frequency. Below 150 population, lurches get fertility boost and extended mating range.

**Stress** — INT reduces incoming stress by up to 20%. PER-heavy lurches experience crowd stress penalty.

**World** — Default starting population 60. Map generation uses normalized noise for consistent terrain variety.

## Emergent behavior

The simulation produces social structures from simple rules:

**Settlements** — Lurches with high INT + PER cooperate instead of fight. When they cluster together, they farm nearby tiles, defend each other (15% per ally), teach more effectively, and gain fertility bonuses. They settle in place and build self-sustaining communities.

**War bands** — Lurches with high STR + SIZ are aggressive. When brutes cluster near other brutes, they get a pack bonus: more damage per ally, bigger spoils from kills. Counter-strikes trigger when defenders are sufficiently strong. They naturally form raiding parties.

**Companion-seeking** — When food is scarce, lurches group up for survival. Smarter lurches do it sooner, instinctively seeking safety in numbers.

**The tension** — Settlements create food-rich territory. War bands create the force to take it. The two strategies coexist, compete, and trade dominance over thousands of rounds.

## God Mode

Press `G` to intervene. Drop meteors, trigger plagues, start ice ages, trigger a fertile season to help a struggling population recover, or bless your favorite Lurch. The severity slider goes from "gentle nudge" (1) to "apocalyptic" (10).

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
