using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using Architecture;
using Game.Systems;

namespace GUI
{
    public class HUDLength : MonoBehaviour
    {
        [Inject] private GameEventSystem gameEventSystem;
        private TextMeshProUGUI textMesh;

        public HUDLength()
        {
            SimpleDependencyInjection.getInstance().Inject(this);
        }

        private void OnEnable()
        {
            gameEventSystem.OnUpdateTrailLength += HandleUpdateTrailLength;
        }

        private void OnDisable()
        {
            gameEventSystem.OnUpdateTrailLength -= HandleUpdateTrailLength;
        }

        private void Start()
        {
            textMesh = GetComponent<TextMeshProUGUI>();
        }

        void HandleUpdateTrailLength(float length)
        {
            textMesh.text = length.ToString("0.00m");
        }
    }
}


