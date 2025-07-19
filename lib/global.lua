require 'lib.dbug'

G = {}

G.ID = 0
function G.get_id()
    G.ID = G.ID + 1
    return G.ID
end

G.has_mods = {
    unstable = true,
    showdown = false,
    strangePencil = false
}

G.has_jokers = {
    j_shortcut = false,
    j_four_fingers = false,
    j_ortalab_scenic_route = false,

    j_fam_smudged_jester = false,
    j_mxms_perspective = false,
    j_twmg_large_small_boulder = false,
    j_cry_maximized = false,
}

G.config = {
    wild_rank = false,
    straight_length = function() return (G.has_jokers.j_four_fingers and 4 or 5) end
}

local function empty_table(t)
    local no_items = true
    for _ in pairs(t) do
        no_items = false
        break
    end
    return no_items
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
        if empty_table(start_nodes) then break end
        for start_node_key in pairs(start_nodes) do
            table.insert(sorted_seq, start_node_key)

            local start_vrank = start_nodes[start_node_key]
            local asc_vranks = start_vrank.ascendants
            for asc_vrank_key in pairs(asc_vranks) do
                local asc_vrank = temp_vranks_list[asc_vrank_key]
                asc_vrank.descendants[start_node_key] = nil
                if empty_table(asc_vrank.descendants) then
                    start_nodes[asc_vrank_key] = temp_vranks_list[asc_vrank_key]
                end
            end
            start_nodes[start_node_key] = nil
        end
    end

    return sorted_seq
end