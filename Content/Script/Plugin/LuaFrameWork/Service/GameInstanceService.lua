

local GameInstanceService = UnLua.Class()
local EventDispatcher = require "Plugin.LuaFrameWork.Utils.EventDispatcher"


function GameInstanceService:LuaInit()
    print("GameIns LuaInit")
    _G.GameInstanceService = self
    ---@type EventDispatcher
    _G.EventSys = EventDispatcher:New()
    ---@type EventDispatcher
    _G.EventUISys = EventDispatcher:New()
end

function GameInstanceService:LuaDeinit()
    print("GameIns LuaDeinit")
end

function _G.ReceiveNotifyFromC(eventName, ...)
    print("ReceiveNotifyFromC")
    -- EventSys:Dispatch(eventName, ...)
end

return GameInstanceService