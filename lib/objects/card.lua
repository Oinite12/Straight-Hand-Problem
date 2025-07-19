require 'lib.object_prim'

---@class Card
Card = Object:extend()
function Card:init(rank, suit)
    self.id = G.get_id()
    self.rank = rank
    self.suit = suit or "n/a"
end

function Card:to_string()
    return ("Card[ %s of %s ]"):format(self.rank, self.suit)
end
Card.__tostring = Card.to_string