require 'items.ranks'
require 'lib.dbug'
require 'lib.set'

local function calculate_straight(played_cards)
    if #played_cards < G.config.straight_length() then return end

    local active_ranks = Set()
    local active_vranks = {}

    for __,card in ipairs(played_cards) do
        local rank_id = card.rank
        active_ranks:insert(rank_id)
        
        local card_rank_info = G.Ranks[rank_id]
        for vrank_id,vrank_condition in pairs(card_rank_info.vranks) do
            if vrank_condition() then
                active_vranks[vrank_id] = active_vranks[vrank_id] or {
                    checked = false,
                    activating_cards = Set()
                }
                active_vranks[vrank_id].activating_cards:insert(card)
            end
        end
    end

    local proto_straights = {}
    local function skim_vrank(vrank_id, vrank_status)
        local vrank_definition = G.VirtualRanks[vrank_id]
        proto_straights[#proto_straights][vrank_id] = vrank_status
        vrank_status.checked = true

        local vrank_descs = vrank_definition.descendants
        for desc_id, desc_condition in pairs(vrank_descs) do
            if desc_condition() and active_vranks[desc_id] and not active_vranks[desc_id].checked then
                local desc_status = active_vranks[desc_id]
                skim_vrank(desc_id, desc_status)
            end
        end

        local vrank_ascs = vrank_definition.ascendants
        for asc_id, asc_condition in pairs(vrank_ascs) do
            if asc_condition() and active_vranks[asc_id] and not active_vranks[asc_id].checked then
                local asc_status = active_vranks[asc_id]
                skim_vrank(asc_id, asc_status)
            end
        end
    end

    for vrank_id,vrank_status in pairs(active_vranks) do
        if not vrank_status.checked then
            table.insert(proto_straights, {})
            skim_vrank(vrank_id, vrank_status)
        end
    end

    local regarded_proto_straights = {}
    for __,proto_straight in ipairs(proto_straights) do
        local proto_vrank_count = 0
        for ___,___ in pairs(proto_straight) do
            proto_vrank_count = proto_vrank_count + 1
        end
        if proto_vrank_count < G.config.straight_length() then
            goto checkprotostraight_continue
        end

        local proto_activating_cards = Set()
        for ___,vrank_status in pairs(proto_straight) do
            proto_activating_cards = proto_activating_cards + vrank_status.activating_cards
        end
        if #proto_activating_cards < G.config.straight_length() then
            goto checkprotostraight_continue
        end

        table.insert(regarded_proto_straights, {
            contents = proto_straight,
            vrank_count = proto_vrank_count,
            activating_cards = proto_activating_cards
        })

        ::checkprotostraight_continue::
    end

    local vrank_dag_topo_sort = G.kahn_sorted_vranks()
    for __,regarded_proto in ipairs(regarded_proto_straights) do
        local node_distances = {}
        regarded_proto.max_distance = 0
        for ___,sorted_vrank_key in ipairs(vrank_dag_topo_sort) do
            if regarded_proto.contents[sorted_vrank_key] then
                node_distances[sorted_vrank_key] = 0
                local desc = G.VirtualRanks[sorted_vrank_key].descendants
                for desc_key in pairs(desc) do
                    if node_distances[desc_key] then
                        node_distances[sorted_vrank_key] = math.max(
                            node_distances[sorted_vrank_key],
                            node_distances[desc_key] + 1
                        )
                        regarded_proto.max_distance = math.max(
                            regarded_proto.max_distance,
                            node_distances[sorted_vrank_key]
                        )
                    end
                end
            end
        end
        regarded_proto.max_distance = regarded_proto.max_distance + 1
    end

    printObj(regarded_proto_straights)
end

local played_cards = {
    Card("card_A"), Card("card_2"), Card("card_unstable_pi"), Card("card_5"), Card("card_6"),
    Card("card_K"), Card("card_Q"), Card("card_J"), Card("card_10"), Card("card_9")
}

calculate_straight(played_cards)