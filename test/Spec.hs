import Test.Hspec
import qualified Calculate
import Data.Vector(fromList)
import Data.Map.Strict(Map, empty, fromList)

main :: IO ()
main = hspec $ do
  describe "Calc.resultsBySymbol" $ do
    it "returns empty for []" $ do
      Calculate.resultsBySymbol (Data.Vector.fromList []) `shouldBe` (empty :: Map Calculate.Symbol Calculate.Result)

    it "returns [(s, Result p v] for [Match s p v]" $ do
      let symbol = "s"
      let price = 1.0
      let volume = 2
      let matches = Data.Vector.fromList [Calculate.Match symbol price volume]
      let results = Data.Map.Strict.fromList [(symbol, Calculate.Result price volume)]
      Calculate.resultsBySymbol matches `shouldBe` results

    it "returns [(s, Result p v), (s', Result p' v')] for [Match s p v, Match s' p' v']" $ do
      let symbol = "s"
      let price = 1.0
      let volume = 2
      let symbol' = "s"
      let price' = 2.0
      let volume' = 3
      let matches = Data.Vector.fromList [Calculate.Match symbol price volume, Calculate.Match symbol' price' volume']
      let results = Data.Map.Strict.fromList [(symbol, Calculate.Result price volume), (symbol', Calculate.Result price' volume')]
      Calculate.resultsBySymbol matches `shouldBe` results

    it "returns [(s, Result (p * v + p' * v') / (v + v') v + v'] for [Match s p v, Match s p' v']" $ do
      let symbol = "s"
      let price = 1.0
      let volume = 2
      let price' = 2.0
      let volume' = 3
      let matches = Data.Vector.fromList [Calculate.Match symbol price volume, Calculate.Match symbol price' volume']
      let volumeResult = volume + volume'
      let priceResult = (price * (fromIntegral volume) + price' * (fromIntegral volume')) / (fromIntegral volumeResult)
      let results = Data.Map.Strict.fromList [(symbol, Calculate.Result priceResult volumeResult)]
      Calculate.resultsBySymbol matches `shouldBe` results
