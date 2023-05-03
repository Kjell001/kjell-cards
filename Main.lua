-- kjellCards

function setup()
   DEBUG = true
   
   local deck = FrenchDeck()
   
   print("All aces:")
   local results = deck:findSuitRank(nil, 1)
   for i, v in ipairs(deck:seeCards(results)) do
      print(i, v)
   end
   
   print("Letter card spades")
   local letterCondition = PropertyCondition(
      deck.rankProperty,
      (function(v) return v == 1 or v > 10 end)
   )
   local rankCondition = PropertyCondition(
      deck.suitProperty,
      (function(v) return v == 1 end)
   )
   results = deck:find(PropertyConditionSet{letterCondition, rankCondition})
   for i, v in ipairs(deck:seeCards(results)) do
      print(i, v)
   end
   
   print("Shuffle, split and group")
   deck:shuffle()
   local subdeck = deck:split(14)
   local suitGroups = deck:groupBy(deck.suitProperty)
   for value, group in pairs(suitGroups) do
      print("Group", deck.suitProperty:symbol(value))
      for i, index in ipairs(group) do
         print(i, deck:seeCard(index))
      end
   end
end