# Procedural terrain

WorldGenerator adds connected fertile-soil, desert, and rocky-ground patches after paths and the central tower are placed. Remaining tiles stay grassland. Terrain is independent of whether a tile is buildable, a path, or an obstacle, so patches extend across paths without changing navigation or buildability.

## Inspector settings

Select the scene's WorldGenerator component:

- **Generate Terrain** enables the feature.
- **Patches Per Terrain** defaults to 2, with 30–55 tiles per patch. Patches can be smaller when other regions or grid edges prevent further growth; adjacent patches of the same terrain can merge visually.
- **Randomize Terrain Seed** creates a new terrain seed each generation. Disable it and set **Terrain Seed** for repeatable terrain on the same input grid. This does not seed the existing obstacle/path generator, so it does not reproduce the entire world across runs.
- **Terrain Colors** sets fertile brown, desert sand, and rocky gray. **Terrain Path Brightness** darkens path tiles within regions so routes remain distinguishable.
- **Terrain Effects** controls the three multipliers below. Setting a multiplier to 1 disables that effect.

| Terrain | Default effect | Activation |
| --- | --- | --- |
| Fertile soil | 1.5× anthill production speed | The placed anthill's tile is fertile. |
| Desert | 1.25× enemy movement speed | The enemy currently occupies a desert path tile. |
| Rocky ground | 1.5× enemy damage to defenders | The attacker occupies a rocky path tile and targets a defense character. |

Enemy terrain multipliers multiply the existing weather multipliers. Leaving the relevant path tile removes the bonus. Rocky ground does not amplify damage to the central tower. Projectiles capture their damage at firing time, with final damage rounded to an integer.

Fertile soil accelerates both the production timer and coin animation. The production amount is unchanged, and purchased production upgrades still apply. An active coin animation completes before another production animation starts.

## Generation and visuals

The generator reserves seed tiles for all requested patches, then grows each patch through neighbouring cells. Fertile patches start on available buildable tiles; desert and rocky patches start on paths, ensuring their effects have a usable location when suitable tiles exist. The occupied central tower tile is excluded. Existing trees and rocks remain in place.

Colors are applied to the base tile's ground renderer using a MaterialPropertyBlock. The Tile prefab supplies this reference, inherited by its path and obstacle variants. Custom tile prefabs must assign **Ground Renderer** on GridTile. Decorations keep their existing materials; this implementation does not add desert-specific plants or new terrain meshes.

## Play-mode checks

1. Generate a level and check that brown, sand, and gray regions cross the grid while paths remain visible and usable.
2. Place otherwise identical anthills on grassland and fertile soil. At the default multiplier, the fertile one should have approximately two-thirds the production cycle duration, with equal payouts. Repeat after a production-speed upgrade.
3. Follow an enemy entering and leaving a desert path patch. Its NavMeshAgent speed should change by 1.25× and return to its weather-adjusted speed on leaving.
4. Compare identical enemies attacking defenders from rocky and ordinary path tiles. Rocky damage should be multiplied by 1.5 before rounding. Attacks on the central tower must not receive that terrain bonus.
5. Check the same transitions during rain or a thunderstorm, including swarmer offspring. Terrain and weather should combine without accumulating bonuses.
6. Disable Generate Terrain and regenerate to return to the original grassland/path appearance and neutral terrain effects.
