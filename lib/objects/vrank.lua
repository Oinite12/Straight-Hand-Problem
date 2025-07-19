require 'lib.object_prim'
require 'lib.global'

G.VirtualRanks = {} -- This is a DAG - directed acyclic graph

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
        self.descendants[desc_id] = G.alwaysTrue
        self.descendants[i] = nil
    end
    for desc_id, desc_condition in pairs(self.descendants) do
        self:update_other_vrank(desc_id, "ascendants", desc_condition)
    end

    for i,asc_id in ipairs(self.ascendants) do
        self.ascendants[asc_id] = G.alwaysTrue
        self.ascendants[i] = nil
        self:update_other_vrank(asc_id, "descendants", G.alwaysTrue)
    end
    for asc_id, asc_condition in pairs(self.ascendants) do
        self:update_other_vrank(asc_id, "descendants", asc_condition)
    end

    if getmetatable(self) == VirtualRank then
        G.VirtualRanks[self.id] = self
    end
end

function VirtualRank:add_descendant(desc_id, conditional_func)
    conditional_func = conditional_func or G.alwaysTrue
    if type(conditional_func) ~= "function" then
        error("Conditional function not function")
    end
    if not self.descendants[desc_id] then
        self.descendants[desc_id] = conditional_func
        self:update_other_vrank(desc_id, "ascendants", conditional_func)
    end
end

function VirtualRank:add_ascendant(asc_id, conditional_func)
    conditional_func = conditional_func or G.alwaysTrue
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

-- Required to find straight length
-- https://en.wikipedia.org/wiki/Longest_path_problem#Acyclic_graphs
-- Algorithm used: https://en.wikipedia.org/wiki/Topological_sorting#Kahn's_algorithm
G.kahn_sorted_vranks = function()
    local sorted_seq = {}
    local start_nodes = {}

    local temp_vranks_list = {}
    for vrank_key, vrank_details in pairs(G.VirtualRanks) do
        temp_vranks_list[vrank_key] = {
            descendants = {},
            ascendants = {}
        }
        local v = temp_vranks_list[vrank_key]
        
        local has_desc = false
        for desc_vrank_key, conditional in pairs(vrank_details.descendants) do
            if conditional() then
                v.descendants[desc_vrank_key] = true
                has_desc = true
            end
        end
        local has_asc = false
        for asc_vrank_key, conditional in pairs(vrank_details.ascendants) do
            if conditional() then
                v.ascendants[asc_vrank_key] = true
                has_asc = true
            end
        end

        if not has_desc then
            if has_asc then
                start_nodes[vrank_key] = temp_vranks_list[vrank_key]
            end
            -- eliminates isolated nodes
            temp_vranks_list[vrank_key] = nil
        end
    end

    while true do
        if Set.size(start_nodes) == 0 then break end
        for start_node_key in pairs(start_nodes) do
            table.insert(sorted_seq, start_node_key)

            local start_vrank = start_nodes[start_node_key]
            local asc_vranks = start_vrank.ascendants
            for asc_vrank_key in pairs(asc_vranks) do
                local asc_vrank = temp_vranks_list[asc_vrank_key]
                asc_vrank.descendants[start_node_key] = nil
                if Set.size(asc_vrank.descendants) == 0 then
                    start_nodes[asc_vrank_key] = temp_vranks_list[asc_vrank_key]
                end
            end
            start_nodes[start_node_key] = nil
        end
    end

    return sorted_seq
end