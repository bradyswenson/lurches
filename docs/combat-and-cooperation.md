# Combat & Cooperation

Lurches don't just eat and breed. They fight, defend, cooperate, raid, and build. Two opposing social strategies emerge naturally from the gene system, creating the central tension of the simulation.

## The cooperation score

Every Lurch has an implicit cooperation score:

```
coopScore = (INT + PER) / 2 - (STR + SIZ) / 4
```

Lurches with a coopScore above 0.2 are **cooperators** — they tend toward social behavior. Those with a high aggression score (`(STR + SIZ) / 2 - (INT + PER) / 2 > 0.1`) are **brutes** — they tend toward violence. Most Lurches fall somewhere in between.

## Fighting

Aggressive Lurches attack adjacent neighbors when they believe they can win. The decision factors in:

- **Own power** vs **target's apparent power**
- **Aggression threshold** — higher STR+SIZ means more willing to fight
- **Threat deterrence** — cooperator allies near the target make it look more dangerous
- **HP and energy** — injured or exhausted Lurches are less aggressive
- **Low-population dampening** — below 100 pop, aggression scales down proportionally (halved at 50, floored at 30%). Even brutes hold back when the species is scarce

When a fight happens:

- **Attack power** = (STR × 0.6 + SIZ × 0.4) × specialization penalty × 30 × random variance × pack bonus
- **Defense power** = target's SIZ × 0.4 + STR × 0.3 + ADP × 0.3, all multiplied by 20, plus cooperative defense bonus
- **Terrain safety multiplier** = 3 (safe terrain like forests and mountains provide stronger defense)
- **Evasion** — Defenders can evade attacks before combat resolves based on INT, SPD, and PER
- **Counter-strikes** — Defenders with STR or SIZ > 0.4 automatically fight back (damage multiplier 6)
- **Net damage** = attack - defense (minimum 1)
- **Fight energy cost** = 15 per fighter
- **Attacker stress gain** = 18
- If the target dies, the attacker claims food and energy spoils
- Kill VFX: red ⚔ flash on the target's cell

## War bands (pack bonus)

Brutes near other brutes are more dangerous. For each adjacent ally with an aggression score above 0.1:

- **+20% attack damage** per brute ally
- **+30% spoils** per brute ally from kills

This naturally creates raider war bands — clusters of STR/SIZ-dominant Lurches that hunt together. They're more effective in groups than alone, so they tend to stay near each other and move as a pack.

## Cooperative defense

When a cooperator is attacked, nearby cooperators rally to its defense:

- Each cooperator ally within 1 tile adds **+15% defense** to the target, capped at 60% total
- This triggers the blue ❤ cooperation VFX

A lone cooperator is vulnerable. A settlement full of them is a fortress. This is the core incentive for cooperators to cluster — mutual protection.

**Spoils from kills** — When an attacker kills a target, they gain hunger reduction of -18 and energy of +12. Pack hunters with multiple allies (cap 3) multiply these spoils.

## Threat deterrence

Before attacking, aggressors assess not just the target but its neighbors. Each cooperator ally near the target multiplies the perceived threat:

```
deterrence = 1 + coopAllies × 0.25
```

An aggressor needs to believe `myPower > theirPower × 0.8 × deterrence` before attacking. A target surrounded by 4 cooperator allies looks twice as dangerous as it would alone, discouraging attacks against established settlements.

## Cooperative healing

Cooperators near other cooperators passively heal each round:

```
healAmount = min(nearbyCoops × 1.5, maxHP × 0.03)
```

Small but meaningful — in a dense settlement, everyone slowly regenerates. Combined with VIT's passive healing (when not diseased and hunger is low), settlement Lurches are remarkably resilient.

## Settlements

When enough cooperators cluster together, several mechanics combine to create emergent settlements:

### Food cultivation

Cooperators boost food regrowth on nearby tiles (range 2). Each cooperator contributes proportionally to their cooperation score, capped at 2x regrowth. This is farming — settlements produce more food than the terrain naturally would, making them self-sustaining.

The food bonus benefits everyone in the area, not just cooperators. This creates a tragedy-of-the-commons dynamic: raiders can feed off settlement-boosted food without contributing.

### Settlement stickiness

Cooperators in clusters (2+ cooperator neighbors) have a chance to stay put each round instead of wandering. The more neighbors, the stickier — up to 80% chance to settle. This only applies when the Lurch isn't hungry or stressed, so settlements dissolve under pressure.

### Teaching amplification

Teachers in settlements are more effective. Each nearby cooperator adds 15% to teaching power, capped at 60%. This means a teacher in a settlement of 5 cooperators is 60% more effective than a lone teacher — knowledge compounds in communities.

### Stress resistance

Cooperators with 2+ cooperator neighbors get 40% reduction in crowding stress. Normal Lurches get stressed in dense areas; settled cooperators don't. This lets settlements grow denser than random populations without stress-induced breakdown.

### Settlement fertility bonus

Cooperators in settlements gain a +25% fertility bonus, accelerating population growth in stable communities. Settlement life improves reproductive success.

### Settlement crowding exemption

Cooperators in settlements get a 50% exemption from crowding-based fertility penalties, allowing settlements to sustain higher density than scattered populations. However, extreme crowding still triggers a **12% penalty per neighbor beyond 3**, preventing infinite density.

## The emergent conflict

Settlements create food-rich, well-defended territory. War bands create the offensive power to raid it. Neither strategy permanently dominates — you'll see dominant traits trade places over thousands of rounds as the balance shifts between cooperation and aggression.

After catastrophes (meteors, plagues, culls), the surviving gene mix determines what emerges next. A post-meteor world dominated by INT Lurches quickly rebuilds settlements. One dominated by STR Lurches becomes a warzone. The most interesting outcomes happen when both survive and compete for the same territory.
