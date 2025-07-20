require 'straight_calculation'
require 'lib.objects.set'

function unit_test(id, card_list, expected_list)
    for i,rank_key in ipairs(card_list) do
        card_list[i] = Card(rank_key)
    end
    local calculated_straight = calculate_straight(card_list)
    local activating_cards = calculated_straight.activating_cards

    local count_cards = {}
    for card in activating_cards:iter() do
        local card_rank = card.rank
        if not count_cards[card_rank] then count_cards[card_rank] = 0 end
        count_cards[card_rank] = count_cards[card_rank] + 1
    end

    for _,card_rank in ipairs(expected_list) do
        if not count_cards[card_rank] then
            count_cards[card_rank] = -1
        else
            count_cards[card_rank] = (count_cards[card_rank] - 1 ~= 0) and (count_cards[card_rank] - 1) or nil
        end
    end

    local test_status = Set.is_empty(count_cards)
    if type(id) == "number" then id = tostring(id)
    else id = ('"%s"'):format(id) end
    print(("%s Test %s"):format(test_status and "SUCCESS" or "FAIL   ", id))
end