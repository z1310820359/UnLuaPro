--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
local InputCfg = require "Cfg.InputCfg"
local ControllerCfg = require "Cfg.ControllerCfg"

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

function M:Initialize(Initializer)
    print("BP_ControllerPhysics_C Initialize")
    InputManager:RegisterInputAction("IA_ChangePawn", InputCfg.ActionEvent.Completed, self, self.ShowMouse)
    EventSys:AddEventListener("OnWorldChange", self.ChangeWorldPawn, self)
end
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
-- function M:ReceiveBeginPlay()
--     print("ReceiveBeginPlay")
--     InputManager:RegisterInputAction("IA_ChangePawn", InputCfg.ActionEvent.Completed, self, self.ChangeCtr)
-- end

-- function M:ReceiveEndPlay()
--     print("ReceiveEndPlay")
--     InputManager:UnRegisterInputAction("IA_ChangePawn", InputCfg.ActionEvent.Completed, self)
-- end

function M:ChangeCtr(Path)
    print("ChangeCtr")
    local world = self:GetWorld()
    local AlwasSpawn = UE.ESlateParentWindowSearchMethod.AlwasSpawn
    local ActorClass = UE.UClass.Load(Path)
    local Transform = UE.FTransform()
    local pawn = world:SpawnActor(ActorClass, Transform, AlwasSpawn)
    self:Possess(pawn)
end

function M:ChangeWorldPawn(Event, worldName)
    if ControllerCfg.Ctr_Pawn[worldName] then
        UE.UKismetSystemLibrary.K2_SetTimerDelegate({self,
            function() self:ChangeCtr(ControllerCfg.Ctr_Pawn[worldName]) end
        }, 0.1, false)
    end
end

function M:ShowMouse(Data)
    self.bShowMouseCursor = not self.bShowMouseCursor
end

function M:ReceiveDestroyed()
    print("BP_ControllerPhysics_C ReceiveDestroyed")
    InputManager:UnRegisterInputAction("IA_ChangePawn", InputCfg.ActionEvent.Completed, self)
    EventSys:RemoveEventListener("OnWorldChange", self.ChangeWorldPawn, self)
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
