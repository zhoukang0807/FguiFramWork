require "Common/define" 
require 'FairyGUI'
require "3rd/pblua/Cuser_pb"
require "Common/protocal"
LogingCtrl = {};
local this = LogingCtrl;
local view;
local id = 0;
local username = "";
local password = "";
local form;

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
    form = view:GetChild("n43"); 
	local gobutton = form:GetChild("n52");
	gobutton.onClick:Add(this.onGoClick);
end 

function LogingCtrl.onGoClick()	
	username = form:GetChild("username").text;
	password = form:GetChild("password").text;
	local cuser = Cuser_pb.CUser();
	cuser.id = 0;
    cuser.username = username;
    cuser.password = password;
    local msg = cuser:SerializeToString();
    local buffer = ByteBuffer.New();
    buffer:WriteShort(Protocal.Login);
    buffer:WriteTString(msg);
	networkMgr:SendMessage(buffer);
	
	view:Dispose();
	SceneMange._sceneToLoad = "game";
	SceneMange:LoadScene();
end  


 