local WorldService = UnLua.Class()
local UIManager = require "Service.UIManager"
local InputManager = require "Service.InputManager"
_G.UIManager = UIManager
_G.InputManager = InputManager

require("LuaPanda").start("127.0.0.1", 8818)
function WorldService:LuaInit()
    print("WorldService:LuaInit")
    UIManager:LuaInit()
    InputManager:LuaInit()
    _G.WorldService = self
    self._NewWorldName = nil
    self._NowWorld = nil
end

function WorldService:LuaPostInit()
    print("WorldService:LuaPostInit")
    UIManager:LuaPostInit()
    InputManager:LuaPostInit()
end

function WorldService:LuaOnWorldBeginPlay(InWorld)
    print("WorldService:LuaOnWorldBeginPlay")
    self._NowWorld = InWorld
    UIManager:LuaOnWorldBeginPlay(InWorld)
    InputManager:LuaOnWorldBeginPlay(InWorld)
    -- print(UE.UKismetSystemLibrary.GetObjectName(InWorld))
end

function WorldService:LuaDeinit()
    print("WorldService:LuaDeinit")
    UIManager:LuaDeinit()
    InputManager:LuaDeinit()
end

function WorldService:LuaOpenLevel(WorldName)
    -- UIManager:RemoveAllWidget()
    self._NewWorldName = WorldName
    UE.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.LuaOpenLevelInner}, 0.5, false)
end

function WorldService:LuaOpenLevelInner()
    if self._NewWorldName then
        UE.UGameplayStatics.OpenLevel(self, self._NewWorldName)
    end
end

function WorldService:LuaGetWorld()
    return self._NowWorld
end

function WorldService:LuaGetWorldName()
    if self._NowWorld then
        return UE.UKismetSystemLibrary.GetObjectName(self._NowWorld)
    end
end

return WorldService