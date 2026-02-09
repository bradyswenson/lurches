# Genetics & Evolution

## The genome

Every Lurch has 7 genes, each a floating-point value from 0.0 to 1.0:

| Gene | Color | Primary role |
|------|-------|-------------|
| Vitality (VIT) | Green | Constitution and immune system — disease resistance, passive healing when healthy, cold tolerance |
| Speed (SPD) | Cyan | Tiles moved per round, flee success rate |
| Strength (STR) | Red | Attack damage, fight initiation threshold |
| Intelligence (INT) | Blue | Decision-making quality, teaching ability, discovery leadership |
| Adaptability (ADP) | Yellow | Environmental resistance — terrain hazards, disease tolerance, temperature |
| Perception (PER) | Gray | Scan radius for food/threats/mates, cooperation score, discovery teams |
| Size (SIZ) | White | Max HP, combat advantage (both attack and defense) |

The dominant gene — the one with the highest value — determines the Lurch's color on the grid.

## Metabolism and tradeoffs

Every gene adds to a Lurch's metabolic cost. Bigger, faster, tougher Lurches burn through food faster. The weights:

- ADP: 0.6x (highest cost — adaptability is expensive)
- SIZ: 0.5x
- VIT: 0.3x
- STR: 0.3x
- SPD, INT, PER: lower indirect costs

This creates natural pressure against maximizing everything. A Lurch that's huge, fast, and tough will starve in a food-scarce environment. Specialization has power but generalism has efficiency.

## Specialization penalty

A Lurch whose genome is heavily skewed toward one gene pays a penalty on that gene's effectiveness. The more lopsided the genome, the steeper the penalty. This prevents runaway single-gene dominance and rewards balanced builds.

The penalty is calculated from the standard deviation of all 7 gene values — high variance means high specialization, which means diminishing returns on the dominant trait.

## Inheritance

When two Lurches reproduce, offspring genes are determined by:

1. **Crossover** — Each gene is a weighted blend of the two parents. The blend weight is random (0.2 to 0.8), so offspring aren't simple averages.

2. **Frequency-dependent bias** — For genes that are underrepresented in the population (below 1/7 ≈ 14.3% of dominant traits), the blend weight shifts up to 0.15 toward the stronger parent. Additionally, genes appearing at 3x their expected frequency (above ~42.9%) incur a dominance penalty (strength 0.3, capped at 0.15) to prevent runaway fixation. This self-correcting mechanism prevents any gene from being permanently bred out or from completely taking over. Inspired by real frequency-dependent selection in biology.

3. **Mutation** — Each gene gets a gaussian random nudge (mean 0, std proportional to mutation rate). There's also a 2% chance of a macro-mutation — a large random jump that can introduce dramatically different traits. Rare genes receive a rarity boost of 0.20 to increase their survival probability.

## Reproduction

Reproduction is health-based, not gene-based. The chance of mating depends on:

- **Health score** — Average HP percentage of both parents
- **Birth rate** — Global slider set at world creation
- **Fertility window** — Full fertility until 60% of max age, linear taper from 60% to 90%, completely infertile beyond 90%. Elders can still teach and cooperate but can't breed.
- **Overcrowding** — Dense areas suppress reproduction
- **Low-population recovery** — Below 150 pop, layered recovery kicks in: fertility boosts (+50% under 150, another +50% under 75, another +50% under 30 for up to ~2.3× total), extended mating range (1 → 2 cells), and reduced repro cooldown (halved at 50 pop, min 2 rounds). Combined with wider scan range, migration pull, and aggression dampening (see [Behavior](behavior.md)), these give struggling populations a real fighting chance

No single gene controls reproduction directly. This was a deliberate design choice — in earlier versions, VIT-dominant Lurches lived longer and bred more, creating a feedback loop. Now longevity comes from a genome-hash (no single gene controls lifespan), and breeding depends purely on staying healthy.

## Lifespan

Max age is derived from a hash of the full genome — not any single gene. This means lifespan varies across individuals without giving any one gene a reproductive advantage through longevity alone. Base lifespan is 80 rounds, with variance up to half the max lifespan (200 rounds) based on the genome hash.

## Natural selection in practice

Over thousands of rounds, you'll see:

- **Convergence** — Populations in stable environments settle toward a few dominant trait profiles
- **Divergence** — Geographically separated groups evolve different dominant traits
- **Oscillation** — Dominant traits trade places as environmental pressure shifts (STR rises → food gets scarce → ADP rises → fights decrease → STR falls)
- **Bottleneck recovery** — After a meteor or plague, whatever survives shapes the next era. Post-catastrophe populations often look completely different from pre-catastrophe ones
- **Frequency-dependent equilibrium** — Rare traits slowly recover thanks to the inheritance bias, preventing permanent extinction of any gene
