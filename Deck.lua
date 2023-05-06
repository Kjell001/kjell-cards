Deck = class()

function Deck:init(cards)
   self.cards = {}
   if cards then
      self:addCards(cards)
   end
end

-- CARD MANAGEMENT

function Deck:addCard(card, index)
   assert(getmetatable(card) == Card, "'card' is not an instance of Card")
   if not index then
      table.insert(self.cards, card)
      return
   end
   assert(index > 0, "'index' must be positive")
   assert(index <= #self.cards + 1, "'index' too large")
   table.insert(self.cards, index, card)
end

function Deck:addCards(cards, index)
   if index then
      for i = #cards, 1, -1 do
         self:addCard(cards[i], index)
      end
   else
      for i = 1, #cards do
         self:addCard(cards[i])
      end
   end
end

function Deck:pushCards(cards)
   self:addCards(cards, 1)
end

function Deck:seeCard(index)
   assert(#self.cards > 0, "deck is empty")
   assert(index > 0, "'index' must be positive")
   assert(index <= #self.cards, "'index' too large")
   return self.cards[index]
end

function Deck:seeCards(indices)
   local cards = {}
   for _, index in ipairs(indices) do
      table.insert(cards, self:seeCard(index))
   end
   return cards
end

function Deck:seeCardRange(index, amount)
   local cards = {}
   for _ = 1, amount do
      table.insert(cards, self:seeCard(index))
   end
   return cards
end

function Deck:pickCard(index)
   assert(#self.cards > 0, "deck is empty")
   assert(not index or index > 0, "'index' must be positive")
   assert(not index or index <= #self.cards, "'index' too large")
   return table.remove(self.cards, index)
end

function Deck:pickCards(indices)
   local cards = {}
   for _, index in ipairs(indices) do
      table.insert(cards, self:pickCard(index))
   end
   return cards
end

function Deck:pickCardRange(index, amount)
   local cards = {}
   for _ = 1, amount do
      table.insert(cards, self:pickCard(index))
   end
   return cards
end

function Deck:drawCards(amount)
   local cards = {}
   for _ = 1, amount do
      table.insert(cards, self:pickCard())
   end
   return cards
end

-- PROPERTY MANAGEMENT

-- DECK MANIPULATION

function Deck:sort(property, descending)
   local comp
   if descending then
      function comp(a, b)
         return b.properties[property] < a.properties[property]
      end
   else
      function comp(a, b)
         return a.properties[property] < b.properties[property]
      end
   end
   table.sort(self.cards, comp)
end

function Deck:shuffle()
   local cards = self.cards
   for i = #cards, 2, -1 do
      j = math.random(i)
      cards[i], cards[j] = cards[j], cards[i]
   end
end

function Deck:reverse()
   local revCards = {}
   for i = 1, #self.cards do
      revCards[i] = table.remove(self.cards)
   end
   self.cards = revCards
end

function Deck:copy()
   local newDeck = newInstance(self)
   newDeck:addCards(self.cards)
   return newDeck
end

function Deck:merge(other, clear)
   self:addCards(other.cards)
   if clear then
      other.cards = {}
   end
end

function Deck:split(afterIndex)
   local newDeck = newInstance(self)
   local amount = #self.cards - afterIndex
   newDeck:addCards(self:pickCardRange(afterIndex + 1, amount))
   return newDeck
end

-- ADVANCED MANIPULATION

function Deck:filtered(condition)
   local cards = {}
   for index, card in ipairs(self.cards) do
      if condition:evaluate(card) then
         table.insert(cards, card)
      end
   end
   return Deck(cards)
end

function Deck:first(condition)
   for index, card in ipairs(self.cards) do
      if condition:evaluate(card) then
         return card
      end
   end
end

function Deck:distinct()
   local newDeck = Deck()
   local set = {}
   for index, card in ipairs(self.cards) do
      if not set[card] then
         set[card] = true
         newDeck:addCard(card)
      end
   end
   return newDeck
end

function Deck:byProperty(property)
   local decks = {}
   local value
   for index, card in ipairs(self.cards) do
      if card:hasProperty(property) then
         value = card:getPropertyValue(property)
         decks[value] = decks[value] or Deck()
         decks[value]:addCard(card)
      end
   end
   return pairs(decks)
end

-- METAMETHODS

function Deck:__len()
   return #self.cards
end
