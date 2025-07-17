--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_ControllerPhysics_C
local M = UnLua.Class()

function M:Initialize(Initializer)
    print("BP_ControllerPhysics_C")
end

-- function M:UserConstructionScript()
-- end

-- function M:HandleCick(key)
--     print(key.Name)
-- end

InputManager:SetupKeyBindings(M)
-- local BindKey = UnLua.Input.BindKey

-- BindKey(M, "C", "Pressed", function(self, Key)
--     print("按下了C")
-- end)

-- BindKey(M, "C", "Pressed", function(self, Key)
--     print("复制")
-- end, { Ctrl = true })

-- BindKey(M, "V", "Pressed", function(self, Key)
--     print("按下了V")
-- end)

-- BindKey(M, "V", "Pressed", function(self, Key)
--     print("粘贴")
-- end, { Ctrl = true })

function M:ReceiveEndPlay()
end
-- local BindAction = UnLua.EnhancedInput.BindAction
-- local IA = "/Script/EnhancedInput.InputAction'/Game/Input/Actions/IA_Jump.IA_Jump'"
-- BindAction(M, IA, "Triggered", function(obj, a,b,c,d)
--     print("aaaaaa")
-- end)

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

-- function M:F_Released()
--     local BindKey = UnLua.Input.BindKey
--     print(self)
--     BindKey(self, "B", "Pressed", function(self, Key)
--         print("按下了B")
--     end)
-- end



return M
