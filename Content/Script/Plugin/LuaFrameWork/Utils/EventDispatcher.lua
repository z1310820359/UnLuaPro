------------------------------------------
--- EventDispatcher
------------------------------------------
---@type ArrayUtil
local ArrayUtil = require "Plugin.LuaFrameWork.Utils.ArrayUtil"

require "Plugin.LuaFrameWork.Utils.LuaClass"

---@class EventDispatcher

---@type EventDispatcher
local EventDispatcher = _G.LuaClass("EventDispatcher");


function EventDispatcher:ctor()
    self.eventHandlerDic = {}
    self.tempHandlerList = {}
end


function EventDispatcher:RemoveAllEventListener(EventName)
    local EventHandlers = self:GetEventHandlers(EventName,false)
    if(EventHandlers == nil) then 
        return
    end

    for k,v in ipairs(EventHandlers) do
        EventHandlers[k] = 0
    end
    local suc = ArrayUtil.InsertIfUnExistGeneric(self.tempHandlerList,EventHandlers,self.HandlerEqual)
    self:ClearNullEventHandler()
end

function EventDispatcher:RemoveEventListener(EventName,EventHandler,HandlerSelf)
    local EventHandlers = self:GetEventHandlers(EventName,false);
    if(EventHandlers == nil) then 
        return
    end
    local dlg = {inst = HandlerSelf, func = EventHandler}
    local index = ArrayUtil.IndexOfGeneric(EventHandlers,dlg,self.HandlerEqual)
    if(index > 0) then 
        EventHandlers[index] = 0;
        local suc = ArrayUtil.InsertIfUnExistGeneric(self.tempHandlerList,EventHandlers,self.HandlerEqual)
    end
end

function EventDispatcher:Dispatch(EventName,...)
    local EventHandlers = self:GetEventHandlers(EventName,false);
    if(EventHandlers == nil) then 
        return
    end

    for k,v in ipairs(EventHandlers) do
        local dlg = v
        if(dlg ~= 0) then
            if dlg == nil then
                -- SGPrint(LogType.Services, Info, "[EventDispatcher] dlg is nil PleaceCheck Event:",EventName)
            else
                dlg.func(dlg.inst,EventName,...)
            end
        end
    end
    self:ClearNullEventHandler()
end

function EventDispatcher:AddEventListener(EventName,EventHandler,HandlerSelf)
    assert(type(EventName) == "string","EventName must be string")
    assert(type(EventHandler) == "function","EventHandler must be function")
    assert(type(HandlerSelf) == "table","HandlerSelf must be table")

    local EventHandlers = self:GetEventHandlers(EventName,true)
    local dlg = {inst = HandlerSelf, func = EventHandler}
    local suc = ArrayUtil.InsertIfUnExistGeneric(EventHandlers, dlg, self.HandlerEqual);
    --SGPrint(LogType.Services, Info, "AddEventListener", EventName, EventHandler, HandlerSelf.__cname, suc)
end

function EventDispatcher.HandlerEqual(a,b)
    if a == nil or b == nil or a == 0 then
        return false
    end

    local ret = true;
    for k,v in pairs(a) do
        if a[k] ~= b[k] then
            ret = false
        end
    end
    return ret
end

function  EventDispatcher:GetEventHandlers(EventName,autoCreate)
    -- body
    local EventHandlers= self.eventHandlerDic[EventName]
    if(EventHandlers == nil and autoCreate) then
        EventHandlers = {}
        self.eventHandlerDic[EventName] = EventHandlers
    end

    return EventHandlers
end

function EventDispatcher:ClearNullEventHandler()
    local Arr = self.tempHandlerList

    local handlers;
    local size = #Arr
    for i=1,size do
        handlers = Arr[i];
        ArrayUtil.ClearAllZeroElement(handlers)
        Arr[i] = nil
    end
end

_G.EventSys = EventDispatcher:New()

return EventDispatcher