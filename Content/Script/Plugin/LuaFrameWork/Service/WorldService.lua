local WorldService = UnLua.Class()
local UIManager = require "Service.UIManager"
_G.UIManager = UIManager

require("LuaPanda").start("127.0.0.1", 8818)
function WorldService:LuaInit()
    print("WorldService:LuaInit")
    UIManager:LuaInit()
    _G.WorldService = self
    self._NewWorldName = nil
end

function WorldService:LuaPostInit()
    print("WorldService:LuaPostInit")
    UIManager:LuaPostInit()
end

function WorldService:LuaOnWorldBeginPlay(InWorld)
    print("WorldService:LuaOnWorldBeginPlay")
    UIManager:LuaOnWorldBeginPlay(InWorld)

    -- print(UE.UKismetSystemLibrary.GetObjectName(InWorld))
end

function WorldService:LuaDeinit()
    print("WorldService:LuaDeinit")
    UIManager:LuaDeinit()
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

return WorldService