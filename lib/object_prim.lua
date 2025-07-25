--||--
--This Object implementation was taken from SNKRX (MIT license). Slightly modified, this is a very simple OOP base

Object = {}
Object.__index = Object
function Object:init()
end

function Object:extend()
  local cls = {}
  for k, v in pairs(self) do
    if k:find("__") == 1 then
      cls[k] = v
    end
  end
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end

function Object:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end

function Object:__call(...)
  local obj = setmetatable({}, self)
---@diagnostic disable-next-line: redundant-parameter
  obj:init(...)
  return obj
end
