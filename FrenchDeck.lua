------------------------
-- FRENCH DECK FACTORY
------------------------
-- A standard playing card deck of 4 suits with 13 ranks each.

FrenchDeck = class(Deck)

-- Class constants for compatibility across different instances
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
   return self
end

function FrenchDeck:sortedBySuit(descending)
   return Deck.sorted(self, self.suitProperty, descending)
end

function FrenchDeck:sortedByRank(descending)
   return Deck.sorted(self, self.rankProperty, descending)
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

HAND_ROYAL_FLUSH = 1
HAND_STRAIGHT_FLUSH = 2
HAND_FOUR_KIND = 3
HAND_FULL_HOUSE = 4
HAND_FLUSH = 5
HAND_STRAIGHT = 6
HAND_THREE_KIND = 7
HAND_TWO_PAIRS = 8
HAND_PAIR = 9
HAND_HIGH_CARD = 10
FrenchDeck.pokerHandNames = {
   "Royal Flush",
   "Straight Flush",
   "Four of a Kind",
   "Full House",
   "Flush",
   "Straight",
   "Three of a Kind",
   "Two Pairs",
   "Pair",
   "High Card"
}
function FrenchDeck:pokerHand()
   local processed = self:distinct():sorted(self.rankProperty, true)
   -- Flush straights
   local hasFlush, hasRoyal
   for value, deck in processed:byProperty(self.suitProperty) do
      if #deck >= 5 then
         hasFlush = true
         hasRoyal = true
         local count, lastCard
         for index, card in deck:browse() do
            if not count then
               count = 1
            else
               if lastCard - card | self.rankProperty == 1 then
                  count = count + 1
                  if count == 5 then
                     if hasRoyal then
                        return HAND_ROYAL_FLUSH
                     else
                        return HAND_STRAIGHT_FLUSH
                     end
                  end
               else
                  count = nil
                  hasRoyal = false
               end
            end
            lastCard = card
         end
      end
   end
   -- 4 of a kind and full house
   local hasThree
   local pairCount = 0
   for value, deck in processed:byProperty(self.rankProperty) do
      if #deck == 4 then
         return HAND_FOUR_KIND
      elseif #deck == 3 then
         if hasThree or pairCount > 0 then
            return HAND_FULL_HOUSE
         end
         hasThree = true
      elseif #deck == 2 then
         if hasThree then
            return HAND_FULL_HOUSE
         end
         pairCount = pairCount + 1
      end
   end
   -- Flush
   if hasFlush then
      return HAND_FLUSH
   end
   -- Straight
   local count, lastCard, valueDiff
   for index, card in processed:browse() do
      if not count then
         count = 1
      else
         valueDiff = lastCard - card | self.rankProperty == 1
         if valueDiff then
            count = count + 1
            if count == 5 then
               return HAND_STRAIGHT
            end
         else
            count = nil
            hasRoyal = false
         end
      end
      lastCard = card
   end
   -- 3 of a kind
   if hasThree then
      return HAND_THREE_KIND
   elseif pairCount > 1 then
      return HAND_TWO_PAIRS
   elseif pairCount > 0 then
      return HAND_PAIR
   end
   return HAND_HIGH_CARD
end
