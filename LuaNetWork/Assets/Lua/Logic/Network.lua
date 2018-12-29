
require "Common/define"
require "Common/protocal"
require "Common/functions"
Event = require 'events'
 
require "3rd/pblua/Cuser_pb"
require "3rd/pbc/protobuf"

local sproto = require "3rd/sproto/sproto"
local core = require "sproto.core"
local print_r = require "3rd/sproto/print_r"

Network = {};
local this = Network;

local transform;
local gameObject;
local islogging = false;

function Network.Start() 
    logWarn("Network.Start!!");
    Event.AddListener(Protocal.Login, this.OnMessage); 

    Event.AddListener(Protocal.Connect, this.OnConnect); 
    Event.AddListener(Protocal.Exception, this.OnException); 
    Event.AddListener(Protocal.Disconnect, this.OnDisconnect); 
end

--Socket消息--
function Network.OnSocket(key, data)
    Event.Brocast(tostring(key), data);
end

--当连接建立时--
function Network.OnConnect() 
    logWarn("Game Server connected!!");
end

--异常断线--
function Network.OnException() 
    islogging = false; 
    NetManager:SendConnect();
   	logError("OnException------->>>>");
end

--连接中断，或者被踢掉--
function Network.OnDisconnect() 
    islogging = false; 
    logError("OnDisconnect------->>>>");
end

--登录返回--
function Network.OnMessage(buffer) 
    this.TestLoginPblua(buffer);
    logWarn('OnMessage-------->>>');
end

--PBLUA登录--
function Network.TestLoginPblua(buffer)
	local data = buffer:ReadTString();

    local msg = Cuser_pb.CUser();
    msg:ParseFromString(data);
	log('TestLoginPblua: protocal:>' ..' msg:>'..msg.username..msg.password);
end

--卸载网络监听--
function Network.Unload()
    Event.RemoveListener(Protocal.Login);--Protocal.Message

    Event.RemoveListener(Protocal.Connect);
    Event.RemoveListener(Protocal.Exception);
    Event.RemoveListener(Protocal.Disconnect);
    logWarn('Unload Network...');
end