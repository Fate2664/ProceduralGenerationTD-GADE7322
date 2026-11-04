# Defense upgrade aura

`DefenseUpgradeAura.prefab` is already assigned to the SpearAnt, MeleeAnt, and BombAnt prefabs.

- Level 1: no effect instance is created.
- Level 2: a gold, rotating ground ring with rising sparks and a short purchase burst.
- Level 3: a cyan aura with an additional counter-rotating ring, more sparks, and a larger purchase burst.

`DefenseCharacterBase` creates one child effect after a successful upgrade and calls `SetLevel(CurrentLevel)`. The second purchase reuses that instance. Parenting keeps the effect attached to the character and removes it when the character is destroyed. No currency is spent by the visual effect.

## Customization

Open the aura prefab to change **First Upgrade Color** and **Second Upgrade Color** on its `DefenseUpgradeEffect` component. Adjust the root scale to resize the whole effect. The prefab uses local particle simulation and hierarchy scaling, so it also follows each defense prefab's scale.

The four child Particle Systems are editable in the Inspector:

- **Ground Ring**: base ring diameter, height, rotation, and pulse.
- **Rising Sparks**: particle size, lifetime, upward velocity, and orbital movement. The component sets emission to 10 particles/second at Level 2 and 18 at Level 3.
- **Level 3 Outer Ring**: additional ring used only at Level 3.
- **Upgrade Burst**: short-lived sparks emitted once per purchase (18 at Level 2; 28 at Level 3).

The two materials use `Custom/DefenseUpgradeAura`, an additive, unlit shader with procedural ring and spark shapes. It needs no textures or bloom. Material **Intensity** controls brightness. Existing hover outlines and selection effects remain separate.

For a standalone preview, drag the aura prefab into a test scene, set **Current Level** to 2 or 3, then enter Play Mode. Remove that standalone preview from gameplay scenes; placed defenses create their own effects automatically. In code, use `SetLevel(2)` or `SetLevel(3)` to play the upgrade burst, or pass `false` as the second argument to show only the persistent aura.

## Gameplay check

1. Place two defenses; neither should show the aura.
2. Upgrade one; only that character should show the gold aura.
3. Upgrade it again; the same effect instance should become cyan and gain the outer ring.
4. Try purchasing without enough currency; no level or visual change should occur.
5. Deselect the character; its aura should remain.
6. Destroy the character; its aura should disappear with it.

Validation: the runtime assembly compiles using the project's Unity compiler references. An isolated Unity 6000.3.9f1 editor run rendered both tiers and checked tier selection, burst counts, particle clearing, and restoring the tier without replaying the purchase burst. Full gameplay and appearance under the main level's lighting/post-processing still need an in-scene check.
