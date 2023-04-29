FrenchDeck = class(Deck)

function FrenchDeck:init()
   local frenchSuits = {"♠", "♥", "♦", "♣"}
   local frenchRanks =
      {"A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"}
   self.suitProperty = CardProperty(frenchSuits)
   self.rankProperty = CardProperty(frenchRanks)
   self.cards = allPropertyPermutations{self.suitProperty, self.rankProperty}
end

function FrenchDeck:searchSuitRank(suit, rank)
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
   return Deck.search(self, PropertyConditionSet(conditions))
end
