------------------------
-- CARD CLASS
------------------------

Card = class()

function Card:init()
   self.properties = {}
end

function Card:setProperty(property, value)
   assert(
   property:valueLegal(value),
   string.format(value, "value '%s' not allowed for property")
   )
   self.properties[property] = value
end

function Card:removeProperty(property)
   self.properties[property] = nil
end

function Card:hasProperty(property)
   return self.properties[property] and true
end

function Card:getPropertyValue(property)
   assert(self:hasProperty(property), "property missing from Card")
   return self.properties[property]
end

function Card:__tostring()
   local str = ""
   for property, value in pairs(self.properties) do
      str = str .. tostring(property:symbol(value))
   end
   return str
end

function Card:__shl(other)
   return CardComparison(self, other, OP_LT)
end

function Card:__shr(other)
   return CardComparison(other, self, OP_LT)
end

function Card:__bxor(other)
   return CardComparison(self, other, OP_EQ)
end


------------------------
-- CARD COMPARISON
------------------------

CardComparison = class()

OP_EQ = 1
OP_LT = 2

function CardComparison:init(card1, card2, operation)
   self.card1 = card1
   self.card2 = card2
   self.operation = operation
end

function CardComparison:__bor(property)
   local value1 = self.card1:getPropertyValue(property)
   local value2 = self.card2:getPropertyValue(property)
   if     self.operation == OP_LT then
      return value1 < value2
   elseif self.operation == OP_EQ then
      return value1 == value2
   else
      error("Unknown CardComparison operator.")
   end
end


------------------------
-- CARD PROPERTIES
------------------------

CardProperty = class()

function CardProperty:init(allowedValues)
   self.allowedValues = allowedValues
end

function CardProperty:valueLegal(value)
   return self.allowedValues[value] and true
end

function CardProperty:symbol(value)
   return self.allowedValues[value]
end

function CardProperty:__len()
   return #self.allowedValues
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
