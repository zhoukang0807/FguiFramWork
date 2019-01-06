require "Common/define"
require 'FairyGUI'
require "3rd/pblua/MoveDTO_pb"
require "3rd/pblua/test_pb"
require "3rd/pbc/protobuf"
local sproto = require "3rd/sproto/sproto"
local core = require "sproto.core"
local print_r = require "3rd/sproto/print_r"

GameCtrl = {};
local this = GameCtrl;

local panel;
local prompt;
local transform;
local gameObject;
local myrole;
local camera;
local animator;
local x,y,z = 0,0,0;
local spr;
local runable = false;
local speed =2.5;
local isMobile = false;
local joystick = false; -- 判断摇杆是否在移动
local view;
local textshowtime = 0;
local textview = 0;
local detiltime = 0;
local localPlayes = {};
local people = {};
local moves;
local playes;
local text = "很高兴为你服务，你现在使用的是kagnzw提供的游戏样例，整合了市场上较为方便的前后端框架，如果在使用的过程中有任何疑问欢迎加群123456提问。";

--构建函数--
function GameCtrl.New()
	logWarn("GameCtrl.New--->>");
	return this;
end

function GameCtrl.Awake(obj)
    isMobile = obj;
	logWarn("GameCtrl.Awake--->>");
	panelMgr:CreatePanel('role', this.OnCreate);
end

--启动事件--
function GameCtrl.OnCreate(obj)
    camera = GameObject.FindWithTag("GuiCamera");
	gameObject = obj;
	transform = obj.transform;
    transform.localScale = Vector3.New(1,1,1);
    transform.localRotation = Vector4.zero;
    transform.localPosition = Vector3.New(-40,80,1);
	logWarn("GameCtrl.OnCreate--->>");
	resMgr:LoadPrefab('role', { 'role' }, this.InitPanel);
end 

--摇杆移动--
function GameCtrl.JoystickMove(obj)
    joystick = true;
    local param = obj;
    if -105<param and param<=-75 then
      x = 0;
      y = 1;
    end
    if -75<param and param<=-15 then
      x =1;
      y =1;
    end
    if -15<param and param<= 15 then
      x =1;
      y =0;
    end
    if 15<param and param<= 75 then 
       x =1;
       y =-1;
    end
    if 75<param and param<=105 then 
        x =0;
        y =-1;
    end
    if 105<param and param<=165 then 
        x =-1;
        y =-1;
    end
    if (165<param and param<=180) or (param>=-180 and param <=-165) then 
        x =-1;
        y =0;
    end
    if -165<param and param<=-105 then 
        x =-1;
        y =1;
    end 
end  

--摇杆停止--
function GameCtrl.JoystickEnd()
    joystick = false;
end


function GameCtrl.Update()
    if view ~= nil and textshowtime >=0 then
        textshowtime = textshowtime +1;
        if(textshowtime < string.len(text)) then
            textview.text =  string.sub(text,0,textshowtime)
        else
            textview.text  = text;
            textshowtime = -1;
        end
    end
end
function GameCtrl.SendMove() 
    local path = Util.DataPath.."lua/3rd/pbc/MoveDTO.pb";
    local addr = io.open(path, "rb")
    local buffer = addr:read "*a"
    addr:close()
    protobuf.register(buffer)
    local movedo = {
        id = LogingCtrl.id,
        point = { x = tostring(myrole.transform.localPosition.x),y = tostring(myrole.transform.localPosition.y),z =tostring(myrole.transform.localPosition.z) },
        status = {x = tostring(x),y = tostring(y),runable = runable}
    }
    local code = protobuf.encode("msg.MoveDTO", movedo)
    local buffer = ByteBuffer.New();
    buffer:WriteShort(Protocal.Send_Move);
    buffer:WriteTString(code);
    networkMgr:SendMessage(buffer);
end
function GameCtrl.GetMoves() 
    local path = Util.DataPath.."lua/3rd/pbc/Result.pb";
    local addr = io.open(path, "rb")
    local buffer = addr:read "*a"
    addr:close()
    protobuf.register(buffer)
    local movestemp = {
    }
    local code = protobuf.encode("msg.MoveResult", movestemp)
    local buffer = ByteBuffer.New();
    buffer:WriteShort(Protocal.Get_Moves);
    buffer:WriteTString(code);
    networkMgr:SendMessage(buffer);
end
function GameCtrl.GetPlayes() 
    local path = Util.DataPath.."lua/3rd/pbc/Result.pb";
    local addr = io.open(path, "rb")
    local buffer = addr:read "*a"
    addr:close()
    protobuf.register(buffer)
    local playestemp = {
    }
    local code = protobuf.encode("msg.PlaysResult", playestemp)
    local buffer = ByteBuffer.New();
    buffer:WriteShort(Protocal.Get_Playes);
    buffer:WriteTString(code);
    networkMgr:SendMessage(buffer);
end
function GameCtrl.updateUsers()  
    if this.playes ~=nil then
        for key, value in pairs(this.playes) do  
            if localPlayes[value.id] == nil then
                localPlayes[value.id] = {}; 
                if(value.id ~=LogingCtrl.id) then
                    resMgr:LoadPrefab('role', { 'people' }, function(objs)
                        this.addpeople(objs,value.id);
                    end);
                end
            end
            localPlayes[value.id].UserName= value.UserName;  
        end 
        for key, value in pairs(localPlayes) do  
            local flag = true;
            for _, v in pairs(this.playes) do  
                if(v.id == key) then
                    flag = false;
                    break;
                end
            end
            -- 如果未找到该用户信息则删除该用户角色
            if(flag) then
                if(people[key] ~= nil) then
                    destroy(people[key]);
                    people[key] = nil;
                end
                if(localPlayes[key] ~= nil) then
                    localPlayes[key] = nil;
                end
            end
        end
    end
    if this.moves ~=nil then 
        for _, v in pairs(this.moves) do  
            if localPlayes[v.id] ~= nil and people[v.id] ~=nil then
                if(v.id ~=LogingCtrl.id) then
                    people[v.id].transform.localRotation = Vector4.zero; 
                    people[v.id].transform.localPosition = Vector3.New(tonumber(v.point.x),tonumber(v.point.y),tonumber(v.point.z)); 
                    local ani=  people[v.id]:GetComponent('Animator'); 
                    local x1 = tonumber(v.status.x);
                    local y1 = tonumber(v.status.y);
                    ani:SetFloat("x",x1);
                    ani:SetFloat("y",y1);
                    ani:SetBool("runable",v.status.runable);
                    if x1 > 0  then
                        people[v.id].transform.localScale = Vector3.New(-1,1,1);
                    else 
                        people[v.id].transform.localScale = Vector3.New(1,1,1);
                    end 
                end
            end   
        end 
    end
end

function GameCtrl.addpeople(objs,id)
    people[id] = newObject(objs[0]);  
end
    -- local movedo = MoveDTO_pb.MoveDTO();
    -- movedo.id = 12;
    -- local ver3 = MoveDTO_pb.Vector3();
    -- ver3.x = myrole.transform.localPosition.x;
    -- ver3.y = myrole.transform.localPosition.y;
    -- ver3.z = myrole.transform.localPosition.z;
    -- local target = ver3:SerializePartialToString()
    -- movedo.point:MergeFromString(target);
    -- local msg = movedo:SerializeToString();
    -- local buffer = ByteBuffer.New();
    -- buffer:WriteShort(Protocal.Send_Move);
    -- buffer:WriteTString(msg);
    -- networkMgr:SendMessage(buffer);
--启动事件--
function GameCtrl.FixedUpdate(obj)
    speed = 2.5;
    if(myrole ~= nil and detiltime >= 0.01) then
       detiltime = 0;
       this.SendMove();
       this.GetMoves();
       this.GetPlayes();
       this.updateUsers();
    else
        detiltime = detiltime+ Time.deltaTime;
    end
    local x1,y1,z1 = 0,0,0;
    if myrole ~= nil then  
        local ver3 = Vector3.New;
        if isMobile == true then
            x1 = x;
            y1 = y;
            if not joystick then
              x1 = 0;
              y1 = 0;
            end
        else 
            if Input.GetKey(KeyCode.A) then 
                x1 = -1;
            end
            if Input.GetKey(KeyCode.W) then 
                y1 = 1;
            end
            if Input.GetKey(KeyCode.S) then 
                y1 = -1;
            end
            if Input.GetKey(KeyCode.D) then 
                x1 = 1;
            end
            if Input.GetKey(KeyCode.Space) then 
            end 
        end
        
        if x1 == 0 and y1 == 0 then
           speed = 0
           x1 = x;
           y1 = y;
           runable = false;
        else 
            x = x1;
            y = y1;
            runable = true;
        end
        
        animator:SetFloat("x",x1);
        animator:SetFloat("y",y1);
        animator:SetBool("runable",runable);
        if speed ~=0 then
            ver3 = Vector3.New(speed * x1 * Time.deltaTime,speed * y1 * Time.deltaTime,0);
            myrole.transform:Translate(ver3);
        end
        if x1 > 0  then
            myrole.transform.localScale = Vector3.New(-1,1,1);
        else 
            myrole.transform.localScale = Vector3.New(1,1,1);
        end  
        myrole.transform.localRotation =  Vector3.zero;
        camera.transform.localPosition = Vector3.New(myrole.transform.localPosition.x,myrole.transform.localPosition.y,-10);
    end
end 

function GameCtrl.OnCollisionEnter2D(collider)
    if collider~=nil then
        local tag = collider.transform.tag;
        if tag == "juqing" and view ==nil then
            view = UIPackage.CreateObject('talk', 'talkmodal');
            GRoot.inst:AddChild(view);
            local c1 = view:GetController("c1");
            c1.selectedIndex = 1; 
             textview = view:GetChild("n5");
             textshowtime=0;
            local button = view:GetChild("n15");
            button.onClick:Add(this.onClickSkip);
        else
            local c1 = view:GetController("c1");
            c1.selectedIndex = 1; 
            textshowtime=0;
        end
        logWarn("OnCollisionEnter2D---222>>"..tag);
    end
end

function GameCtrl.onClickSkip()
    logWarn("onClickSkip---222>>");
    if(textshowtime == -1) then
        view:Dispose();
        view = nil;
    end
    textshowtime = 1000;
end

--初始化面板--
function GameCtrl.InitPanel(objs)
	local count = 1;  
	for i = 1, count do
		myrole = newObject(objs[0]);  
        myrole.transform.localScale = Vector3.one;
        myrole.transform.localRotation = Vector4.zero; 
        myrole.transform.localPosition = Vector3.New(0,0,-1); 
        animator= myrole:GetComponent('Animator'); 
        logWarn("animator--->>");
	end
end
 

--滚动项单击--
function GameCtrl.OnItemClick(go)
    log(go.name);
end 

--单击事件--
function GameCtrl.OnClick(go)
	if TestProtoType == ProtocalType.BINARY then
		this.TestSendBinary();
	end
	if TestProtoType == ProtocalType.PB_LUA then
        --this.TestSendPblua();
        this.TestSendTestLua();
	end
	if TestProtoType == ProtocalType.PBC then
		this.TestSendPbc();
	end
	if TestProtoType == ProtocalType.SPROTO then
		this.TestSendSproto();
	end
	logWarn("OnClick---->>>"..go.name);
end

--测试发送SPROTO--
function GameCtrl.TestSendSproto()
    local sp = sproto.parse [[
    .Person {
        name 0 : string
        id 1 : integer
        email 2 : string

        .PhoneNumber {
            number 0 : string
            type 1 : integer
        }

        phone 3 : *PhoneNumber
    }

    .AddressBook {
        person 0 : *Person(id)
        others 1 : *Person
    }
    ]]

    local ab = {
        person = {
            [10000] = {
                name = "Alice",
                id = 10000,
                phone = {
                    { number = "123456789" , type = 1 },
                    { number = "87654321" , type = 2 },
                }
            },
            [20000] = {
                name = "Bob",
                id = 20000,
                phone = {
                    { number = "01234567890" , type = 3 },
                }
            }
        },
        others = {
            {
                name = "Carol",
                id = 30000,
                phone = {
                    { number = "9876543210" },
                }
            },
        }
    }
    local code = sp:encode("AddressBook", ab)
    ----------------------------------------------------------------
    local buffer = ByteBuffer.New();
    buffer:WriteShort(Protocal.Message);
    buffer:WriteByte(ProtocalType.SPROTO);
    buffer:WriteBuffer(code);
    networkMgr:SendMessage(buffer);
end

--测试发送PBC--
function GameCtrl.TestSendPbc()
    local path = Util.DataPath.."lua/3rd/pbc/addressbook.pb";

    local addr = io.open(path, "rb")
    local buffer = addr:read "*a"
    addr:close()
    protobuf.register(buffer)

    local addressbook = {
        name = "Alice",
        id = 12345,
        phone = {
            { number = "1301234567" },
            { number = "87654321", type = "WORK" },
        }
    }
    local code = protobuf.encode("tutorial.Person", addressbook)
    ----------------------------------------------------------------
    local buffer = ByteBuffer.New();
    buffer:WriteShort(Protocal.Message);
    buffer:WriteByte(ProtocalType.PBC);
    buffer:WriteBuffer(code);
    networkMgr:SendMessage(buffer);
end

--测试发送PBLUA--
function GameCtrl.TestSendPblua()
    local login = login_pb.LoginRequest();
    login.id = 2000;
    login.name = 'game';
    login.email = '0jarjin@163.com';
    local msg = login:SerializeToString();
    ----------------------------------------------------------------
    local buffer = ByteBuffer.New();
    buffer:WriteShort(Protocal.Message);
    buffer:WriteByte(ProtocalType.PB_LUA);
    buffer:WriteBuffer(msg);
    networkMgr:SendMessage(buffer);
end

function GameCtrl.TestSendTestLua()
    local pbinfo = test_pb.Person();
    pbinfo.id = 11;
    pbinfo.name = "1";
    pbinfo.email = "1";
    local msg = pbinfo:SerializeToString();
    ----------------------------------------------------------------
    local buffer = ByteBuffer.New();
    buffer:WriteShort(2*256);
    buffer:WriteString(msg);
    networkMgr:SendMessage(buffer);
end

--测试发送二进制--
function GameCtrl.TestSendBinary()
    local buffer = ByteBuffer.New();
    buffer:WriteShort(Protocal.Message);
    buffer:WriteByte(ProtocalType.BINARY);
    buffer:WriteString("ffff我的ffffQ靈uuu");
    buffer:WriteInt(200);
    networkMgr:SendMessage(buffer);
end

--关闭事件--
function GameCtrl.Close()
	panelMgr:ClosePanel(CtrlNames.Prompt);
end