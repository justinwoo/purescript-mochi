module Test.Main where

import Prelude

import Effect (Effect)
import Mochi (constructRecord)
import Test.Assert (assertEqual)
import Type.Prelude (Proxy(..))

type Fruits =
  { apple :: Int
  , banana :: String
  , cherry :: Boolean
  }

-- IDE inferred type signature:
mkFruits
  :: Int
  -> String
  -> Boolean
  -> { apple :: Int
     , banana :: String
     , cherry :: Boolean
     }
mkFruits = constructRecord (Proxy :: Proxy Fruits)

main :: Effect Unit
main = do
  let (fruits :: Fruits) = { apple: 1, banana: "a", cherry: true }
  assertEqual
    { expected: fruits
    , actual: mkFruits 1 "a" true
    }
