using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class USB_ReplaceShader : MonoBehaviour
{
    public Shader replacementShader;

    private void OnEnable()
    {
        if (replacementShader != null)
        {
            GetComponent<Camera>().SetReplacementShader(replacementShader, "RenderType");
        }
    }

    private void OnDisable()
    {
        GetComponent<Camera>().ResetReplacementShader();
    }
}
