# LURCHES

A genetic simulation sandbox with an ASCII attitude

_In the summer of 1992, a friend and I, between driveway basketball and NES, wrote Pascal games on a 486 with 4 MB RAM and a dial-up modem. One of the games we wrote was Lurches, and now Claude has helped me manifest the nostalgia. Enjoy!_  

**[Play it live at lurches.net](https://lurches.net)**

Seed a toroidal world with creatures called Lurches. Watch them eat, fight, cooperate, teach, form academies, form war bands, and evolve — then throw a meteor at them and see what survives.

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

**Combat** — Attack multiplier 30, defense multiplier 20 (1.5:1 ratio). Evasion based on INT + SPD + PER (up to ~55% dodge chance). High STR/SIZ defenders counter-strike. Fight costs 15 energy; attacker takes 18 stress. INT lurches get solo defense from intelligence and can play dead to survive lethal hits (up to 50% chance). STR infighting kicks in when warriors dominate >25% of the population.

**Cooperation** — Cooperative defense is percentage-based (15% per ally, max 60%). Cooperator fertility bonus +25% when near other cooperators. Academy fertility can reach +75% for the parent and +60% from the mate. Academy members strongly resist crowding penalties (85%).

**Food & Metabolism** — Smart (INT) and fast (SPD) foragers gain +10% food efficiency. VIT reduces hunger accumulation by 10%. Teaching grants +30% food efficiency. Food regenerates at 35% per day. Academy members farm a wider area (3 tiles) with boosted food production.

**Genetics** — Fertility tapers from 60% to 90% of max age. Inheritance uses frequency-dependent selection with dominance penalty at 3x expected frequency. Below 200 population: extended mating range. Below 150: fertility boost (up to ~2.3× at pop 30), reduced repro cooldown, and migration pull toward population center. Smart parents (INT > 0.4) nurture offspring with an INT boost at birth, stronger in academies.

**Stress** — INT reduces incoming stress by up to 20%. PER-heavy lurches experience crowd stress penalty.

**World** — Default starting population 200 at 1.6x birth rate. Map generation uses normalized noise for consistent terrain variety.

## Emergent behavior

The simulation produces social structures from simple rules:

**Cooperation** — Lurches with high INT + PER cooperate instead of fight. When they cluster together, they farm nearby tiles, defend each other (15% per ally), teach more effectively, and gain fertility bonuses. Cooperators stay put rather than wander, building self-sustaining communities.

**Academies** — INT lurches (≥ 0.3) near other INT lurches form academies, visible as a golden glow. Academy members lock down — they eat, reproduce, and hold position but almost never leave. They farm wider, resist crowding, breed faster, and nurture smarter offspring. Academies cap at 12 members; overflow disperses to seed new academies. Edification slowly boosts the INT gene of nearby INT-leaning lurches, spreading intelligence through education. Children born in academies inherit significant INT boosts from smart parents.

**War bands** — Lurches with high STR + SIZ are aggressive. When brutes cluster near other brutes, they get a pack bonus: more damage per ally, bigger spoils from kills. Counter-strikes trigger when defenders are sufficiently strong. They naturally form raiding parties. When STR dominates >25% of the population, infighting escalates — warriors turn on each other.

**INT survival toolkit** — Smart lurches have layered defenses: solo defense bonus from intelligence, up to 55% evasion, death escape (playing dead to survive lethal hits), INT deterrence (looking too dangerous to attack), and a long-range beacon (up to 20 tiles) for finding other INT lurches across the map.

**Companion-seeking & migration** — When food is scarce, lurches group up for survival. Smarter lurches do it sooner. At low population, all lurches feel a migration pull toward the population center — high INT and PER lurches feel it strongest, drifting together while dumb brutes mostly stumble.

**Agriculture effect** — All lurches boost food regrowth on nearby cells just by being present. Cooperators farm more effectively. Groups of 2+ burn hunger 10-20% slower — the settled efficiency of not needing to wander. This creates a positive feedback loop: grouping → more food → less wandering → more grouping.

**Recovery mechanics** — Below 150 population, scan range extends (up to +4 cells), aggression dampens, repro cooldowns shorten, fertility spikes, and even non-cooperators develop group stickiness. These layered safety nets create boom-bust-recovery cycles instead of terminal extinction spirals.

**The tension** — Cooperators create food-rich territory. War bands create the force to take it. Academies create intellectual enclaves that spread INT through education and reproduction. The three strategies coexist, compete, and trade dominance over thousands of days.

## God Mode

Press `G` to intervene. Drop meteors, trigger plagues, start ice ages, trigger a fertile season to help a struggling population recover, or bless your favorite Lurch. The severity slider goes from "gentle nudge" (1) to "apocalyptic" (10).

## Deeper reading

- **[Genetics & Evolution](docs/genetics.md)** — Inheritance, mutation, frequency-dependent selection, fertility, specialization penalty
- **[Behavior & Intelligence](docs/behavior.md)** — Decision tiers, teaching, discovery, stress, kin warning
- **[Combat & Cooperation](docs/combat-and-cooperation.md)** — Fighting, war bands, cooperative defense, academies, food cultivation
- **[Terrain & World](docs/terrain.md)** — Map presets, terrain types, food model, enhanced terrain

## Architecture

The entire game is a single HTML file (`lurches.html`) — no build step, no dependencies, no framework. Canvas rendering, seeded RNG, and about 4,300 lines of vanilla JS.

Deployed to [Fly.io](https://fly.io) via nginx in a Docker container.

## Controls

| Key | Action |
|-----|--------|
| `Space` | Pause / Resume |
| `+ / -` | Speed (5 levels) |
| `G` | God Mode |
| `?` | Help guide |
| `F` | Follow a Lurch |
| `N` | Step one day |
| `Arrow keys` | Scroll |
| Click | Inspect a Lurch |

## License

MIT
