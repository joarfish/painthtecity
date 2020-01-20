using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;


public class DashRenderer : MonoBehaviour
{
    Material dashMaterial;

    private CommandBuffer dashBuffer;
    private Camera cameraRendered;
    private bool bufferSetup = false;

    public void OnDisable()
    {
        Cleanup();
    }

    public void OnEnable()
    {
        Cleanup();
    }

    private void Cleanup()
    {
        if(dashBuffer!=null)
        {
            cameraRendered.RemoveCommandBuffer(CameraEvent.BeforeForwardOpaque, dashBuffer);
        }
        if (cameraRendered != null)
        {
            cameraRendered = null;
        }
        bufferSetup = false;
    }


    void OnWillRenderObject()
    {
        if(!dashMaterial)
        {
            dashMaterial = new Material(Shader.Find("ImageEffects/DashShader"));
        }

        Camera cam = Camera.current;

        if(cam == cameraRendered || bufferSetup)
        {
            return;
        }

        cameraRendered = cam;
        bufferSetup = true;

        int tempID = Shader.PropertyToID("_Temp1");
        dashBuffer = new CommandBuffer { name = "DashBuffer" };
        dashBuffer.GetTemporaryRT(tempID, -1, -1, 24, FilterMode.Bilinear);
        dashBuffer.SetRenderTarget(tempID);
       // dashBuffer.ClearRenderTarget(true, true, Color.black);

        Renderer renderer = GetComponent<Renderer>();
        
        dashBuffer.DrawRenderer(renderer, dashMaterial);

        dashBuffer.SetGlobalTexture("_dashTexture", tempID);

        cam.AddCommandBuffer(CameraEvent.BeforeForwardOpaque, dashBuffer);

    }

}
