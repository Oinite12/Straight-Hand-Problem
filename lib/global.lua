require 'lib.dbug'
require 'lib.objects.set'

G = {}
G.alwaysTrue = function() return true end

G.ID = 0
function G.get_id()
    G.ID = G.ID + 1
    return G.ID
end

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