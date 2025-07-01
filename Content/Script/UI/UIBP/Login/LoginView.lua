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
    },
    [2] = {
        Name = "继续游戏",
        Index = 2,
    },
    [3] = {
        Name = "设置",
        Index = 3,
    },
    [4] = {
        Name = "退出游戏",
        Index = 4,
    },
}

---@type WBP_LoginView_C
local M = UnLua.Class()

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    -- 创建数据
    for i = 1, #LonginData do 
        local ObjectClass = UE.UClass.Load("/Game/UI/UIObj/BP_ItemData.BP_ItemData_C")
        local NewObj = NewObject(ObjectClass)
        NewObj.Name = LonginData[i].Name
        NewObj.Func = self.HandleItemClick
        NewObj.BinObj = self
        NewObj.Prame = LonginData[i].Index
        self.ListView_96:AddItem(NewObj)
    end

end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:HandleItemClick(idx)
    if idx <= #LonginData then
        print(LonginData[idx].Name)
    end
end

return M
