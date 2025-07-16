
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
    -- 检查是否被UI界面所屏蔽

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

function InputManager:SetupKeyBindings(Obj, Func)
    local key_names = {
        -- 字母
        "A", "B", --[["C",]] "D", "E","F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", --[["V", ]] "W", "X", "Y", "Z",
        -- 数字
        "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine",
        -- 小键盘
        "NumPadOne", "NumPadTwo", "NumPadThree", "NumPadFour", "NumPadFive", "NumPadSix", "NumPadSeven", "NumPadEight", "NumPadNine",
        -- 方向键
        "Up", "Down", "Left", "Right",
        -- ProjectSettings -> Engine - Input -> Action Mappings
        "Fire", "Aim",
    }
    
    for _, key_name in ipairs(key_names) do
        Obj[key_name .. "_Pressed"] = function(Obj, key)
            Func(Obj, key)
            self:HandleCick(key)
        end
    end
end

function InputManager:HandleCick(key)
    print("InputManager")
end

return InputManager