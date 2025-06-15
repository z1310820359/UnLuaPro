

local GameInstanceService = UnLua.Class()

function GameInstanceService:LuaInit()
    print("GameIns LuaInit")
    _G.GameInstanceService = self
end

function GameInstanceService:LuaDeinit()
    print("GameIns LuaDeinit")
end

function _G.ReceiveNotifyFromC(eventName, ...)
    print("ReceiveNotifyFromC")
    -- EventSys:Dispatch(eventName, ...)
end

return GameInstanceService