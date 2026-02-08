# Terrain & World

## World topology

The world is a toroidal grid — it wraps in all directions. There are no edges, no corners, no boundaries. A Lurch walking off the right side appears on the left. This prevents edge effects and means every cell is equally connected to the rest of the world.

Default size is 80×40 cells, configurable at world creation.

## Terrain types

| Char | Terrain | Food regen | Move cost | Safety | Special |
|------|---------|-----------|-----------|--------|---------|
| `~` | Deep Water | 3 | 4 | 2 | Drowning risk — Lurches without enough ADP may drown |
| `.` | Plains | 2 | 1 | 2 | Fast movement, low cover — easy to find food and be found |
| `#` | Forest | 4 | 2 | 4 | Good foraging, good hiding — the workhorse terrain |
| `^` | Mountain | 1 | 4 | 5 | Fortress terrain — very safe but slow and food-scarce |
| `"` | Swamp | 3 | 3 | 1 | Rich food but disease risk — VIT resists swamp disease |
| `░` | Desert | 0 | 2 | 3 | No food, drains energy — deadly without ADP |
| `≈` | Shallows | 2 | 2 | 3 | Transition between water and land, mild and unremarkable |
| `♠` | Ruins | 1 | 1 | 2 | Mysterious remnants — low food, easy movement |

### Enhanced terrain (discovery only)

These terrain types can only be created through the discovery mechanic — they don't appear in initial map generation:

| Char | Terrain | Food regen | Move cost | Safety | Special |
|------|---------|-----------|-----------|--------|---------|
| `∞` | Fertile Plains | 5 | 1 | 3 | Rich farmland with 1.5x food cap — the best food source |
| `♣` | Lush Forest | 6 | 2 | 5 | Shelter — provides HP regeneration and stress relief, 1.5x food cap |

Enhanced terrain is valuable but impermanent — environmental disasters (earthquakes, meteors, floods) reset it back to base types.

## Food model

Each cell has a food level from 0 to 10 (15 for enhanced terrain). Food regenerates each round based on the terrain's regen rate, scaled by 0.3.

When a Lurch eats, it depletes cell food proportional to hunger reduction (up to 25 hunger per eat). Overpopulated areas get stripped bare quickly, forcing migration or starvation.

### Food cultivation

Cooperator clusters boost food regrowth on nearby tiles. Each cooperator within range 2 adds a bonus proportional to their cooperation score (×0.15), capped at 2x total regrowth. This is the farming mechanic — settlements produce more food than the terrain would naturally support.

The cultivation bonus stacks with terrain's base regen and any event multipliers (like post-drought recovery).

## Environmental hazards

### Drowning

Deep water cells have a 30% drowning chance per round for Lurches without sufficient ADP. Lurches can cross shallows safely.

### Disease

Swamp cells have a disease chance each round. VIT is the primary resistance (`sqrt(VIT) × 0.7`). Diseased Lurches take damage each round, reduced by VIT. The immune system (VIT × 0.5) burns through disease turns faster. Disease also spreads between adjacent Lurches — plagues can devastate dense populations.

### Cold

Cold damage (from ice age events) is resisted by VIT (0.5), SIZ (0.3), and ADP (0.2). Big, tough, adaptable Lurches weather the cold. Small, frail ones freeze.

### Desert

Desert cells drain energy each round. Lurches with low energy can't act effectively and eventually die from exhaustion.

## Map presets

### Random (default)
Procedurally generated terrain using seeded noise. Different every time (unless you set a seed). Generally produces a good mix of biomes with natural-looking coastlines and terrain transitions.

### Pangaea
One large continent surrounded by water. Interior is varied terrain — plains, forests, mountains, some desert. The water boundary creates natural population pressure. Good for watching continental evolution.

### Eden
Lush and abundant. Heavy on forests and plains, light on hazards. High food availability means populations boom quickly and competition becomes the main pressure. Good for watching social dynamics at high density.

### The Crucible
Almost entirely desert with a tiny oasis of habitable terrain. Extreme selection pressure — only the most adaptable survive. Populations are small and every resource matters. The harshest preset.

### Archipelago
Islands of habitable terrain in a sea of deep water. Populations evolve independently on each island, creating natural genetic divergence. Interesting for watching parallel evolution and seeing how different gene profiles emerge from identical starting populations.

### Ring World
Habitable ring around a deadly center. The ring topology forces populations to spread along a band rather than in all directions. Creates interesting dynamics around territorial pressure along the ring.

### Waterworld
Mostly ocean with scattered tiny islands. Very limited habitable space. Populations are small and isolated. Drowning is a constant threat. ADP and SIZ (for HP to survive water crossings) become critical.
