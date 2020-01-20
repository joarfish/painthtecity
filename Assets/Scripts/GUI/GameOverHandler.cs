using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Architecture;
using Application;

namespace GUI
{
    public class GameOverHandler : MonoBehaviour
    {
        [Inject] ApplicationEventSystem _appEventSystem;

        public GameOverHandler()
        {
            SimpleDependencyInjection.getInstance().Inject(this);
        }

        public void OnClickRetryLevel()
        {
            _appEventSystem.SendRestartLevel();
        }

        public void OnClickBackToMainMenu()
        {
            _appEventSystem.SendEndGame();
        }
    }
}


