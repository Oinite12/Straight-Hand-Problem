require 'lib.objects.rank'
require 'items.vranks'

function register_ranks()
    Rank{
        id = "card_A",
        name = "Ace",
        vranks = {"A_low", "A_high"}
    }

    local vanilla_ranks = {
        "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"
    }
    for __,rank in ipairs(vanilla_ranks) do Rank{
        id = "card_" .. rank,
        name = rank,
        vranks = {rank}
    } end

    -- == UnStable Ranks
    if G.has_mods.unstable then
        Rank{
            id = "card_unstable_0",
            name = "0",
            vranks = {"unstable_0"}
        }

        Rank{
            id = "card_unstable_0_5",
            name = "Half",
            vranks = {"unstable_0", "unstable_0_5", "unstable_1"}
        }

        Rank{
            id = "card_unstable_1",
            name = "1",
            vranks = {"unstable_1"}
        }

        Rank{
            id = "card_unstable_sqrt2",
            name = "Root 2",
            vranks = {"unstable_1", "unstable_sqrt2", "2"}
        }

        Rank{
            id = "card_unstable_e",
            name = "e",
            vranks = {"2", "unstable_e", "3"}
        }

        Rank{
            id = "card_unstable_pi",
            name = "Pi",
            vranks = {"3", "unstable_pi", "4"}
        }

        Rank{
            id = "card_unstable_11",
            name = "11",
            vranks = {"unstable_11"}
        }

        Rank{
            id = "card_unstable_12",
            name = "12",
            vranks = {"unstable_12"}
        }

        Rank{
            id = "card_unstable_13",
            name = "13",
            vranks = {"unstable_13"}
        }

        Rank{
            id = "card_unstable_21",
            name = "21",
            vranks = {"unstable_21"}
        }

        Rank{
            id = "card_unstable_25",
            name = "25",
            vranks = {"unstable_25"}
        }

        Rank{
            id = "card_unstable_161",
            name = "161",
            vranks = {"unstable_161"}
        }

        Rank{
            id = "card_unstable_qm",
            name = "???",
            vranks = {"unstable_qm"}
        }
    end

    -- == Showdown Ranks
    if G.has_mods.showdown then
        Rank{
            id = "card_showdown_2_5",
            name = "2.5",
            vranks = {"showdown_2_5", "2"}
        }

        Rank{
            id = "card_showdown_5_5",
            name = "5.5",
            vranks = {"showdown_5_5", "5"}
        }

        Rank{
            id = "card_showdown_8_5",
            name = "8.5",
            vranks = {"showdown_8_5", "8"}
        }

        Rank{
            id = "card_showdown_butler",
            name = "Butler",
            vranks = {"showdown_butler", "J"}
        }

        Rank{
            id = "card_showdown_princess",
            name = "Princess",
            vranks = {"showdown_princess", "Q"}
        }

        Rank{
            id = "card_showdown_lord",
            name = "Lord",
            vranks = {"showdown_lord", "K"}
        }
    end

    -- == Strange Pencil Ranks
    if G.has_mods.strangePencil then
        Rank{
            id = "card_strangePencil_sneven",
            name = "Sñeven",
            vranks = {"strangePencil_sneven", "7", "8"}
        }
    end

    -- == Wild rank
    if G.config.wild_rank then
        local vrank_table = {}
        for vrank_id in pairs(G.VirtualRanks) do table.insert(vrank_table, vrank_id) end
        Rank{
            id = "card_wild_rank",
            name = "Wild Rank",
            vranks = vrank_table
        }
    end
end