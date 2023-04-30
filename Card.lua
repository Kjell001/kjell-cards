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
