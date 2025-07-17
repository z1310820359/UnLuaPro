
---@type InputManager
local InputManager = UnLua.Class();

function InputManager:LuaInit()
    print("InputManager LuaInit")
    self._KeyActions = {}
end

function InputManager:LuaPostInit()
    print("InputManager:LuaPostInit")
end

function InputManager:LuaOnWorldBeginPlay(InWorld)
    print("InputManager:LuaOnWorldBeginPlay")

end

function InputManager:LuaDeinit()
    print("InputManager LuaDeinit")
end


function InputManager:OnGameKeyDown(GameplayKeyType, bDown)
    local Actions = self._KeyActions and self._KeyActions[GameplayKeyType]
    if not Actions then
        return
    end
    if bDown then
        local OnPressed = Actions and Actions.OnPressed
        if OnPressed then
            OnPressed()
        end
    else
        local OnReleased = Actions and Actions.OnReleased
        if OnReleased then
            OnReleased()
        end
    end
end

function InputManager:RegistKeys()
end

function InputManager:UnRegistKeys()
    self._KeyActions = {}
end

function InputManager:RegistKeyPressed(Scope, Func, Type, Push, CreateKey)
    if not Scope or not Func or not Type then
        return
    end
	
    local TypedAction = self._KeyActions and self._KeyActions[Type]
	local OnPressedFunc = function()
        Func(Scope)
	end
	
	if TypedAction then
		TypedAction.OnPressed = OnPressedFunc
	elseif CreateKey then
		if not self._KeyActions then
			self._KeyActions = {}
		end
		
		self._KeyActions[Type] = { 
			Type = Type, 
			OnPressed = OnPressedFunc,
		}
	end
end

function InputManager:UnRegistKeyPressed(Type)
    if not self._KeyActions then
        return
    end
    local TypedAction = self._KeyActions[Type]
    if TypedAction then
        TypedAction.OnPressed = nil
    end
end

function InputManager:RegistKeyReleased(Scope, Func, Type, CreateKey)
    if not Scope or not Func or not Type then
        return
    end
    local TypedAction = self._KeyActions and self._KeyActions[Type]
	local OnReleasedFunc = function()
		Func(Scope)
	end
    if TypedAction then
        TypedAction.OnReleased = OnReleasedFunc
	elseif CreateKey then
		if not self._KeyActions then
			self._KeyActions = {}
		end

		self._KeyActions[Type] = {
			Type = Type,
			OnReleased = OnReleasedFunc,
		}
    end
end

function InputManager:UnRegistKeyReleased(Type)
    if not self._KeyActions then
        return
    end
    local TypedAction = self._KeyActions[Type]
    if TypedAction then
        TypedAction.OnReleased = nil
    end
end

function InputManager:SetupKeyBindings(Ctrl)
    print("SetupKeyBindings")
    local WorldName = WorldService:LuaGetWorldName()
    local InputCfg = require "Cfg.InputCfg"
    for k, v in pairs(InputCfg.IA_Defauts) do
        local IA = InputCfg.IA_Paths[v]
        self:InputBindAction(Ctrl, IA, v)
    end
    print("WorldName: " .. WorldName)
    if InputCfg.LevelMap[WorldName] then
        for k, v in pairs(InputCfg.LevelMap[WorldName]) do
            local IA = InputCfg.IA_Paths[v]
            self:InputBindAction(Ctrl, IA, v)
        end
    end
    -- local key_names = {
    --     -- 字母
    --     "A", "B", --[["C",]] "D", "E","F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", --[["V", ]] "W", "X", "Y", "Z",
    --     -- 数字
    --     "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine",
    --     -- 小键盘
    --     "NumPadOne", "NumPadTwo", "NumPadThree", "NumPadFour", "NumPadFive", "NumPadSix", "NumPadSeven", "NumPadEight", "NumPadNine",
    --     -- 方向键
    --     "Up", "Down", "Left", "Right",
    --     -- ProjectSettings -> Engine - Input -> Action Mappings
    --     "Fire", "Aim",
    -- }
    
    -- for _, key_name in ipairs(key_names) do
    --     Ctrl[key_name .. "_Pressed"] = function(Ctrl, key)
    --         Func(Ctrl, key)
    --         self:HandleCick(key)
    --     end
    -- end

    -- Ctrl["LeftMouseButton_Pressed"] = function(Ctrl, key)
    --     print(key.KeyName)
    -- end
end

-- function InputManager:HandleCick(key)
--     print("InputManager")
-- end

function InputManager:InputBindAction(Ctrl, IA, IA_Name)
    local BindAction = UnLua.EnhancedInput.BindAction
    print(IA_Name .. " : ".. IA)
    BindAction(Ctrl, IA, "Triggered", function(Ctrl, A, B, C)
        self.HandleActionTriggered(IA_Name, Ctrl, A, B, C)
    end)
    BindAction(Ctrl, IA, "Started", self.HandleActionStarted)
    BindAction(Ctrl, IA, "Ongoing", self.HandleActionOngoing)
    BindAction(Ctrl, IA, "Canceled", self.HandleActionCanceled)
    BindAction(Ctrl, IA, "Completed", self.HandleActionCompleted)
end

function InputManager:HandleActionTriggered(ActionName, Ctrl, A)
    print("HandleActionTriggered:" .. ActionName)
end

function InputManager:HandleActionStarted(ActionName, Ctrl, A)
end

function InputManager:HandleActionOngoing(ActionName, Ctrl, A)
end

function InputManager:HandleActionCanceled(ActionName, Ctrl, A)
end

function InputManager:HandleActionCompleted(ActionName, Ctrl, A)
end


return InputManager