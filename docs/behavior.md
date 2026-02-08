# Behavior & Intelligence

## The decision engine

Every round, each Lurch scans its surroundings and makes one decision: eat, move, fight, flee, hide, sleep, cooperate, reproduce, or do nothing. The quality of that decision depends on the Lurch's effective intelligence.

## Intelligence tiers

Intelligence doesn't just make Lurches "better" — it changes how they think. There are four tiers:

### Instinctive (INT 0.0 – 0.2)

Purely reactive. If hungry and food is adjacent, eat. If a threat is adjacent, fight or flee — coin flip. Otherwise, wander randomly. Mates with anyone nearby without evaluating quality. These Lurches survive on luck and raw stats.

### Aware (INT 0.3 – 0.5)

Assesses the immediate area. Moves toward visible food instead of wandering. Flees from opponents that look stronger. Prefers hiding when injured. Follows teachers if one is nearby. A meaningful step up from instinctive — these Lurches don't walk into obvious danger.

### Strategic (INT 0.6 – 0.8)

Pathfinds toward the best food sources, weighing both nutrition and safety. Evaluates potential mates by genome quality. Retreats to safe terrain (mountains, forests) when injured. Stockpiles energy before attempting reproduction. Holds position near teachers in good terrain.

### Brilliant (INT 0.9 – 1.0)

Plans ahead. Actively avoids swamp disease and desert energy traps. Assesses threats with a sophisticated model that accounts for nearby allies and deterrence. Seeks optimal mates with complementary stats. Shows territorial behavior — holds position in food-rich, safe areas rather than wandering. These are the settlement leaders and discovery captains.

## Stress

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

## Teaching

Lurches with INT above 0.5 automatically teach adjacent neighbors, boosting their food-gathering efficiency by up to 30%. The teaching effect is visible — taught Lurches glow with a golden halo.

In settlements (clusters of cooperators), teaching is amplified. Each nearby cooperator adds up to 15% to the teacher's effectiveness, capped at 60% bonus. This creates a feedback loop: settlements make teachers better, which attracts more Lurches, which strengthens the settlement.

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
