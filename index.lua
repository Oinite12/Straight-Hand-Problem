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
        expect = "ditto"
    },
    {
        name = "Slightly larger straight",
        input = {"card_A", "card_2", "card_3", "card_4", "card_5", "card_6"},
        expect = "ditto"
    },
    {
        name = "Gap",
        input = {"card_A", "card_2", "card_4", "card_5"},
        expect = {}
    },
    {
        name = "Stray card",
        input = {"card_A", "card_2", "card_3", "card_4", "card_5", "card_7"},
        expect = {"card_A", "card_2", "card_3", "card_4", "card_5"}
    },
    {
        name = "Pairs in straight",
        input = {"card_A", "card_A", "card_2", "card_3", "card_3", "card_4", "card_5"},
        expect = "ditto"
    },
    {
        name = "Two sets of straights",
        input = {"card_A", "card_2", "card_3", "card_4", "card_5", "card_K", "card_Q", "card_J", "card_10", "card_9"},
        expect = "ditto"
    },
    {
        name = "Non-looping Ace",
        input = {"card_3", "card_2", "card_A", "card_K", "card_Q",},
        expect = {},
    },
    {
        name = "Four Fingers",
        input = {"card_A", "card_2", "card_3", "card_4"},
        expect = "ditto",
        environment = function() G.has_jokers.j_four_fingers = true end
    },
    {
        name = "Shortcut, one skip",
        input = {"card_A", "card_2", "card_4", "card_5", "card_6"},
        expect = "ditto",
        environment = function() G.has_jokers.j_shortcut = true end
    },
    {
        name = "Shortcut, a few skips",
        input = {"card_A", "card_3", "card_4", "card_5", "card_6", "card_9", "card_10"},
        expect = {"card_A", "card_3", "card_4", "card_5", "card_6"},
        environment = function() G.has_jokers.j_shortcut = true end
    },
    {
        name = "Shortcut, all skips",
        input = {"card_A", "card_3", "card_5", "card_7", "card_9"},
        expect = "ditto",
        environment = function() G.has_jokers.j_shortcut = true end
    },
    {
        name = "Shortcut, non-looping Ace",
        input = {"card_10", "card_Q", "card_A", "card_3", "card_5"},
        expect = {},
        environment = function() G.has_jokers.j_shortcut = true end
    },
    {
        name = "Shortcut + Four Fingers",
        input = {"card_A", "card_3", "card_4", "card_6", "card_9"},
        expect = {"card_A", "card_3", "card_4", "card_6"},
        environment = function()
            G.has_jokers.j_shortcut = true
            G.has_jokers.j_four_fingers = true
        end
    },
    {
        name = "Unstable - A decimal with its adjacents",
        input = {"card_2", "card_unstable_e", "card_3", "card_4", "card_5"},
        expect = "ditto",
        environment = function() G.has_mods.unstable = true end
    },
    {
        name = "Unstable - A decimal with only one adjacents",
        input = {"card_2", "card_unstable_e", "card_4", "card_5", "card_6"},
        expect = "ditto",
        environment = function() G.has_mods.unstable = true end
    },
    {
        name = "Unstable - A decimal with no adjacents",
        input = {"card_A", "card_unstable_e", "card_4", "card_5", "card_6"},
        expect = "ditto",
        environment = function() G.has_mods.unstable = true end
    },
    {
        name = "Unstable - Overextending a decimal",
        input = {"card_A", "card_unstable_e", "card_5", "card_6", "card_7"},
        expect = {},
        environment = function() G.has_mods.unstable = true end
    },
    {
        name = "Unstable - Multiple decimals with their adjacents",
        input = {"card_unstable_0", "card_unstable_0_5", "card_unstable_1", "card_unstable_sqrt2", "card_2"},
        expect = "ditto",
        environment = function() G.has_mods.unstable = true end
    },
    {
        name = "Unstable - Multiple decimals with only one adjacent",
        input = {"card_unstable_0_5", "card_unstable_1", "card_unstable_sqrt2", "card_unstable_e", "card_3"},
        expect = "ditto",
        environment = function() G.has_mods.unstable = true end
    },
    {
        name = "Unstable - Multiple decimals with no adjacents",
        input = {"card_unstable_0_5", "card_unstable_sqrt2", "card_unstable_e", "card_unstable_pi", "card_5"},
        expect = "ditto",
        environment = function() G.has_mods.unstable = true end
    },
    {
        name = "Excluding stubby branches",
        input = {"card_unstable_0", "card_unstable_0_5", "card_unstable_1", "card_unstable_sqrt2", "card_2", "card_A"},
        expect = {"card_unstable_0", "card_unstable_0_5", "card_unstable_1", "card_unstable_sqrt2", "card_2"},
        environment = function() G.has_mods.unstable = true end
    },
    {
        name = "Unstable - Exclude decimal full houses",
        input = {"card_unstable_0_5", "card_unstable_0_5", "card_unstable_0_5", "card_unstable_sqrt2", "card_unstable_sqrt2"},
        expect = {},
        environment = function() G.has_mods.unstable = true end,
    },
    {
        name = "Familiar - Smudged Jester - 3 is 8, 6 is 9",
        input = {"card_3", "card_6", "card_10", "card_J", "card_Q"},
        expect = "ditto",
        environment = function() G.has_jokers.j_fam_smudged_jester = true end,
    },
    {
        name = "Familiar - Smudged Jester - K is high A",
        input = {"card_9", "card_10", "card_J", "card_Q", "card_K"},
        expect = "ditto",
        environment = function() G.has_jokers.j_fam_smudged_jester = true end,
    },
    {
        name = "Familiar - Smudged Jester - K is low A",
        input = {"card_5", "card_4", "card_3", "card_2", "card_K"},
        expect = "ditto",
        environment = function() G.has_jokers.j_fam_smudged_jester = true end,
    },
    {
        name = "Familiar - Smudged Jester - K is non-looping A",
        input = {"card_3", "card_2", "card_K", "card_Q", "card_J"},
        expect = {},
        environment = function() G.has_jokers.j_fam_smudged_jester = true end,
    }
}

------------------------
require 'lib.global'
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

    G.Ranks = {}
    G.VirtualRanks = {}
    G.ID = 0
end

local function dupe_table(tab)
    local new_table = {}
    for k,v in pairs(tab) do new_table[k] = v end
    return new_table
end

require 'unit_test'
for name,values in pairs(unit_tests) do
    reset_global_bools()
    if values.environment then values.environment() end
    register_vranks()
    register_ranks()
    extend_ranks()

    local test_name = values.name or name
    local test_input = values.input
    local test_expect = values.expect
    local test_dbug = values.dolog
    if test_expect == "ditto" then test_expect = dupe_table(test_input) end
    unit_test(test_name, test_input, test_expect, test_dbug)
end