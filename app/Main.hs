{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Main where
import GHC.Generics
import Data.Monoid (mconcat, (<>))

import Web.Scotty
import Data.Aeson (FromJSON, ToJSON)

data User = User { userId :: Int
                 , userName :: String
                 } deriving (Show, Generic)

instance ToJSON User
instance FromJSON User

main :: IO ()
main = do
  putStrLn "Starting Server..."
  scotty 3000 routes

routes :: ScottyM ()
routes = get "/hello/:name" hello

hello :: ActionM ()
hello = do
  name <- param "name"
  text $ "hello " <> name

-- main = scotty 3000 $ do
--   get "/:word" $ do
--     beam <- param "word"
--     html $ mconcat ["<h1>Scotty, ", beam, " me up!</h1>"]

allUsers :: [User]
allUsers = [bob, jenny]

bob :: User
bob = User { userId = 1, userName = "bob" }

jenny :: User
jenny = User { userId = 2, userName = "jenny" }
