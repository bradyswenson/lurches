# Behavior & Intelligence

## The decision engine

Every round, each Lurch scans its surroundings and makes one decision: eat, move, fight, flee, hide, sleep, cooperate, reproduce, or do nothing. The quality of that decision depends on the Lurch's effective intelligence.

## Intelligence tiers

Intelligence doesn't just make Lurches "better" — it changes how they think. There are four tiers:

### Instinctive (INT 0.0 – 0.2)

Purely reactive. If hungry and food is adjacent, eat. If a threat is adjacent, fight or flee — coin flip. Otherwise, wander randomly. Mates with anyone nearby without evaluating quality. Seeks companions when hunger is above 30%. At low population, feels a slight migration pull (30%) toward other survivors. These Lurches survive on luck and raw stats.

### Aware (INT 0.3 – 0.5)

Assesses the immediate area. Moves toward visible food instead of wandering. Flees from opponents that look stronger. Prefers hiding when injured. Follows teachers if one is nearby. Seeks companions when hunger is above 30%. At low population, moderate migration pull toward the population center. A meaningful step up from instinctive — these Lurches don't walk into obvious danger.

### Strategic (INT 0.6 – 0.8)

Pathfinds toward the best food sources, weighing both nutrition and safety. Evaluates potential mates by genome quality. Retreats to safe terrain (mountains, forests) when injured. Stockpiles energy before attempting reproduction. Holds position near teachers in good terrain. Seeks companions when hunger is above 25%. Strong migration pull at low population — high PER makes the pull even stronger.

### Brilliant (INT 0.9 – 1.0)

Plans ahead. Actively avoids swamp disease and desert energy traps. Assesses threats with a sophisticated model that accounts for nearby allies and deterrence. Seeks optimal mates with complementary stats. Shows territorial behavior — holds position in food-rich, safe areas rather than wandering. Seeks companions when hunger is above 20%. Strongest migration pull at low population — with high INT + PER, near-100% chance of navigating toward other survivors. These are the settlement leaders and discovery captains.

## Stress and Intelligence resistance

Stress is the great equalizer. A brilliant Lurch at maximum stress behaves like an instinctive one — effective intelligence degrades linearly with stress.

Stress rises from:
- Hunger (being above 50% hunger)
- Injury (low HP percentage)
- Crowding (more than 3 adjacent Lurches)
- Adjacent threats (hostile neighbors)

Stress drops from:
- Eating
- Sleeping (in safe terrain)
- Safe terrain (forests, mountains)
- Solitude
- Being in a settlement (cooperators resist crowding stress)

**Intelligence stress resistance** — Higher INT directly resists incoming stress, reducing stress accumulation by up to 20%. Smart Lurches naturally manage anxiety better than simple ones.

## Teaching and Foraging

Lurches with INT above 0.5 automatically teach adjacent neighbors, boosting their food-gathering efficiency by up to 30%. The teaching effect is visible — taught Lurches glow with a golden halo.

**Smart foraging** — Higher INT directly boosts food efficiency by +10%. Intelligent Lurches are better hunters and gatherers.

**Fast foraging** — Higher SPD directly boosts food efficiency by +10%. Quick Lurches cover more ground and find more food.

**Vitality metabolism** — Higher VIT reduces hunger accumulation by 10%, making tough Lurches more energy-efficient.

In settlements (clusters of cooperators), teaching is amplified. Each nearby cooperator adds up to 15% to the teacher's effectiveness, capped at 60% bonus. This creates a feedback loop: settlements make teachers better, which attracts more Lurches, which strengthens the settlement.

**Evasion** — When threatened, Lurches can evade attacks based on INT, SPD, and PER: `(INT × 0.25) + (SPD × 0.1) + (PER × 0.1)`, capping at approximately 45%. Smarter, faster, more perceptive Lurches are harder to catch.

Taught Lurches are drawn to stay near their teachers, forming natural learning clusters. This is one of the mechanisms that creates proto-settlements in the early game.

## Discovery

Discovery is the mechanism for terrain improvement. When a high-INT Lurch is surrounded by the right team, they can upgrade terrain:

- Desert → Plains or Forest
- Plains → Fertile Plains (rich farmland, 5 food regen)
- Forest → Lush Forest (shelter with HP regen and stress relief, 6 food regen)

The "right team" means nearby Lurches with good Strength (labor), Size (heavy lifting), and Perception (scouting). The INT Lurch is the leader; the others are the workforce.

Discovery costs energy — hungry Lurches don't innovate. And disasters reset enhanced terrain back to base types, so discoveries are valuable but impermanent.

## Kin warning

Smart Lurches (INT ≥ 0.6) can detect danger and warn nearby relatives. Relatives are identified by genetic similarity — Lurches sharing more than 70% genome overlap are considered kin.

Warned Lurches are more likely to flee or hide from threats. This creates emergent kin selection: family groups that cluster together survive better because they share intelligence through warnings. But they also compete for the same food, creating a natural tension between family bonds and resource pressure.

## Low-population recovery

When the population drops below 150, layered survival mechanics activate to give the species a fighting chance:

**Wider scan range** — All AI tiers gain up to +4 bonus scan range, scaling with how low the population is. An instinctive Lurch that normally sees 2 cells now sees up to 6. A brilliant Lurch with good PER can scan 13+ cells. This lets scattered survivors detect each other across a sparse map.

**Migration pull** — Each tick, the simulation computes the population centroid on the toroidal map (using circular mean). When a Lurch would otherwise wander randomly, there's a chance it drifts toward the centroid instead. The pull scales with INT + PER: base 30% for any Lurch, up to 70% for high PER, up to 60% for high INT, and near 100% for high INT + PER combined. Over dozens of rounds, scattered survivors converge.

**Aggression dampening** — Below 100 population, brutes become proportionally less aggressive (halved at 50 pop, floored at 30%). When the species is scarce, even fighters instinctively hold back.

**Breeding urgency** — Reproduction cooldown shrinks at low population (halved at 50 pop, minimum 2 rounds). Fertility gets a tiered boost: +50% under 150, another +50% under 75, another +50% under 30. A population of 10 Lurches has roughly 2.3× fertility.

**Extended mating range** — Below 150 population, mating range extends from 1 to 2 cells, so adjacent-ish Lurches can still pair up without being directly next to each other.

These mechanics create natural boom-bust-recovery cycles. A population of 30 feels different from a population of 300 — the survivors are more perceptive, less violent, breed faster, and drift toward each other. It doesn't guarantee survival, but it gives them a real shot.
