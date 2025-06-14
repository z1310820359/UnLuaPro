--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type NewBlueprint_C
local M = UnLua.Class()

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.Button_52.OnClicked:Add(self, self.PrintHello)
end

function M:PrintHello()
    print("Hello World!")
    self.TextBlock_63:SetText("Hello World!")
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return M
