require "Common/define" 
require 'FairyGUI'

LoadingCtrl = {};
local this = LoadingCtrl;

--构建函数--
function LoadingCtrl.New()
	logWarn("LoadingCtrl.New--->>");
	return this;
end

function LoadingCtrl.Awake()
	logWarn("LoadingCtrl.Awake--->>");
	local view = UIPackage.CreateObject('loadPanel', 'GLoading')
	GRoot.inst:AddChild(view)
	local pb = view:GetChild("pbgress");
	pb:TweenValue(100, 3);
end

--启动事件--
function LoadingCtrl.OnCreate(obj)
 
end 