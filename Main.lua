-- kjellCards

function setup()
   DEBUG = true
   
   local deck = FrenchDeck()
   
   print("All aces:")
   local results = deck:searchSuitRank(nil, 1)
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
   results = deck:search(PropertyConditionSet{letterCondition, rankCondition})
   for i, v in ipairs(deck:seeCards(results)) do
      print(i, v)
   end
   
   print("Shuffle and split")
   deck:shuffle()
   local subdeck = deck:split(27)
   local cards = deck:drawCards(13)
   for i, card in ipairs(cards) do
      print(i, card)
   end
   print("Remaining in deck:", #deck.cards)
end