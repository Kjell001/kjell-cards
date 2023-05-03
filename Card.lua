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
