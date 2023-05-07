-- kjellCards

function setup()
   DEBUG = true
   
   local deck1 = FrenchDeck():fill():shuffled()
   local deck2 = deck1:split(26)
   deck1 = deck1:merge(deck1:copy()):shuffled()
   deck1:split(13)
   print("Cards in deck 1:", #deck1)
   print("Cards in deck 2:", #deck2)
   
   print("Sort deck by rank")
   deck1:sortedByRank()
   for index, card in deck1:sortedByRank():browse() do
      print(index, card)
   end
   
   print("Distinct")
   for index, card in deck1:distinct():browse() do
      print(index, card)
   end
   
   print("By property")
   for value, deck in deck1:distinct():byProperty(deck1.suitProperty) do
      print(deck1.suitProperty:symbol(value), #deck, "cards")
      for index, card in ipairs(deck.cards) do
         print("", card)
      end
   end
   
   print("All aces in second deck")
   for index, card in deck2:filteredSuitRank(nil, 1):browse() do
      print(index, card)
   end
end