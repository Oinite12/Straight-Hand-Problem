require 'items.ranks'
require 'lib.dbug'

function extend_ranks()
    -- == Shortcut
    local function has_shortcut() return G.has_jokers.j_shortcut end
    local desc_2_list = {}

    for vrank_id, vrank in pairs(G.VirtualRanks) do
        local first_descendants = vrank.descendants
        for desc_id,__ in pairs(first_descendants) do
            local second_descendants = G.VirtualRanks[desc_id].descendants
            if not desc_2_list[vrank_id] then desc_2_list[vrank_id] = {} end
            for desc_2_id,__ in pairs(second_descendants) do
                table.insert(desc_2_list[vrank_id], desc_2_id)
            end
        end
    end

    for vrank_id, desc_2 in pairs(desc_2_list) do
        for __,desc_2_id in ipairs(desc_2) do
            G.VirtualRanks[vrank_id]:add_descendant(desc_2_id, has_shortcut)
        end
    end

    --[[ == Ortalab: Scenic Route 
    local function has_scenic_route() return G.has_jokers.j_ortalab_scenic_route end
    local initial_vrank_list = {}
    for vrank_id, __ in pairs(G.VirtualRanks) do table.insert(initial_vrank_list, vrank_id) end

    for __,vrank_id in ipairs(initial_vrank_list) do
        local vrank = G.VirtualRanks[vrank_id]
        local dupe_descendants = {}
        for desc_id, desc_condition in pairs(vrank.descendants) do
            dupe_descendants[desc_id] = desc_condition
        end

        local dupe_ascendants = {[vrank_id] = has_scenic_route}
        for asc_id, asc_condition in pairs(vrank.ascendants) do
            dupe_ascendants[asc_id] = function()
                return asc_condition() and has_scenic_route()
            end
        end

        VirtualRank{
            id = vrank.id .. "_scenic_dupe",
            descendants = dupe_descendants,
            ascendants = dupe_ascendants
        }
    end]]

    -- == Familiar - Smudged Joker
    local function has_fam_smudged_jester() return G.has_jokers.j_fam_smudged_jester end
    G.Ranks.card_3:add_vrank("8", has_fam_smudged_jester)
    G.Ranks.card_6:add_vrank("9", has_fam_smudged_jester)
    G.Ranks.card_K:add_vrank("A_low", has_fam_smudged_jester)
    G.Ranks.card_K:add_vrank("A_high", has_fam_smudged_jester)

    -- == Maximus - Perspective
    local function has_mxms_perspective() return G.has_jokers.j_mxms_perspective end
    G.Ranks.card_6:add_vrank("9", has_mxms_perspective)
    G.Ranks.card_9:add_vrank("6", has_mxms_perspective)
end