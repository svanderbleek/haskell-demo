module Calculate (
  resultsBySymbol,
  Symbol,
  Match(Match), Result(Result)) where

import Data.Map.Strict(Map, insertWith, empty, map)
import Data.List(foldl')
import Data.Vector(Vector)
import Data.Csv(FromRecord, parseRecord, (.!))
import Data.Aeson(ToJSON, toJSON, object, (.=))
import Data.Text(pack)

type Symbol = String
type Price = Float
type Volume = Integer

data Match =
  Match Symbol Price Volume

instance FromRecord Match where
  parseRecord record
    | length record == 6 = Match <$> (record .! 2) <*> (record .! 4) <*> (record .! 5)
    | otherwise = error "expected csv record to be length 6"

data Result' =
  Result' Price Volume

data Result =
  Result Price Volume
  deriving (Eq)

instance ToJSON Result where
  toJSON (Result price volume) =
    object [pack "vwap" .= price, pack "volume" .= volume]

resultsBySymbol :: Vector Match -> Map Symbol Result
resultsBySymbol matches =
  Data.Map.Strict.map finalResult (foldl' stepResults empty matches)

stepResults :: Map Symbol Result'-> Match -> Map Symbol Result'
stepResults results (Match symbol price volume) =
  insertWith updateResult symbol resultUpdate results
  where
    resultUpdate =
      Result' (price * (fromIntegral volume)) volume
    updateResult (Result' price' volume') (Result' price'' volume'') =
      Result' (price' + price'') (volume' + volume'')

finalResult :: Result' -> Result
finalResult (Result' price volume) =
  Result (price / (fromIntegral volume)) volume
