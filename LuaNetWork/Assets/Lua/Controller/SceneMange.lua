require "Common/define" 
require 'FairyGUI'
SceneMange = {};
local view;
local this = SceneMange;
local _Instance = nil; 
function SceneMange.New()
    logWarn("SceneMange.Init--->>");
    this.nowProcess = 0;
    this.LoadingScreenSceneName = "LoadingScence"
    this._sceneToLoad = "";
    this.async = nil;
    UpdateBeat:Add(this.Update, self)
    return this
end
 
function SceneMange.LoadScene()
	logWarn("SceneMange.LoadScene--->>");
    this.nowProcess = 0;     
    Application.backgroundLoadingPriority = ThreadPriority.High;
    if  this.LoadingScreenSceneName ~= nil  then
    SceneManagement.SceneManager.LoadScene(this.LoadingScreenSceneName);
    view = UIPackage.CreateObject('jumpscene', 'jumppanel');
	GRoot.inst:AddChild(view);
    end
    coroutine.start(this.LoadAimScene);
end 
function SceneMange.Update( )
    logWarn("SceneMange.update--->>");
end

function SceneMange.Destory()
    view:Dispose();
end 

function SceneMange.LoadAimScene()
    coroutine.wait(1);	
    this.async = SceneManagement.SceneManager.LoadSceneAsync(this._sceneToLoad);
    this.async.allowSceneActivation = false;
    this.Destory(); 
end 

function SceneMange.InitNewScene()
    if this._sceneToLoad == SceneNames[1] then
        local game = PromptCtrl.New();
        game:Awake();
	end
	logWarn("InitNewScene---->>>"..SceneNames[1]);
end 
