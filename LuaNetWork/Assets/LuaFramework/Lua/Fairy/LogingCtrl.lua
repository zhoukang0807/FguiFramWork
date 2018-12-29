require "Common/define" 
require 'FairyGUI'
LogingCtrl = {};
local this = LogingCtrl;
local view;
--构建函数--
function LogingCtrl.New()
	logWarn("LogingCtrl.New--->>");
	return this;
end

function LogingCtrl.Awake()
	logWarn("LogingCtrl.Awake--->>");
    view = UIPackage.CreateObject('login', 'loginpanel');
	GRoot.inst:AddChild(view);
	local button = view:GetChild("start");
	button.onClick:Add(this.onClick);
end
--点击事件--
function LogingCtrl.onClick()	
	local c1 = view:GetController("c1");
	c1.selectedIndex = 1; 
	local trans = view:GetTransition('t5');
	trans:Play();
	local form = view:GetChild("n43");
	local gobutton = form:GetChild("n52");
	gobutton.onClick:Add(this.onGoClick);
end 

function LogingCtrl.onGoClick()	
	view:Dispose();
	SceneMange._sceneToLoad = "game";
	SceneMange:LoadScene();
end  


 