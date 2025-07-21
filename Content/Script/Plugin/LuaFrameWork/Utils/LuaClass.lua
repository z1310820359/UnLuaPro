
function _G.clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function _G.LuaClass(classname, super)
    --print("shawnxhu G6Helper begin Class() classname:"..tostring(classname))
    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end

        cls.ctor    = function() end
        cls.__cname = classname
        cls.__ctype = 1

        function cls.New(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end

    else
        -- inherited from Lua Object
        if super then
            cls = clone(super)
            cls.super = super
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls
        cls.__close = function(...)
            if type(cls.onclose) == "function" then
                cls.onclose(...)
            end
        end

        function cls.New(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    end

    return cls
end


local List = {}
List.__index = List

function List:New()
    local o = {}
    setmetatable(o, self)
    return o
end

function List:Add(item)
    table.insert(self, item)
end

function List:Clear()
    local count = self:Count()
    for i=count,1,-1 do
        table.remove(self)
    end
end

function List:Contains(item)
    local count = self:Count()
    for i=1,count do
        if self[i] == item then
            return true
        end
    end
    return false
end

function List:Count()
    return #self
end

function List:Find(predicate)
    if (predicate == nil or type(predicate) ~= 'function') then
        print('predicate is invalid!')
        return
    end
    local count = self:Count()
    for i=1,count do
        if predicate(self[i]) then 
            return self[i] 
        end
    end
    return nil
end

function List:ForEach(action)
    if (action == nil or type(action) ~= 'function') then
        print('action is invalid!')
        return
    end
    local count = self:Count()
    for i=1,count do
        action(self[i])
    end
end

function List:IndexOf(item)
    local count = self:Count()
    for i=1,count do
        if self[i] == item then
            return i
        end
    end
    return 0
end

function List:LastIndexOf(item)
    local count = self:Count()
    for i=count,1,-1 do
        if self[i] == item then
            return i
        end
    end
    return 0
end

function List:Insert(index, item)
    table.insert(self, index, item)
end

-- function List:ItemType()
--     return self.itemType
-- end

function List:Remove(item)
    local idx = self:LastIndexOf(item)
    if (idx > 0) then
        table.remove(self, idx)
        self:Remove(item)
    end
end

function List:RemoveAt(index)
    table.remove(self, index)
end

function List:Sort(comparison, func)
    if (comparison ~= nil and type(comparison) ~= 'function') then
        print('comparison is invalid')
        return
    end
    if func == nil then
        table.sort(self)
    else
        table.sort(self, func)
    end
end

_G.List = List

local Stack = {}
local tinsert = table.insert

function Stack:New()
    local t = {}
    setmetatable(t, {__index = self})
    return t
end

function Stack:Push(...)
    local arg = {...}
    self.dataTb = self.dataTb or {}
    if next(arg) then
        for i = 1, #arg do
            tinsert(self.dataTb, arg[i])
        end
    end
end

function Stack:Pop(num)
    num = num or 1
    assert(num > 0, "num必须为正整数")
    local popTb = {}
    for i = 1, num do
        tinsert(popTb, self.dataTb[#self.dataTb])
        table.remove(self.dataTb)
    end
    return table.unpack(popTb)
end

function Stack:List()
    for i = 1, #self.dataTb do
        print(i, self.dataTb[i])
    end
end

function Stack:Count()
    return #self.dataTb
end

function Stack:Contains(item)
    if not item then return -1 end
    for k, v in pairs(self.dataTb) do
        if v == item then
            return k
        end
    end
    return -1
end

function Stack:Remove(item)
    if not item then return end
    local newTb = {}
    local count = 1
    for i = 1, #self.dataTb do
        if item ~= self.dataTb[i] then
            tinsert(newTb, self.dataTb[i])
        end
    end
    self.dataTb = newTb
end

function Stack:GetIdx(num)
    assert(num > 0, "num必须为正整数")
    return self.dataTb[num]
end

_G.Stack = Stack

return {}