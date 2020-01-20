using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Compositor : MonoBehaviour
{
    private Material material;

    private void Awake()
    {
        if(material==null)
        {
            material = new Material(Shader.Find("Compositing/CompositDash"));
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }
}
