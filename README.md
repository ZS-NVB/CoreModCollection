# CoreModCollection
Some mods for GemCraft - Frostborn Wrath.

[Bezel Mod Loader](https://github.com/gemforce-team/BezelModLoader) is required and needs to be at least version 0.3.1 for these mods to work.

Some of these mods will modify your savefile so backup your saves before using the mods if you don't want to risk accidentally having a mod do that.

To install this, download the swf from [here](https://github.com/ZS-NVB/CoreModCollection/releases) and put it in your mods folder.

Once the game is run with this mod installed, a config file will be created in %AppData%\com.giab.games.gcfw.steam\Local Store\CoreModCollection which will allow you to choose which mods are enabled.

## AchievementDisabler

Prevents you from getting steam achievements (but doesn't prevent you from getting in-game achievements). No idea if it does anything if you're not using the steam version. 

## AllFragmentsHaveRunes

Makes every talisman fragment have a rune.

## BarrageTargetLimitRemover

Makes barrage shells be able to hit more than 3 monsters.

## BetterBleeding

Makes the True Colors and Bleeding skills increase bleeding damage multiplier instead of duration and adds a third bonus to the Bleeding skill which increases bleeding duration by 20% per 5 levels.

## BetterCritChance

Uncaps crit chance, makes lanterns not have a crit chance cap either, fixes a bug which prevented gem bombs from being able to crit, makes traps and amplifiers increase crit chance (it won't show in stats gained through amplification though) and changes how crit chance scales.

## BetterFury

Makes the health and armor penalty of enraged waves decrease by 4% per 5 levels instead of 3%.

## BetterFusion

Makes combination cost decrease by 4% per 5 levels instead of 3% and makes crafting costs not be rounded to fix a problem where not every fusion level actually provided any bonus over the previous.

## BetterGemBombs

Makes the damage be divided by the number of targets hit after it has been reduced by a target's armor rather than before, making gem bombs not as useless against large groups of monsters

## BetterManaStream

Makes mana stream's secondary bonus also reduce how much the mana pool requirement gets multiplied by each time the pool expands.

## BetterOrb

Makes banishment cost decrease by 0.8% per level instead of 0.5% and makes it multiplicative with the orb's banishment cost reduction from gems to stop banishment from becoming free. 

## BetterResonance

Makes resonance give 4% damage per level (up from 3%) and replaces its useless range bonus with 4% additional damage for grade 7+ gems per 5 levels.

## BetterSlowing

Makes the True Colors and Slowing skills increase slow component power instead of duration and adds a third bonus to the Slowing skill which increases slow duration by 20% per 5 levels, makes different sources of slow (slow special, snow, orblets and whiteout) stack less effectively, changes how slow ratio scales with slow component power and removes the cap on slow ratio.

## BetterTrueColors

Makes true colors give 4% gem specials per level and 4% gem damage per 5 levels, makes it affect quint and prismatic gems and makes it not affect the gem special count modifiers display.

## BleedingMultiplierDisplay

Displays bleed effect as a multiplier instead of a percentage.

## ConstantSkillPointCost

Makes skill points always cost 100 shadow cores to buy and allows buying 10 at a time with shift.

## DamageEstimationFix

Makes damage estimation better to fix things such as towers overshooting bleeding monsters, bolt ignoring thick air in some cases, monsters dying before running out of health due to accumulating incoming damage due to it not being reduced properly when getting hit and pylons applying talisman and adaptive carapace modifiers twice. Also makes monster talisman damage modifiers apply after armor like all other talisman damage modifiers and makes the spire damage limit apply after bleeding.

## EnrageAnyWave

Removes the mechanic which makes the next wave be unenraged when adding a gem to the enraging socket after the first wave.

## FreezeCooldownReversion

Puts freeze's cooldown reduction per level back to 1% from 0.5%.

## FreezeCritDamageFix

Makes frozen monsters take more damage from crits in all cases and makes it multiply the damage rather than just add onto the critical damage multiplier.

## FreezeDiminishingReturns

Makes freeze last less time the more times it is cast on a target to prevent creatures from being permanently frozen.

## IceShardsChange

Makes ice shards reduce max health by a percentage instead of current health and reduce current health by the same amount max health was reduced by so casting ice shards on a monster on low health is just as good as casting it on a monster with full health. Also adds diminishing returns to ice shards so that the effect is no longer exponential in the number of times it is cast on a monster.

## IceShardsDamageReversion

Puts Ice Shards' base health shred back to 20% like it originally was.

## IndividualBeamHits

Makes each hit of beam choose a target to hit rather than having all beam hits from a given tower in one frame hit the same monster, improving the performance of beam when dealing with lots of low health monsters and making beam work just as well on 3x speed as on 1x speed in such a situation.

## JourneyGems

Allows you to use gem types you have the skill for when doing a field for the first time in journey.

## JourneyTraits

Allows you to use battle traits when doing a field for the first time in journey.

## LanternMuter

Makes lanterns not make any sounds.

## LinearSkillEffects

Makes skill effects which are reductions scale such that their effects are linear rather than their reductions, using the value at a skill level of 75 to determine how much to increase it by per level.

## ManaLeechFixes

Fixes mana leech so that mana leech stats get increased by the correct amount, gems don't need to be grade 1 with at least 900 mana leeched in order to count for mana leeched against poisoned/bleeding/whiteouted monsters in some cases, makes all sources of mana leech be able to leech from any creature they hit and prevents tower shots and bolts from leeching from dead creatures.

## MapLimitsRemover

Removes the limits on how far you can scroll the map so you can activate mods and unlock mods at any point in the game.

## ModUnlocker

Unlocks all the in-game mods. Works by making the mods not need to be unlocked to toggle them so the effects of this mod can be reverted by disabling it (but any mods activated which haven't been unlocked won't be able to be disabled until the mod is unlocked).

## MultiplicativeBoundModifiers

Makes pool level and hit level damage bonuses multiply together rather than add.

## NoRitualWizardHunters

Makes ritual never spawn wizard hunters.

## NoTalismanLocks

Gets rid of the locks in the talisman.

New in version 1.2: Works by making the locks inactive and doesn't actually set the slots to be unlocked so the effects of this mod can be reverted by disabling it (but any fragments in slots which aren't unlocked will stay there).

## ProportionateFragmentDrops

Makes the chance of a dropped talisman fragment being an inner, edge or corner proportional to how many slots the talisman has for that type of fragment (that is, 36% chance for an inner, 48% chance for an edge and 16% chance for a corner). Also gets rid of the level requirements for getting edge and corner fragments from drops.

## RangeAdjustmentFix

Fixes the problems with range adjustment and thus makes beam range not be reduced while a gem's range is above beam's max range.

## Rarity100PlusFragments

Allows for rarity 100 fragments with more properties and maximum upgrade level than usual. The rarity range of battles has been changed so that the minimum rarity is uncapped and the maximum rarity is set to whatever is larger out of what it usually would be and the minimum rarity. Each 10 rarity above 100 gives an additional property and upgrade level.

## RotatableFragments

Allows talisman fragments to be rotated by pressing R while the cursor is over them in the talisman fragment inventory. When adding a talisman fragment to the shape collection, all rotations of it will also be added. When loading a save, all rotations of shapes in the shape collection will also be added to the shape collection, so this mod has irreversible effects on savefiles.

## ShrineFix

Makes the percentage health damage of shrines not be affected by modifiers and just directly multiply max health and reduce health by the amount max health was reduced by. Also reverts the health shred back to what it originally was.

## StatFixes

Fixes a few issues with stats such as ice shards kills not counting as kills from ice shards, beam kills against monsters counting twice, exploding orblets kills being in the wrong place in the stats menu and "engared waves". Doesn't attempt to fix anything else though.

## TrapRangeDisplay

Makes hovering over a gem in a trap show the range of the trap.

## TrapRangeIncrease

Increases the range of traps to be the same number of tiles as the range of traps in Chasing Shadows.

## TrapTargetFix

Makes traps apply their target priority on every shot, makes the random priority random again, makes traps on highest banishment cost/special/carrying orblet sort the list of targets in the correct order, makes traps no longer have a limit on the number of times a single monster can be hit in one frame and makes traps not fire at dead monsters.

## UncappedSkills

Makes all skills be uncapped (or at least have a cap of 9999999). Does have a few problems which need fixing with other mods and even then it's not very balanced since it results in too many sources of mana/xp.

## WhiteoutOrbKillsReversion

Reverts the change which made whiteout need monsters to be below 1000 health to be killed by the orb.
