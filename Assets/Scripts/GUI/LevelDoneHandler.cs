using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Architecture;
using Application;

public class LevelDoneHandler : MonoBehaviour
{
    [Inject] ApplicationEventSystem appEventSystem;

    private void Awake()
    {
        SimpleDependencyInjection.getInstance().Inject(this);
    }

    public void OnClickNextLevel()
    {
        appEventSystem.SendNextLevel();
    }

    public void OnClickBackToMainMenu()
    {
        appEventSystem.SendEndGame();
    }
}
