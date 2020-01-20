using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

namespace GUI
{
    public class Loader : MonoBehaviour
    {
        float _loaded = 0.0f;
        RectTransform _rectTransform;

        void Start()
        {
        }

        private void Awake()
        {
            _rectTransform = GetComponent<RectTransform>();
            _loaded = 0.0f;
        }

        void Update()
        {
            _rectTransform.SetSizeWithCurrentAnchors(RectTransform.Axis.Horizontal, _loaded * 400.0f);

            if (_loaded < 400.0f)
            {
                _loaded = Mathf.Min(1.0f, _loaded + Time.deltaTime);
            }
        }
    }
}


