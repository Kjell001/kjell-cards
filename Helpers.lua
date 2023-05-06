-- Creates cards of all possible property combinations. The amount of cards
-- created is equal to the product of the allowedValues length of each
-- property.
function allPropertyPermutations(properties)
   local card
   local values = {}
   local cards = {}
   
   local function setRecursively(depth)
      depth = depth or 1
      local property = properties[depth]
      if not property then
         card = Card()
         for i = 1, depth - 1 do
            card:setProperty(properties[i], values[i])
         end
         table.insert(cards, card)
      else
         for value in pairs(property.allowedValues) do
            values[depth] = value
            setRecursively(depth + 1)
         end
      end
   end
   
   setRecursively()
   return cards
end
