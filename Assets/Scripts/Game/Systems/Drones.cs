using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Architecture;

namespace Game {
    namespace Systems
    {
        public class Drones : MonoBehaviour
        {

            [Inject] private GameEventSystem _gameEventSystem;
            private BoxCollider _collider;

            private readonly float _speed = 10.0f;

            bool _running = false;

            public Drones()
            {
                SimpleDependencyInjection.getInstance().Inject(this);

                _gameEventSystem.OnGameStateChanged += handleGameStateChanged;
            }

            private void Awake()
            {
                _collider = GetComponent<BoxCollider>();
            }

            private void Update()
            {
                if (!_running) return;

                transform.Translate(transform.forward * _speed * Time.deltaTime);
            }

            private void OnTriggerEnter(Collider other)
            {
                if(other.gameObject.tag == "Player")
                {
                    Debug.Log("Caught the player!");
                    _gameEventSystem.SendDronesReachedPlayer();
                }
            }

            private void handleGameStateChanged(GameState state)
            {
                _running = state == GameState.Running;
            }
        }
    }
}


