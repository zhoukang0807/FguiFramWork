require "Logic/LuaClass"
require "Logic/CtrlManager"
require "Common/functions"
require "Controller/PromptCtrl"
require "FairyGUI" 
FairyGUIGame = {};
local this = FairyGUIGame;

local game;
local transform;
local gameObject;
local WWW = UnityEngine.WWW;

local DesAB = {};
local ResAB = {};

function FairyGUIGame.InitViewPanels()
	for i = 1, #FairyUIs do
		require("Fairy/" .. tostring(FairyUIs[i]))
	end
end

--初始化完成，发送链接服务器信息--
function FairyGUIGame.OnInitOK()
	AppConst.SocketPort = 2012;
	AppConst.SocketAddress = "127.0.0.1";
	networkMgr:SendConnect();
	
	--注册LuaView--
	this.InitViewPanels(); 
	
	--加载UI
	this.LoadAllUI(function()
		--UI资源包加载完毕
		--显示第一个正式热更界面
		logError("资源加载完毕");
		coroutine.start(this.OpenView);
	end);
	
	logWarn('LuaFramework InitOK--->>>');
end

--开启加载UI资源包
function FairyGUIGame.LoadAllUI(callback)
	FairyAssetBundleIndex = 1;
	DesAB = {};
	ResAB = {};
	this.LoadUI(callback);
end

function FairyGUIGame.LoadUI(callback)
	logError(AssetBundles[FairyAssetBundleIndex]);
	resMgr:LoadAssetBundle(AssetBundles[FairyAssetBundleIndex], function(objs)
		if objs.Length == 0 then
			logError("LuaFramework 加载资源包失败," .. AssetBundles[FairyAssetBundleIndex]);
		else
			if not FairyAssetBundleBool then
				UIPackage.AddPackage(objs[0]);
			else
				if Util.StartWith(AssetBundles[FairyAssetBundleIndex], "desc_") then
					local name = Util.ReplaceStr(AssetBundles[FairyAssetBundleIndex], "desc_", "");
					DesAB[name] = objs[0];
					if ResAB[name] ~= nil then
						UIPackage.AddPackage(DesAB[name], ResAB[name]);
						DesAB[name] = nil;
						ResAB[name] = nil;
					end
				elseif Util.StartWith(AssetBundles[FairyAssetBundleIndex], "res_") then
					local name = Util.ReplaceStr(AssetBundles[FairyAssetBundleIndex], "res_", "")
					ResAB[name] = objs[0];
					if DesAB[name] ~= nil then
						UIPackage.AddPackage(DesAB[name], ResAB[name]);
						DesAB[name] = nil;
						ResAB[name] = nil;
					end
				end
			end
		end
		if FairyAssetBundleIndex == #AssetBundles then
			--加载完毕
			if callback ~= nil then
				callback();
			end
			return;
		end
		FairyAssetBundleIndex = FairyAssetBundleIndex + 1;
		this.LoadUI(callback);
	end);
end

--销毁--
function FairyGUIGame.OnDestroy()
	--logWarn('OnDestroy--->>>');
end

function FairyGUIGame.OpenView() 
	CtrlManager.Init();
	local ctrl = CtrlManager.GetCtrl(CtrlNames.Loading);
	if ctrl ~= nil and AppConst.ExampleMode == 1 then
		ctrl:Awake();
	end
end 