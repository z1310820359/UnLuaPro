--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

local LonginData = {
    [1] = {
        Name = "新游戏",
        Index = 1,
        IconPath = "/Script/Engine.Texture2D'/Game/UI/Icon/buoumao.buoumao'",
    },
    [2] = {
        Name = "继续游戏",
        Index = 2,
        IconPath = "/Script/Engine.Texture2D'/Game/UI/Icon/caiquan.caiquan'",
    },
    [3] = {
        Name = "设置",
        Index = 3,
        IconPath = "/Script/Engine.Texture2D'/Game/UI/Icon/chanshu.chanshu'",
    },
    [4] = {
        Name = "退出游戏",
        Index = 4,
        IconPath = "/Script/Engine.Texture2D'/Game/UI/Icon/morequan.morequan'",
    },
    [5] = {
        Name = "test",
        Index = 5,
        IconPath = "/Script/Engine.Texture2D'/Game/UI/Icon/zhangao.zhangao'",
    },
}

---@type WBP_LoginView_C
local M = UnLua.Class()

function M:Initialize(Initializer)
    print("WBP_LoginView_C Initialize")
end

function M:PreConstruct(IsDesignTime)
    print("WBP_LoginView_C PreConstruct")
    -- UIManager:RegisterWidget("Login", self)
end

function M:Construct()
    -- 创建数据
    for i = 1, #LonginData do 
        local ObjectClass = UE.UClass.Load("/Game/UI/UIObj/BP_ItemData.BP_ItemData_C")
        local NewObj = NewObject(ObjectClass)
        NewObj.Name = LonginData[i].Name
        NewObj.Func = self.HandleItemClick
        NewObj.BinObj = self
        NewObj.Prame = LonginData[i].Index
        NewObj.IconPath = LonginData[i].IconPath
        self.ListView_96:AddItem(NewObj)
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:HandleItemClick(idx)
    if idx <= #LonginData then
        if idx == 1 then
            -- UIManager:RemoveWidgetByName("Login")
            -- UE.UGameplayStatics.OpenLevel(self, "Demo2")
            WorldService:LuaOpenLevel("Demo2")
        else 
            UIManager:RemoveWidgetByName("Login")
        end
    end
end

return M
