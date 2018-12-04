module Mochi where

import Foreign.Object as FO
import Prim.Row as Row
import Prim.RowList as RL
import Type.Prelude (class IsSymbol, RLProxy(..), SProxy(..), reflectSymbol)
import Unsafe.Coerce (unsafeCoerce)

class ConstructRecord ty fn | ty -> fn where
  constructRecord :: forall proxy. proxy ty -> fn

instance rowConstructRecord ::
  ( RL.RowToList row rl
  , ConstructRL rl row fn
  ) => ConstructRecord { | row } fn where
  constructRecord _ = unsafeConstruct (RLProxy :: RLProxy rl) FO.empty

data Placeholder

class ConstructRL (rl :: RL.RowList) (row :: # Type) fn | rl -> row fn where
  unsafeConstruct :: forall proxy. proxy rl -> FO.Object Placeholder -> fn

instance nilConstructRL :: ConstructRL RL.Nil row { | row } where
  unsafeConstruct _ obj = unsafeCoerce obj

instance consConstructRL ::
  ( IsSymbol name
  , Row.Cons name a row' row
  , ConstructRL tail row fn
  ) => ConstructRL (RL.Cons name a tail) row (a -> fn) where
  unsafeConstruct _  obj =
    \x -> unsafeConstruct tailP (FO.insert name (unsafeCoerce x) obj)
    where
      tailP = RLProxy :: RLProxy tail
      name = reflectSymbol (SProxy :: SProxy name)
