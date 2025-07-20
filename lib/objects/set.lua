-- Inspired by https://www.lua.org/pil/13.1.html
require 'lib.object_prim'
require 'lib.dbug'

---@class Set
Set = Object:extend()
function Set:init(seq)
    self = {}
    if not seq then return end
    -- Sequence items into hash keys
    for i,item in ipairs(seq) do
        self[item] = true
        seq[i] = nil
    end
    -- Non-object sets
    for k,v in pairs(seq) do
        if v == true then self[k] = true end
    end
end

-- Any table can be inputted to get number of defined keys
function Set:size()
    local size = 0
    for _ in pairs(self) do size = size + 1 end
    return size
end

function Set:insert(item)
    self[item] = true
end

function Set:union(othr)
    if getmetatable(othr) ~= Set then error("Set cannot union with non-set") end
    local new_set = Set()
    for k in pairs(self) do new_set:insert(k) end
    for k in pairs(othr) do new_set:insert(k) end
    return new_set
end

function Set:intersection(othr)
    if getmetatable(othr) ~= Set then error("Set cannot intersect with non-set") end
    local set_primitive_list = {}
    for k in pairs(self) do set_primitive_list[k] = othr[k] end
    return Set(set_primitive_list)
end

function Set:to_string(depth)
    depth = depth or 0
    local tab = DBUG.tab

    local set_contents = {}
    for k in pairs(self) do
        k = type(k) == "string" and ('"%s"'):format(k) or k
        table.insert(set_contents, tostring(k))
    end
    
    local set_contents_stringed = tab(depth) .. table.concat(set_contents, ",\n" .. tab(depth))
    return ("Set{\n%s\n%s}"):format(set_contents_stringed, tab(depth - 1))
end

-- == Typical metamethods
Set.__add = Set.union
Set.__mul = Set.intersection
Set.__len = Set.size
Set.__tostring = Set.to_string