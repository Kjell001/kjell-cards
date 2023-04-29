Card = class()

function Card:init()
   self.properties = {}
end

function Card:setProperty(property, value)
   self.properties[property] = property:make(value)
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
   for k, v in pairs(self.properties) do
      str = str .. tostring(v)
   end
   return str
end


CardPropertyValue = class()

function CardPropertyValue:init(property, value)
   self.property = property
   assert(property:valueLegal(value), "value not allowed for property")
   self.value = value
end

function CardPropertyValue:__tostring()
   return self.property:representation(self.value)
end


CardProperty = class()

function CardProperty:init(allowedValues)
   self.allowedValues = allowedValues
end

function CardProperty:valueLegal(value)
   return self.allowedValues[value] and true
end

function CardProperty:make(value)
   return CardPropertyValue(self, value)
end

function CardProperty:representation(value)
   return self.allowedValues[value]
end

function CardProperty:__len()
   return #self.allowedValues
end
