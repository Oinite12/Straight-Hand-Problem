require 'lib.objects'

local vanilla_vranks = {
    "A_low", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A_high"
}
for i = 1, #vanilla_vranks do VirtualRank{
        id = vanilla_vranks[i],
        ascendants = i ~= #vanilla_vranks and {vanilla_vranks[i+1]} or nil,
        descendants = i ~= 1 and {vanilla_vranks[i-1]} or nil,
} end

-- == UnStable ranks
if G.has_mods.unstable then
    local isolated_unstable_vranks = {
        "unstable_qm", "unstable_161", "unstable_25", "unstable_21"
    }

    for i = 1, #isolated_unstable_vranks do VirtualRank{id = isolated_unstable_vranks[i]} end

    VirtualRank{
        id = "unstable_0",
        ascendants = {"unstable_0_5", "unstable_1"}
    }

    VirtualRank{
        id = "unstable_0_5",
        ascendants = {"unstable_1"},
        descendants = {"unstable_0"}
    }

    VirtualRank{
        id = "unstable_1",
        ascendants = {"unstable_sqrt2", "2"},
        descendants = {"unstable_0", "unstable_0_5"}
    }

    VirtualRank{
        id = "unstable_sqrt2",
        ascendants = {"2"},
        descendants = {"unstable_1"}
    }

    VirtualRank{
        id = "unstable_e",
        ascendants = {"3"},
        descendants = {"2"}
    }

    VirtualRank{
        id = "unstable_pi",
        ascendants = {"4"},
        descendants = {"3"}
    }

    VirtualRank{
        id = "unstable_11",
        ascendants = {"unstable_12"},
        descendants = {"10"}
    }

    VirtualRank{
        id = "unstable_12",
        ascendants = {"unstable_13"},
        descendants = {"unstable_11"}
    }

    VirtualRank{
        id = "unstable_13",
        ascendants = {"A_high"},
        descendants = {"unstable_12"}
    }
end

-- == Showdown ranks
if G.has_mods.showdown then
    VirtualRank{
        id = "showdown_2_5",
        ascendants = {"3"},
        descendants = {"A_low"}
    }

    VirtualRank{
        id = "showdown_5_5",
        ascendants = {"6"},
        descendants = {"4"}
    }

    VirtualRank{
        id = "showdown_8_5",
        ascendants = {"9"},
        descendants = {"7"}
    }

    VirtualRank{
        id = "showdown_butler",
        ascendants = {"Q", "showdown_princess"},
        descendants = {"10"}
    }

    VirtualRank{
        id = "showdown_princess",
        ascendants = {"K", "showdown_lord"},
        descendants = {"J", "showdown_butler"}
    }

    VirtualRank{
        id = "showdown_lord",
        ascendants = {"A_high"},
        descendants = {"Q", "showdown_princess"}
    }
end

-- == Strange Pencil ranks
if G.has_mods.strangePencil then
    VirtualRank{
        id = "strangePencil_sneven",
        ascendants = {"8"},
        descendants = {"6", "7"}
    }
end