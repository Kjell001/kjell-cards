FrenchDeck = class(Deck)

function FrenchDeck:init()
   local frenchSuits = {"♠", "♥", "♦", "♣"}
   local frenchRanks =
      {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}
   self.suitProperty = CardProperty(frenchSuits)
   self.rankProperty = CardProperty(frenchRanks)
   self.cards = allPropertyPermutations{self.suitProperty, self.rankProperty}
end

function FrenchDeck:findSuitRank(suit, rank, amount)
   local conditions = {}
   if suit then
      local suitCondition = PropertyCondition(
         self.suitProperty,
         (function(v) return v == suit end)
      )
      table.insert(conditions, suitCondition)
   end
   if rank then
      local rankCondition = PropertyCondition(
         self.rankProperty,
         (function(v) return v == rank end)
      )
      table.insert(conditions, rankCondition)
   end
   return Deck.find(self, PropertyConditionSet(conditions), amount)
end

function FrenchDeck:findFirstSuitRank(suit, rank)
   local results = self:findSuitRank(suit, rank, 1)
   return results[1]
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
