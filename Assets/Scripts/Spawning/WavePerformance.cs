using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using Defenses.DefenseCharacters;
using Enemy;
using NUnit.Framework;

namespace Spawning
{
    //This is a data class to record the player's performance on the previous waves
    public sealed class WavePerformance
    {
        public int WaveNumber { get; }
        public float TowerDamageTaken { get; }
        public float TowerMaxHealth { get; }

        public int DefendersKilled { get; }
        public int DefendersTracked { get; }

        public int EnemiesReachedTower { get; }
        public int EnemiesSpawned { get; }

        public WavePerformance(int waveNumber, float towerDamageTaken, float towerMaxHealth, int defendersKilled,
            int defendersTracked, int enemiesReachedTower, int enemiesSpawned)
        {
            WaveNumber = waveNumber;
            TowerDamageTaken = towerDamageTaken;
            TowerMaxHealth = towerMaxHealth;
            DefendersKilled = defendersKilled;
            DefendersTracked = defendersTracked;
            EnemiesReachedTower = enemiesReachedTower;
            EnemiesSpawned = enemiesSpawned;
        }
    }

    //This class provides the logic to record the player's performance
    public sealed class WavePerformanceTracker : IDisposable
    {
        //Hash sets prevent the same enemy, defender, or event from being counted more than once
        private readonly HashSet<EnemyBase> enemies = new();
        private readonly HashSet<EnemyBase> arrivals = new();

        private readonly HashSet<DefenseCharacterBase> defenders = new();
        private readonly HashSet<DefenseCharacterBase> killedDefenders = new();

        private readonly HashSet<Projectile> projectiles = new();

        private int waveNumber;
        private float towerMaxHealth;
        private float towerDamageTaken;

        public bool IsRecording { get; private set; }

        public WavePerformance PreviousWave { get; private set; }

        //This checks whether enemy projectiles could still cause damage before a wave ends
        public bool HasPendingProjectiles
        {
            get
            {
                projectiles.RemoveWhere(projectile => projectile == null || !projectile.IsInFlight);
                return projectiles.Count > 0;
            }
        }

        //Clear the previous tracking data and starts recording for a new wave
        public void BeginWave(int number, float maxTowerHealth)
        {
            ClearTracking();

            waveNumber = number;
            towerMaxHealth = maxTowerHealth;
            towerDamageTaken = 0f;

            IsRecording = true;
        }

        public void RecordTowerDamage(float actualDamage)
        {
            if (!IsRecording)
                return;

            towerDamageTaken += actualDamage;
        }

        public void RegisterEnemy(EnemyBase enemy)
        {
            if (!IsRecording || !enemies.Add(enemy))
                return;

            enemy.ReachedTower += HandleEnemyReachedTower;
            enemy.ProjectileSpawned += HandleProjectileSpawned;

            if (enemy.HasReachedTower)
                HandleEnemyReachedTower(enemy);
        }

        public void RegisterDefender(DefenseCharacterBase defender)
        {
            if (!IsRecording || !defenders.Add(defender))
                return;

            defender.Died += HandleDefenderDied;
        }

        private void HandleEnemyReachedTower(EnemyBase enemy)
        {
            if (IsRecording && enemies.Contains(enemy))
                arrivals.Add(enemy);
        }

        private void HandleDefenderDied(DefenseCharacterBase defender)
        {
            if (IsRecording && defenders.Contains(defender))
                killedDefenders.Add(defender);
        }

        private void HandleProjectileSpawned(Projectile projectile)
        {
            if (IsRecording && projectile != null)
                projectiles.Add(projectile);
        }

        //We finish the wave by creating a Wave Performance for the previous wave
        public WavePerformance FinishWave()
        {
            PreviousWave = new WavePerformance(waveNumber, towerDamageTaken, towerMaxHealth, killedDefenders.Count,
                defenders.Count, arrivals.Count, enemies.Count);
            
            IsRecording = false;
            ClearTracking();

            return PreviousWave;
        }

        public void CancelWave()
        {
            IsRecording = false;
            ClearTracking();
        }

        private void ClearTracking()
        {
            foreach (var enemy in enemies)
            {
                if (enemy == null)
                    continue;

                enemy.ReachedTower -= HandleEnemyReachedTower;
                enemy.ProjectileSpawned -= HandleProjectileSpawned;
            }

            foreach (var defender in defenders)
            {
                if (defender != null)
                    defender.Died -= HandleDefenderDied;
            }
            
            enemies.Clear();
            defenders.Clear();
            killedDefenders.Clear();
            projectiles.Clear();
        }

        public void Dispose()
        {
            CancelWave();
        }
    }
}