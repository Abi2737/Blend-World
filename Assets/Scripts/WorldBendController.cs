using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WorldBendController : MonoBehaviour {

    public float attenuateFactor = 0.00005f;

    public Material blendMaterial;

    void Update()
    {
        if (Input.GetKey(KeyCode.W))
        {
            blendMaterial.SetFloat("_BlendY", blendMaterial.GetFloat("_BlendY") + attenuateFactor);
        }

        if (Input.GetKey(KeyCode.S))
        {
            blendMaterial.SetFloat("_BlendY", blendMaterial.GetFloat("_BlendY") - attenuateFactor);
        }

        if (Input.GetKey(KeyCode.D))
        {
            blendMaterial.SetFloat("_BlendX", blendMaterial.GetFloat("_BlendX") + attenuateFactor);
        }

        if (Input.GetKey(KeyCode.A))
        {
            blendMaterial.SetFloat("_BlendX", blendMaterial.GetFloat("_BlendX") - attenuateFactor);
        }
    }

    private void OnDisable()
    {
        blendMaterial.SetFloat("_BlendY", 0.0f);
        blendMaterial.SetFloat("_BlendX", 0.0f);
    }
}
