--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
local InputCfg = require "Cfg.InputCfg"

---@type BP_CharacterDemo1_C
local M = UnLua.Class()

function M:Initialize(Initializer)
    print("BP_CharacterDemo1_C Initialize")
end

-- function M:UserConstructionScript()
-- end

function M:ReceiveBeginPlay()
    InputManager:RegisterInputAction("IA_Look", InputCfg.ActionEvent.Triggered, self, self.LookAtTarget)
    InputManager:RegisterInputAction("IA_Jump", InputCfg.ActionEvent.Started, self, self.LuaStartJump)
    InputManager:RegisterInputAction("IA_Jump", InputCfg.ActionEvent.Completed, self, self.LuaStopJump)
    InputManager:RegisterInputAction("IA_Move", InputCfg.ActionEvent.Triggered, self, self.MoveTarget)
end

function M:ReceiveEndPlay()
    InputManager:UnRegisterInputAction("IA_Look", InputCfg.ActionEvent.Triggered, self)
    InputManager:UnRegisterInputAction("IA_Jump", InputCfg.ActionEvent.Started, self)
    InputManager:UnRegisterInputAction("IA_Jump", InputCfg.ActionEvent.Completed, self)
    InputManager:UnRegisterInputAction("IA_Move", InputCfg.ActionEvent.Triggered, self)
end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end
-- function M:ReceiveDestroyed()

-- end


function M:LookAtTarget(Data)
    local ActionValue = Data.ActionValue
    self:AddControllerYawInput(-ActionValue.X)
    self:AddControllerPitchInput(ActionValue.Y)
end

function M:LuaStartJump(Data)
    self:Jump()
end

function M:LuaStopJump(Data)
    self:StopJumping()
end

function M:MoveTarget(Data)
    local vec = self:GetControlRotation()
    local NewVec = UE.FRotator(0, vec.Yaw, vec.Roll)
    local Target = UE.UKismetMathLibrary.GetRightVector(NewVec)
    self:AddMovementInput(Target, Data.ActionValue.X)
    local NewVec2 = UE.FRotator(0, vec.Yaw, 0)
    local Target2 = UE.UKismetMathLibrary.GetForwardVector(NewVec2)
    self:AddMovementInput(Target2, Data.ActionValue.Y)
end

function M:ReceiveUnpossessed(OldController)
    self:K2_DestroyActor()
end

return M
