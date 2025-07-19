require 'lib.object_prim'
require 'lib.global'

G.VirtualRanks = {} -- This is a DAG - directed acyclic graph
G.Ranks = {}

local function alwaysTrue() return true end

---@class Card
Card = Object:extend()
function Card:init(rank, suit)
    self.id = G.get_id()
    self.rank = rank
    self.suit = suit or "suit N/A"
end

function Card:to_string()
    return ("Card[%s of %s]"):format(self.rank, self.suit)
end
Card.__tostring = Card.to_string

---@class Rank
Rank = Object:extend()
function Rank:init(args)
    self.id     = args.id
    self.name   = args.name or ""
    self.vranks = args.vranks or {}

    if not args.id then error("Rank not given ID") end

    -- args.vranks also takes SEQ of VirtualRank ids
    -- Default value is function that always returns true
    for i,vrank_id in ipairs(self.vranks) do
        self.vranks[vrank_id] = alwaysTrue
        self.vranks[i] = nil
    end

    if getmetatable(self) == Rank then
        G.Ranks[self.id] = self
    end
end

function Rank:is_vrank(vrank_id)
    return self.vranks[vrank_id] and self.vranks[vrank_id]() or false
end

function Rank:add_vrank(vrank_id, conditional_func)
    conditional_func = conditional_func or alwaysTrue
    if type(conditional_func) ~= "function" then
        error("Conditional function not function")
    end
    self.vranks[vrank_id] = conditional_func
end

---@class VirtualRank
VirtualRank = Object:extend()
function VirtualRank:update_other_vrank(id, mode, conditional_func)
    if mode ~= "ascendants" and mode ~= "descendants" then return end
    local other_vrank = G.VirtualRanks[id]
    if other_vrank and not other_vrank[mode][self.id] then
        other_vrank[mode][self.id] = conditional_func
    end
end

function VirtualRank:init(args)
    self.id          = args.id
    self.descendants = args.descendants or {}
    self.ascendants  = args.ascendants or {}

    if not self.id then error("VirtualRank not given ID") end

    -- args.descendants also takes SEQ of VirtualRank ids
    -- Default value is function that always returns true
    for i,desc_id in ipairs(self.descendants) do
        self.descendants[desc_id] = alwaysTrue
        self.descendants[i] = nil
    end
    for desc_id, desc_condition in pairs(self.descendants) do
        self:update_other_vrank(desc_id, "ascendants", desc_condition)
    end

    for i,asc_id in ipairs(self.ascendants) do
        self.ascendants[asc_id] = alwaysTrue
        self.ascendants[i] = nil
        self:update_other_vrank(asc_id, "descendants", alwaysTrue)
    end
    for asc_id, asc_condition in pairs(self.ascendants) do
        self:update_other_vrank(asc_id, "descendants", asc_condition)
    end

    if getmetatable(self) == VirtualRank then
        G.VirtualRanks[self.id] = self
    end
end

function VirtualRank:add_descendant(desc_id, conditional_func)
    conditional_func = conditional_func or alwaysTrue
    if type(conditional_func) ~= "function" then
        error("Conditional function not function")
    end
    if not self.descendants[desc_id] then
        self.descendants[desc_id] = conditional_func
        self:update_other_vrank(desc_id, "ascendants", conditional_func)
    end
end

function VirtualRank:add_ascendant(asc_id, conditional_func)
    conditional_func = conditional_func or alwaysTrue
    if type(conditional_func) ~= "function" then
        error("Conditional function not function")
    end
    if not self.ascendants[asc_id] then
        self.ascendants[asc_id] = conditional_func
        self:update_other_vrank(asc_id, "descendants", conditional_func)
    end
end

function VirtualRank:update_descendant_condition(desc_id, conditional_func)
    if self.descendants[desc_id] then
        self.descendants[desc_id] = conditional_func
        self:update_other_vrank(desc_id, "ascendants", conditional_func)
    end
end

function VirtualRank:update_ascendant_condition(asc_id, conditional_func)
    if self.ascendants[asc_id] then
        self.ascendants[asc_id] = conditional_func
        self:update_other_vrank(asc_id, "descendants", conditional_func)
    end
end

function VirtualRank:descendant_check(desc_id)
    return self.descendants[desc_id] and self.descendants[desc_id]() or false
end

function VirtualRank:ascendant_check(asc_id)
    return self.ascendants[asc_id] and self.ascendants[asc_id]() or false
end