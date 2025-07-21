local WorldService = UnLua.Class()

local ServicesList = {
    UIManager = "Service.UIManager",
    InputManager = "Service.InputManager",
}

require("LuaPanda").start("127.0.0.1", 8818)
function WorldService:LuaInit()
    self._managerList = {}
    print("WorldService:LuaInit")
    for k,v in pairs(ServicesList) do
        local manager = require(v)
        if manager and manager.LuaInit then
            manager:LuaInit()
            self._managerList[k] = manager
            _G[k] = manager
        end
    end
    _G.WorldService = self
    self._nowWorldName = nil
    self._NewWorldName = nil
    self._NowWorld = nil
end

function WorldService:LuaPostInit()
    print("WorldService:LuaPostInit")
    for _, v in pairs(self._managerList) do
        if v.LuaPostInit then
            v:LuaPostInit()
        end
    end
end

function WorldService:LuaOnWorldBeginPlay(InWorld)
    print("WorldService:LuaOnWorldBeginPlay")
    self._nowWorldName = UE.UKismetSystemLibrary.GetObjectName(InWorld)
    self._NowWorld = InWorld
    for _, v in pairs(self._managerList) do
        if v.LuaOnWorldBeginPlay then
            v:LuaOnWorldBeginPlay(InWorld)
        end
    end
    EventSys:Dispatch("OnWorldChange", self._nowWorldName)
    self._NewWorldName = nil
    self._NowWorld = nil
    self._managerList = {}
end

function WorldService:LuaDeinit()
    print("WorldService:LuaDeinit")
    for _, v in pairs(self._managerList) do
        if v.LuaDeinit then
            v:LuaDeinit()
        end
    end
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
    return self._NewWorldName
end

return WorldService