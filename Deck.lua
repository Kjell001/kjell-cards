Deck = class()

function Deck:init(cards)
   self.cards = {}
   if cards then
      self:addCards(cards)
   end
end

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

function Deck:search(condition)
   local results = {}
   for index, card in ipairs(self.cards) do
      if condition:evaluate(card) then
         table.insert(results, index)
      end
   end
   return results
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

function Deck:split(index)
   local amount = #self.cards - index + 1
   return newInstance(self, self:pickCardRange(index, amount))
end

function Deck:__len()
   return #self.cards
end


PropertyCondition = class()

function PropertyCondition:init(property, test)
   self.property = property
   self.test = test
end

function PropertyCondition:evaluate(card)
   if not card:hasProperty(self.property) then
      return
   end
   local propertyValue = card:getPropertyValue(self.property)
   return self.test(propertyValue.value) and true
   local value = card:getPropertyValue(self.property)
   return self.test(value) and true
end


PropertyConditionSet = class()

function PropertyConditionSet:init(conditions)
   self.conditions = conditions
end

function PropertyConditionSet:evaluate(card)
   for _, condition in ipairs(self.conditions) do
      if not condition:evaluate(card) then
         return false
      end
   end
   return true
end
