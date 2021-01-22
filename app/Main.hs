module Main where

import qualified Calculate
import qualified System.Environment
import Data.Csv(decode, HasHeader(NoHeader))
import Prelude hiding (readFile)
import Data.ByteString.Lazy(readFile)
import Data.ByteString.Lazy.Char8(unpack)
import Data.Aeson.Encode.Pretty(encodePretty)

main :: IO ()
main = do
  args <- System.Environment.getArgs
  case args of
    [csv_file] -> do
      csv_data <- readFile csv_file
      case (decode NoHeader csv_data) of
        Right matches -> putStr $ unpack (encodePretty (Calculate.resultsBySymbol matches))
        Left err -> error err
    _ ->
      error "expected csv file"
