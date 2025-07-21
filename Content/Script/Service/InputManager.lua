
---@type ArrayUtil
local ArrayUtil = require "Plugin.LuaFrameWork.Utils.ArrayUtil"
local InputCfg = require "Cfg.InputCfg"

---@type InputManager
local InputManager = UnLua.Class();

function InputManager:LuaInit()
    print("InputManager LuaInit")
    self._KeyActions = {}
    self._BindObject = {}
end

function InputManager:LuaPostInit()
    print("InputManager:LuaPostInit")
end

function InputManager:LuaOnWorldBeginPlay(InWorld)
    print("InputManager:LuaOnWorldBeginPlay")

end

function InputManager:LuaDeinit()
    print("InputManager LuaDeinit")
    self._KeyActions = {}
    self._BindObject = {}
end

function InputManager:SetupKeyBindings(Ctrl)
    print("SetupKeyBindings")
    local WorldName = WorldService:LuaGetWorldName()
    for k, v in pairs(InputCfg.IA_Defauts) do
        local IA = InputCfg.IA_Paths[v]
        self:InputBindAction(Ctrl, IA, v)
    end
    if InputCfg.LevelMap[WorldName] then
        for k, v in pairs(InputCfg.LevelMap[WorldName]) do
            local IA = InputCfg.IA_Paths[v]
            self:InputBindAction(Ctrl, IA, v)
        end
    end
end

function InputManager:InputBindAction(Ctrl, IA, IA_Name)
    local BindAction = UnLua.EnhancedInput.BindAction
    for _, v in pairs(InputCfg.ActionEvent) do
        BindAction(Ctrl, IA, v, function(Ctr, ActionValue, ElapsedScd, TriggerdScd)
            InputManager:HandleActionEvent(IA_Name, v, ActionValue, ElapsedScd, TriggerdScd)
        end)
    end
end


function InputManager:HandleActionEvent(ActionName, TriggerEvent, ActionValue, ElapsedScd, TriggerdScd)
    if self._KeyActions[ActionName] and self._KeyActions[ActionName][TriggerEvent] then
        for _, v in pairs(self._KeyActions[ActionName][TriggerEvent]) do
            if #v == 3 then
                v[3].ActionValue = ActionValue
                v[3].ElapsedScd = ElapsedScd
                v[3].TriggerdScd = TriggerdScd
                v[2](v[1], v[3])
            end
        end
    end
end

-- 注册
function InputManager:RegisterInputAction(ActionName, TriggerEvent, Obj, CallBack, Prame)
    Prame = Prame or {}
    if not self._KeyActions[ActionName] then
        self._KeyActions[ActionName] = {}
    end
    if not self._KeyActions[ActionName][TriggerEvent] then
        self._KeyActions[ActionName][TriggerEvent] = {}
    end
    if not self._KeyActions[ActionName][TriggerEvent] then
        self._KeyActions[ActionName][TriggerEvent] = {}
    end
    local len = #self._KeyActions[ActionName][TriggerEvent] + 1
    self._KeyActions[ActionName][TriggerEvent][len] = {Obj, CallBack, Prame}
end

-- 反注册
function InputManager:UnRegisterInputAction(ActionName, TriggerEvent, Obj)
    if self._KeyActions[ActionName] then
        if self._KeyActions[ActionName][TriggerEvent] then
            for k, v in pairs(self._KeyActions[ActionName][TriggerEvent]) do
                if v[1] == Obj then
                    self._KeyActions[ActionName][TriggerEvent][k] = nil
                end
            end
            ArrayUtil.ClearAllZeroElement(self._KeyActions[ActionName][TriggerEvent])
        end
    end
end

return InputManager