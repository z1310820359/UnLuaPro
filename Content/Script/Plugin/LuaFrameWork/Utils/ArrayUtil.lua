------------------------------------------
--- ArrayUtil
------------------------------------------
---@class ArrayUtil
local ArrayUtil = {}


function ArrayUtil.IndexOf(Arr,Ele)
    for i=1,#Arr do
        if Arr[i]==Ele then
            return i
        end
    end
    return 0
end

function ArrayUtil.IndexOfGeneric(Arr,Ele,IsEqual)
    if Arr then
        for i=1,#Arr do
            if IsEqual(Arr[i],Ele) then
                return i
            end
        end
    end
    return 0
end

function ArrayUtil.InsertIfUnExist(Arr,Ele)
    local index = ArrayUtil.IndexOf(Arr,Ele);
    if index > 0 then
        return false
    end 
    Arr[#Arr+1] = Ele
    return true
end

function ArrayUtil.InsertIfUnExistGeneric(Arr,Ele,IsEqual)
    local index = ArrayUtil.IndexOfGeneric(Arr,Ele,IsEqual)
    if index > 0 then
        return false
    end 
    Arr[#Arr+1] = Ele
    return true
end

function ArrayUtil.ClearAllZeroElement(Arr)
    local newLen = 1
    local len = #Arr
    local handler
    for j= 1 , len do
        handler = Arr[j]
        if(handler ~= 0) then
            if(newLen ~= j) then
                Arr[newLen] = handler
            end
            newLen=newLen+1
        end
    end
    for j=newLen,len do
        Arr[j] = nil
    end
end

function ArrayUtil.ConcatArray(a1,a2)
    local a1l = #a1
    for i=1,#a2 do
        a1[a1l+i]=a2[i]
    end
    return a1
end

function ArrayUtil.InverseOf(a)
    local Index = {}
    for k, v in pairs(a) do
        Index[v] = k
    end
    return Index
end

function ArrayUtil.MoveElements(Src,Dest,ConditionFunc)
	local i = 1
    while i <= #Src do
        if ConditionFunc(Src[i]) then
            local element = table.remove(Src, i)
            table.insert(Dest, element)
        else
            i = i + 1
        end
    end
end

-- 会自动跳过nil元素，不会算去其中
function ArrayUtil.CountOfCondition(Array,Condition)
	local Count = 0
	if not Array or  type(Array) ~= "table" or next(Array) == nil then
		return 0
	end
    if not Condition or  type(Condition) ~= "function" then
        return 0
    end
	for _, Value in pairs(Array) do
		if Value and Condition(Value) then
			Count = Count + 1
		end
	end
	return Count
end

-- 会自动跳过nil，去重后nil值也会不存在
function ArrayUtil.Unique(Array)
	if not Array or type(Array) ~= "table" or next(Array) == nil then
		return {}
	end
    local UniqueElements = {}
    local NewArray = {}
    for _, Value in pairs(Array) do
        if not UniqueElements[Value] then
            table.insert(NewArray, Value)
            UniqueElements[Value] = true
        end
    end
    return NewArray
end

function ArrayUtil.SplitArray(Array,Index)
	if type(Array) ~= "table" or type(Index) ~= "number" then
        return nil, nil
    end

    local ArrayLength = #Array
    if Index < 1 or Index > ArrayLength then
        return nil, nil
    end

    local Array1 = {}
    local Array2 = {}

    for i, value in ipairs(Array) do
        if i <= Index then
            table.insert(Array1, value)
        else
            table.insert(Array2, value)
        end
    end

    return Array1, Array2
end


return ArrayUtil;