using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharactorManager : Manager
{
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void FixedUpdate() {
        LuaManager.CallFunction("GameCtrl.FixedUpdate");
    }
    private void OnCollisionEnter2D(Collision2D collision)
    {
        LuaManager.CallFunction("GameCtrl.OnCollisionEnter2D", collision);
    } 
}
