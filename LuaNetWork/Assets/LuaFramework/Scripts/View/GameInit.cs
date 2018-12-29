using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

namespace LuaFramework
{
    public class GameInit : Manager{
        // Use this for initialization

   void Awake()
        {
            Init();
        }

    void Init() {
            LuaManager.DoFile("Controller/GameCtrl");
            LuaManager.CallFunction("GameCtrl.New");
            if (Application.isMobilePlatform)
            {
                LuaManager.CallFunction("GameCtrl.Awake",true);
            }
            else {
                LuaManager.CallFunction("GameCtrl.Awake",false);
            }
           
        }

	
	// Update is called once per frame
	void Update ()
        {
            LuaManager.CallFunction("GameCtrl.Update");
        }
         
  }
}
