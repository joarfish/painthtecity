using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Architecture;
using Game.Entities;

namespace Game
{
    namespace Systems
    {
        public class TrailSystem : MonoBehaviour
        {
            private readonly float trailDistance = 0.1f;

            private int trailCount = 0;
            private Trail currentTrail = null;

            public float trailLength = 0.0f;
            private float lastTrailLength = 0.0f;

            [Inject] private GameEventSystem gameEventSystem;

            public TrailSystem()
            {
                SimpleDependencyInjection.getInstance().Inject(this);
            }

            private void OnEnable()
            {
                gameEventSystem.OnPositionChanged += handlePlayerPositionChanged;
                gameEventSystem.OnGroundedChanged += handlePlayerGroundedChanged;

            }

            private void OnDisable()
            {
                gameEventSystem.OnPositionChanged += handlePlayerPositionChanged;
                gameEventSystem.OnGroundedChanged -= handlePlayerGroundedChanged;
            }

            private void handlePlayerPositionChanged(Vector3 position)
            {
                if (currentTrail)
                {
                    currentTrail.UpdateLastPathPoint(new Vector3(position.x, position.y + trailDistance, position.z));
                    updateTrailLength();
                }
            }

            private void handlePlayerGroundedChanged(bool grounded)
            {
                if (grounded)
                {
                    StartNewTrail();
                }
                else
                {
                    updateTrailLength();
                    currentTrail = null;
                }

            }

            private void updateTrailLength()
            {
                if (currentTrail == null) return;

                trailLength -= lastTrailLength;
                lastTrailLength = currentTrail.Length;
                trailLength += lastTrailLength;

                gameEventSystem.SendUpdateTrailLength(trailLength);
            }

            private void StartNewTrail()
            {
                trailCount++;
                lastTrailLength = 0.0f;
                GameObject trailObject = new GameObject("trail_" + trailCount);
                currentTrail = trailObject.AddComponent<Trail>();
                currentTrail.AddPathPoint(new Vector3(transform.position.x, transform.position.y + trailDistance, transform.position.z));
                currentTrail.AddPathPoint(new Vector3(transform.position.x, transform.position.y + trailDistance, transform.position.z));
            }
        }

    }
}
