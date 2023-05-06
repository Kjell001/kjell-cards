-- A standard playing card deck of 4 suits with 13 ranks each.

FrenchDeck = class(Deck)

-- Define properties as class constants for compatibility across different
-- FrenchDeck instances
FrenchDeck.suitProperty = CardProperty{
   "♠", "♥", "♦", "♣"
}
FrenchDeck.rankProperty = CardProperty{
   "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"
}

function FrenchDeck:init()
   Deck.init(self)
end

function FrenchDeck:fill()
   self.cards = allPropertyPermutations{self.suitProperty, self.rankProperty}
end

function FrenchDeck:sortBySuit()
   Deck.sort(self, self.suitProperty)
end

function FrenchDeck:sortByRank()
   Deck.sort(self, self.rankProperty)
end

function FrenchDeck:makeSuitCondition(suit)
   return PropertyCondition(
      self.suitProperty,
      (function(v) return v == suit end)
   )
end

function FrenchDeck:makeRankCondition(rank)
   return PropertyCondition(
      self.rankProperty,
      (function(v) return v == rank end)
   )
end

function FrenchDeck:makeCondition(suit, rank)
   local conditions = {}
   if suit then
      table.insert(conditions, self:makeSuitCondition(suit))
   end
   if rank then
      table.insert(conditions, self:makeRankCondition(rank))
   end
   return PropertyConditionSet(conditions)
end

function FrenchDeck:filteredSuitRank(suit, rank)
   return Deck.filtered(self, self:makeCondition(suit, rank))
end

function FrenchDeck:firstSuitRank(suit, rank)
   return Deck.first(self, self:makeCondition(suit, rank))
end

function FrenchDeck:pokerHand()
   -- Royal flush
   -- Straight flush
   -- Straight
   -- Flush
   -- 4 of a kind
   -- Full house
   -- 3 of a kind
   -- Two pairs
   -- Pair
   -- High card
end
