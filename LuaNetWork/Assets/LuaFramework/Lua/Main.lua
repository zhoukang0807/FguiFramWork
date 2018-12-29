local breakSocketHandle,debugXpCall = require("LuaDebugjit")("localhost",7003)
local timer = Timer.New(function() 
breakSocketHandle() end, 1, -1, false)
timer:Start(); 
--主入口函数。从这里开始lua逻辑
function Main()		  
	UpdateBeat:Add(Update, self)
	print("logic start")	 
end 
 
function Update() 
	if SceneMange.async ~=nil then
		 print(SceneMange.async.progress)
		 if SceneMange.async.progress < 0.899 then
			SceneMange.nowProcess = SceneMange.async.progress  * 100;
		 else if SceneMange.async.progress > 0.899 then
			SceneMange.nowProcess = 100;
			SceneMange.async.allowSceneActivation = true;
			SceneMange.async = nil; 
		 end
		 end
	end
end
--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end

function OnApplicationQuit()
end