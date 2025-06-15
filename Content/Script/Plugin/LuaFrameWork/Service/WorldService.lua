local WorldService = UnLua.Class()


function WorldService:LuaInit()
    print("WorldService:LuaInit")
end

function WorldService:LuaPostInit()
    print("WorldService:LuaPostInit")
end

function WorldService:LuaOnWorldBeginPlay()
    print("WorldService:LuaOnWorldBeginPlay")

    local path = '/Game/Test/NewBlueprint.NewBlueprint_C'
    local widget = self:GetWidgetByPath(path)
    widget:AddToViewport()
end

function WorldService:LuaDeinit()
    print("WorldService:LuaDeinit")
end

return WorldService