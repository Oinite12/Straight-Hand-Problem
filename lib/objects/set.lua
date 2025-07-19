-- Inspired by https://www.lua.org/pil/13.1.html
require 'lib.object_prim'
require 'lib.dbug'

---@class Set
Set = Object:extend()
function Set:init(seq)
    self.contents = {}
    if not seq then return end
    for i,item in ipairs(seq) do
        self.contents[item] = true
        seq[i] = nil
    end
    for k,v in pairs(seq) do
        if v == true then self.contents[k] = true end
    end
end

function Set:size()
    -- Permit input of any table, to quickly get size of any table
    if getmetatable(self) ~= Set then self = {contents=self} end
    local size = 0
    for _ in pairs(self.contents) do size = size + 1 end
    return size
end

function Set:insert(item)
    self.contents[item] = true
end

function Set:union(othr)
    if getmetatable(othr) ~= Set then error("Set cannot union with non-set") end
    local set_primitive_list = {}
    for k in pairs(self.contents) do set_primitive_list[k] = true end
    for k in pairs(othr.contents) do set_primitive_list[k] = true end
    return Set(set_primitive_list)
end

function Set:intersection(othr)
    if getmetatable(othr) ~= Set then error("Set cannot union with non-set") end
    local set_primitive_list = {}
    for k in pairs(self.contents) do set_primitive_list[k] = othr.contents[k] end
    return Set(set_primitive_list)
end

function Set:to_string(depth)
    depth = depth or 0
    local tab = DBUG.tab

    local set_contents = {}
    for k in pairs(self.contents) do
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