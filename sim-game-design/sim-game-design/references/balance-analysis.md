# Balance Analysis Guide

A detailed reference for diagnosing and resolving trait/strategy balance issues in simulation games. Read this when a trait isn't behaving as expected, a strategy dominates too quickly, or the simulation converges to boring monoculture.

## Table of Contents

1. Diagnostic Framework
2. Common Structural Traps
3. Trait Frequency Analysis
4. The Mobility-Clustering Tradeoff
5. Phase Order Effects
6. Stress and Feedback Loops
7. Reproduction Bottlenecks
8. Intervention Strategies
9. When "Broken" Is Actually Interesting

---

## 1. Diagnostic Framework

When a trait or strategy doesn't perform as expected, work through these layers in order. Each layer is more subtle than the last.

### Layer 1: Incentive Math
Trace the actual numbers. Does the trait produce more surviving offspring per generation? Don't assume — compute it. A trait that gives +50% combat strength but -30% movement speed might look dominant on paper, but if movement is how agents find mates, the math doesn't work out.

Key questions:
- What is the effective reproduction rate for agents with this trait vs. without?
- Does the trait's benefit compound over generations, or does each generation start from scratch?
- Are there hidden costs embedded in the behavior the trait encourages?

### Layer 2: Structural Barriers
The simulation architecture itself can suppress traits. Phase ordering, spatial constraints, and state resets between generations can all prevent a trait from expressing its theoretical advantage.

Key questions:
- Does the trait's benefit apply before or after the critical selection event (usually combat or starvation)?
- Can agents with this trait physically reach the resources or mates they need?
- Do offspring inherit the trait's effective benefits, or just the genetic value?

### Layer 3: Counter-Strategy Strength
Every trait exists in an ecosystem. If the counter-strategy is too efficient, the trait never gets traction regardless of its theoretical power.

Key questions:
- What kills agents with this trait most often? Is that cause of death avoidable?
- Does the counter-strategy have a structural advantage (e.g., first-mover in phase order)?
- Is the counter-strategy's cost low enough that it's always worth running?

### Layer 4: Emergent Behavioral Tax
The most subtle layer. Traits that make agents "smarter" or more complex often impose invisible costs through the additional behaviors they trigger. An agent that evaluates 7 factors before eating will sometimes starve while a reactive agent that eats whatever's nearby thrives.

Key questions:
- How many decision phases does this trait add to the agent's tick?
- Does the trait encourage behaviors (clustering, waiting, evaluating) that conflict with basic survival actions?
- Would a "dumber" version of this trait actually perform better?

---

## 2. Common Structural Traps

### The Academy Trap
When high-value agents cluster for mutual benefit (teaching, cooperation bonuses), they gain enormous local advantages but sacrifice mobility. If reproduction requires physical proximity to mates, clustered agents have a smaller effective mate pool than wanderers.

Symptoms: The trait's holders survive longer than average but reproduce less. Local clusters are impressive but don't grow the global population share.

The fix depends on what you want:
- If clustering is a desired emergent behavior, accept the reproduction tradeoff as a feature — it creates interesting spatial dynamics and prevents the trait from trivially dominating.
- If you want the trait to compete fairly, add mechanics that help clustered agents reproduce (e.g., longer fertility windows, attraction signals that draw mates to clusters, or offspring dispersal that carries the trait outward).

### The Complexity Tax
Sophisticated strategies require more computation per tick: threat evaluation, group coordination, resource planning. If the simulation processes all agents in the same tick budget, complex agents effectively move slower — they make fewer actions per unit time.

Symptoms: Complex agents outperform in controlled tests but underperform in the live simulation. They seem to "think too much" and miss opportunities.

The fix: Either give complex agents explicit action-speed bonuses to compensate, or accept that complexity has a real cost (which is arguably realistic).

### The Juvenile Vulnerability Window
If offspring are born without their parent's accumulated advantages (group membership, social capital, territorial position), every generation resets to zero. Traits that require time to build up their advantage are perpetually starting over.

Symptoms: The trait's adult agents are powerful, but total population share stays low because juveniles die before reaching the trait's effective age.

The fix: Cultural inheritance — offspring born near parents with established advantages should inherit some of those advantages (e.g., academy-born children get an intelligence boost, offspring in cooperative groups start with allies).

### The Stress Paradox
Traits designed to help in stressful situations often degrade under stress. If intelligence drops when stress is high, and the situations where intelligence matters most are stressful, the trait is self-defeating.

Symptoms: The trait's holders perform well in calm conditions but collapse exactly when they should shine.

The fix: Either exempt the trait from stress degradation, or create a secondary mechanic (e.g., experienced agents build stress resistance) that lets the trait function under pressure.

---

## 3. Trait Frequency Analysis

### Reading the Distribution
Always display real-time trait distribution as a bar chart. This is your primary balance diagnostic tool. Healthy simulations show:

- **No single trait above 60%**: If one trait dominates this hard, its counter-strategy is too weak or nonexistent.
- **No trait permanently below 5%**: If a trait can never gain traction, something structural is suppressing it.
- **Oscillation**: Traits should rise and fall over time. Predator-prey dynamics between traits are a sign of good balance.
- **Crisis response**: After population crashes, the distribution should shift — whoever adapts to the new conditions should grow.

### Frequency-Dependent Mechanics
The most important single mechanic for maintaining diversity is frequency-dependent selection:

- **Rare trait bonus**: When a trait is under-represented in the population, bias inheritance toward the higher parent. This prevents useful but minority traits from disappearing entirely.
- **Dominant trait regression**: When a trait is over-represented (3x+ expected frequency), bias inheritance toward the lower parent. This prevents monoculture.

Without these mechanics, populations inevitably converge to a single optimal genotype and the simulation loses its dynamism.

### The 8% Problem
Some traits stabilize at a low but persistent frequency. This happens when the trait has strong local advantages (making its holders survive well) but poor scaling properties (making it unable to spread through the population).

This is often the correct equilibrium. The trait creates interesting local phenomena (clusters, academies, settlements) without dominating. Before "fixing" this, ask whether the trait's rarity is actually what makes it special in the game's narrative.

---

## 4. The Mobility-Clustering Tradeoff

This is the most common source of "why doesn't this trait dominate?" confusion.

### The Fundamental Tension
Movement serves two purposes: finding resources and finding mates. Traits that encourage settling (cooperation, teaching, territorial defense) sacrifice mate-finding mobility. Traits that encourage wandering (exploration, aggression, foraging) sacrifice local advantages.

### Measuring the Tradeoff
Track these metrics for each trait:
- **Effective mate encounters per generation**: How many eligible mates does an average agent with this trait encounter?
- **Offspring per encounter**: When mating does happen, how many offspring result? (Survival rate matters here.)
- **Offspring survival rate**: What fraction of offspring reach reproductive age?

A trait can have excellent offspring survival but still decline if mate encounters are too rare.

### Design Levers
To shift the balance:
- **Attraction signals**: Let established clusters emit signals that draw wanderers in. This gives clustered agents mate access without requiring them to move.
- **Dispersal mechanics**: Offspring leave the cluster and spread the trait. The parent stays put, but the gene propagates.
- **Fertility windows**: Clustered agents could have longer fertility periods, compensating for fewer encounters with higher per-encounter success.
- **Seasonal movement**: Agents cluster for most of the cycle but disperse for a mating season.

---

## 5. Phase Order Effects

The order in which simulation phases execute creates implicit advantages and disadvantages.

### First-Mover Advantage
If combat resolves before cooperation benefits apply in the same tick, aggressive agents will always have a structural edge — they attack at full strength while cooperative agents haven't yet received their group bonuses.

### Resource Priority
If resource consumption happens before resource regeneration, agents in depleted areas starve even if food would have appeared in the same tick. This penalizes stationary agents (who deplete their local area) relative to mobile ones.

### The Fix: Phase Dependency Awareness
Document your phase order and trace which traits benefit from each position. If a trait consistently loses because its benefits apply after the critical selection event, either reorder the phases or add carry-over effects from the previous tick.

---

## 6. Stress and Feedback Loops

### Positive Feedback (Snowball)
When success breeds more success: strong agents win fights → gain resources → grow stronger → win more fights. Left unchecked, this creates runaway dominance.

Countermeasures: Diminishing returns on strength, fatigue mechanics, resource caps, or increasing aggression from desperate weaker agents.

### Negative Feedback (Self-Correcting)
When success creates new vulnerabilities: large populations deplete resources → starvation culls the population → resources recover → growth resumes. This is healthy oscillation.

### Stress-Collapse Feedback
The most dangerous pattern: stress degrades performance → degraded performance causes more stress → cascade to death. Watch for traits or conditions where an agent enters a declining spiral they can't escape.

Countermeasures: Stress caps, recovery thresholds (stress drops rapidly below a certain level), or external rescue mechanics (cooperation, healing).

---

## 7. Reproduction Bottlenecks

### Identifying Bottlenecks
For each trait, measure:
1. **Survival to reproductive age**: What fraction of agents with this trait survive to maturity?
2. **Mate availability**: Of mature agents, what fraction find a mate per tick?
3. **Reproductive success**: Of mated agents, what fraction produce surviving offspring?

The bottleneck is whichever stage has the lowest throughput. Fixing the wrong stage won't help — if mate availability is the bottleneck, making the trait's holders survive longer only creates more unmated agents.

### Common Bottlenecks by Trait Archetype
- **Aggressive traits**: Bottleneck is usually survival (they fight and die young). Fix: higher combat efficiency or armor.
- **Cooperative traits**: Bottleneck is usually mate availability (they cluster). Fix: attraction mechanics or dispersal.
- **Intelligent traits**: Bottleneck is usually behavioral overhead (they evaluate instead of acting). Fix: decision shortcuts or action bonuses.
- **Stealthy traits**: Bottleneck is often mate-finding (hiding makes you hard to find by mates too). Fix: selective visibility (hidden from predators, visible to mates).

---

## 8. Intervention Strategies

### Gentle Nudges vs. Hard Fixes
Prefer parameter adjustments over mechanical changes. Changing a CONFIG value is reversible and testable; adding a new mechanic changes the game's fundamental dynamics.

Priority order for intervention:
1. **Adjust numbers**: Change rates, thresholds, multipliers in CONFIG
2. **Modify weights**: Change how much each factor matters in decisions
3. **Add soft mechanics**: Bonuses, attractors, decay adjustments
4. **Change hard mechanics**: New phases, new agent behaviors, new rules

### Testing Changes
After any balance change:
1. Run the simulation for at least 200 ticks
2. Watch the trait distribution chart
3. Look for the changed trait's frequency response
4. Check that you haven't broken another trait in the process
5. Run from at least 3 different seeds to rule out seed-specific effects

---

## 9. When "Broken" Is Actually Interesting

Not every balance anomaly needs fixing. Some of the most compelling emergent behaviors come from "broken" mechanics:

- **Rare but powerful**: A trait that only 5-8% of the population carries can create fascinating local phenomena — academies, fortresses, nomadic tribes — precisely because it's rare.
- **Boom-bust cycles**: A trait that periodically surges and crashes creates narrative drama. The cycle itself is the interesting behavior.
- **Surprising losers**: When the "obviously best" trait doesn't dominate, it forces observers to think about why — which teaches them something about the system's actual dynamics.
- **Accidental niches**: When a trait survives by exploiting an unintended environmental niche, it's an emergent story the designer didn't script.

Before fixing balance, ask: "Is this making the simulation more or less interesting to watch?" If a "broken" trait creates better stories, it's working as designed — even if it wasn't designed that way.
