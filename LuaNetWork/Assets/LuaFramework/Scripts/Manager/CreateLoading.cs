using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using FairyGUI;
using LuaFramework;

public class CreateLoading : MonoBehaviour {
    public static GProgressBar pb = null;
    public static GComponent gc = null;
    public static GTextField gf = null;
    public static bool need = true;
    // Use this for initialization
    void Start() {
        GRoot.inst.SetContentScaleFactor(1280, 720);
        StartCoroutine(CreateLoadingPanelFromAssetBundle());
    }

    // Update is called once per frame
    void Update() {

    }

    public IEnumerator CreateLoadingPanelFromAssetBundle()
    {
        while (Caching.ready == false)
            yield return null;
        Caching.ClearCache();
        string url = Util.AppContentPath() + "desc_load.unity3d";
        Debug.Log("--------------------AssetBundle加载Loading--------------------------------" + url);

        WWW www = WWW.LoadFromCacheOrDownload(url, 1);
        yield return www;

        if (!string.IsNullOrEmpty(www.error))
        {
            Debug.Log(www.error);
            yield break;
        }
        AssetBundle ab1 = www.assetBundle;

        string url2 = Util.AppContentPath() + "res_load.unity3d";
        Debug.Log("--------------------AssetBundle加载Loading--------------------------------" + url);
        www = WWW.LoadFromCacheOrDownload(url2, 1);
        yield return www;

        if (!string.IsNullOrEmpty(www.error))
        {
            Debug.Log(www.error);
            yield break;
        }
        AssetBundle ab2 = www.assetBundle;
        if (need)
        {
            UIPackage.AddPackage(ab1, ab2);
            gc = UIPackage.CreateObject("load", "startPanel").asCom;
            pb = gc.GetChild("progress").asProgress;
            gf = pb.GetChild("n3").asTextField;
            GRoot.inst.AddChild(gc);
            pb.value = 0;
            //如果想改变进度值有一个动态的过程
            // pb.TweenValue(100, 3f);
        }
    }
   public static void setProgress(double val)
   {
      if (pb != null)
      {
        pb.value = val;
       }
   }
   public static void setTitle(string title)
   {
     if (gf != null)
     {
       gf.text = title;
     }
   }
   public static void Destory()
   {
        if (gc != null)
        {
            gc.Dispose();
        }
   }

}  

    
