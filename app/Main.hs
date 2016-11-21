{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Main where
import GHC.Generics
import Data.Monoid (mconcat, (<>))

import Web.Spock
import Web.Spock.Config
import qualified Data.Text as Text
import Data.Aeson (FromJSON, ToJSON)

data User = User { userId :: Int
                 , userName :: String
                 } deriving (Show, Generic)

instance ToJSON User
instance FromJSON User

main :: IO ()
main = do
  spockCfg <- defaultSpockCfg () PCNoDatabase ()
  runSpock 8080 $ spock spockCfg $ do

    get root $
      text "Hello Spock!"

    get ("hello" <//> var) $ \name ->
      text (Text.concat ["Hello ", name, "!"])
