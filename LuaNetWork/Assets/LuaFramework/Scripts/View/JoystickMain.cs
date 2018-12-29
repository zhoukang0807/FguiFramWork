using UnityEngine;
using FairyGUI;
using UnityEngine;
using LuaInterface;


public class JoystickMain : Manager
{
	GComponent _mainView;
	GTextField _text;
	JoystickModule _joystick;

	void Start()
	{ 
        Application.targetFrameRate = 60;
		Stage.inst.onKeyDown.Add(OnKeyDown);

		_mainView = this.GetComponent<UIPanel>().ui;

		//_text = _mainView.GetChild("n4").asTextField;

		_joystick = new JoystickModule(_mainView);
		_joystick.onMove.Add(__joystickMove);
		_joystick.onEnd.Add(__joystickEnd);
	}

	void __joystickMove(EventContext context)
	{
       
        float degree = (float)context.data;
		//_text.text = "" + degree;
        LuaManager.CallFunction("GameCtrl.JoystickMove", degree);
    }

	void __joystickEnd()
	{
        //_text.text = "";
        LuaManager.CallFunction("GameCtrl.JoystickEnd");
    }

	void OnKeyDown(EventContext context)
	{
		if (context.inputEvent.keyCode == KeyCode.Escape)
		{
			Application.Quit();
		}
	}
}