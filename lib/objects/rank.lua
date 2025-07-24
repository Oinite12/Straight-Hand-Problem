require 'lib.object_prim'
require 'lib.global'

G.Ranks = {}

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
        self.vranks[vrank_id] = G.alwaysTrue
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
    conditional_func = conditional_func or G.alwaysTrue
    if type(conditional_func) ~= "function" then
        error("Conditional function not function")
    end
    if self.vranks[vrank_id] and self.vranks[vrank_id] ~= G.alwaysTrue then
        self.vranks[vrank_id] = function()
            return self.vranks[vrank_id] and conditional_func
        end
    else
        self.vranks[vrank_id] = conditional_func
    end
end