require 'items.ranks'
require 'lib.dbug'
require 'lib.global'
require 'lib.objects.set'
require 'lib.objects.card'

local function collect_ranks(played_cards)
    local active_ranks = Set()
    local active_vranks = {}

    for __,card in ipairs(played_cards) do
        local rank_id = card.rank
        active_ranks:insert(rank_id)
        
        local rank_info = G.Ranks[rank_id]
        local vranks_of_rank = rank_info.vranks
        for vrank_id, vrank_condition in pairs(vranks_of_rank) do
            if vrank_condition() then
                active_vranks[vrank_id] = active_vranks[vrank_id] or {
                    not_checked = true,
                    activating_cards = Set()
                }
                active_vranks[vrank_id].activating_cards:insert(card)
            end
        end
    end
    
    return active_ranks, active_vranks
end

-- "Spread out" from a vrank, search for other vranks to add to the current proto
local function crawl_vrank_prototypical(vrank_id, vrank_status, proto_container, vrank_status_list)
    local vrank_definition = G.VirtualRanks[vrank_id]
    proto_container[vrank_id] = vrank_status
    vrank_status.not_checked = nil -- RECURSIVE FUNCTION halts when a vrank's adjacents are all checked

    local vrank_adjacents = {} -- Adjacents are other vranks
    -- Collect adjacents
    for id, condition in pairs(vrank_definition.descendants) do vrank_adjacents[id] = condition end
    for id, condition in pairs(vrank_definition.ascendants)  do vrank_adjacents[id] = condition end

    for adj_id, adj_condition in pairs(vrank_adjacents) do
        local adj_status = vrank_status_list[adj_id]
        local adj_is_active = adj_condition()
        if adj_is_active and adj_status and adj_status.not_checked then
            crawl_vrank_prototypical(adj_id, adj_status, proto_container, vrank_status_list)
        end
    end
end

local function filter_protos(proto_straight_list)
    local remaining_protos = {}

    local function proto_is_sufficient(proto_straight)
        -- Insufficient vranks
        local proto_vrank_count = Set.size(proto_straight)
        if proto_vrank_count < G.config.straight_length() then return end

        -- Insufficient cards
        local proto_activating_cards = Set()
        for ___,vrank_status in pairs(proto_straight) do
            proto_activating_cards = proto_activating_cards + vrank_status.activating_cards
        end
        if #proto_activating_cards < G.config.straight_length() then return end

        return {
            contents = proto_straight,
            vrank_count = proto_vrank_count,
            activating_cards = proto_activating_cards
        }
    end

    for _,proto_straight in ipairs(proto_straight_list) do
        local proto_analysis = proto_is_sufficient(proto_straight)
        if proto_analysis then table.insert(remaining_protos, proto_analysis) end
    end

    return remaining_protos
end

local function proto_max_distance(proto_straight)
    local max = math.max
    local vrank_dag_topo_sort = G.kahn_sorted_vranks()
    local node_distances = {}
    local max_distance = 0

    local function update_distances(vrank_id, desc_id)
        node_distances[vrank_id] = max(
            node_distances[vrank_id],
            node_distances[desc_id] + 1
        )
        max_distance = max(
            max_distance,
            node_distances[vrank_id]
        )
    end

    local function check_vrank(vrank_id)
        node_distances[vrank_id] = 0
        local descendants = G.VirtualRanks[vrank_id].descendants
        for desc_id in pairs(descendants) do
            local descendant_is_tracked = node_distances[desc_id] ~= nil
            if descendant_is_tracked then update_distances(vrank_id, desc_id) end
        end
    end

    for _,vrank_id in ipairs(vrank_dag_topo_sort) do
        local proto_has_vrank = proto_straight.contents[vrank_id] ~= nil
        if proto_has_vrank then check_vrank(vrank_id) end
    end

    return max_distance + 1 -- +1 to count starting node
end

-- == THE function
local function calculate_straight(played_cards)
    if #played_cards < G.config.straight_length() then return end

    local active_ranks, active_vranks = collect_ranks(played_cards)

    local proto_straights = {}
    local function crawl_vrank(vrank_id, vrank_status)
        local current_proto_straight = proto_straights[#proto_straights]
        crawl_vrank_prototypical(vrank_id, vrank_status, current_proto_straight, active_vranks)
    end
    
    -- Generate "proto-proto-straights"
    for vrank_id,vrank_status in pairs(active_vranks) do
        if vrank_status.not_checked then
            table.insert(proto_straights, {})
            crawl_vrank(vrank_id, vrank_status)
        end
    end

    local analyzed_proto_straights = filter_protos(proto_straights)
    for __,proto_straight in ipairs(analyzed_proto_straights) do
        proto_straight.max_distance = proto_max_distance(proto_straight)
    end

    return analyzed_proto_straights
end

local played_cards = {
    Card("card_A"), Card("card_2"), Card("card_unstable_pi"), Card("card_5"), Card("card_7"),
    Card("card_K"), Card("card_Q"), Card("card_J"), Card("card_10"), Card("card_9")
}

printObj(calculate_straight(played_cards))