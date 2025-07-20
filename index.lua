require 'unit_test'
require 'lib.global'

local unit_tests = {
    {
        input = {"card_A"},
        expect = {}
    },
    {
        input = {"card_A", "card_2"},
        expect = {}
    },
    {
        input = {"card_A", "card_2", "card_3"},
        expect = {}
    },
    {
        input = {"card_A", "card_2", "card_3", "card_4"},
        expect = {}
    },
    {
        input = {"card_A", "card_2", "card_3", "card_4", "card_5"},
        expect = {"card_A", "card_2", "card_3", "card_4", "card_5"}
    },
    {
        name = "Two sets of straights",
        input = {"card_A", "card_2", "card_3", "card_4", "card_5", "card_K", "card_Q", "card_J", "card_10", "card_9"},
        expect = {"card_A", "card_2", "card_3", "card_4", "card_5", "card_K", "card_Q", "card_J", "card_10", "card_9"},
    },
    {
        name = "Four Fingers",
        input = {"card_A", "card_2", "card_3", "card_4"},
        expect = {"card_A", "card_2", "card_3", "card_4"},
        environment = function() G.has_jokers.j_four_fingers = true end
    },
}

------------------------

local function reset_global_bools()
    G.has_mods = {
        unstable = false,
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
end

for name,values in pairs(unit_tests) do
    reset_global_bools()
    if values.environment then values.environment() end
    unit_test(values.name or name, values.input, values.expect)
end