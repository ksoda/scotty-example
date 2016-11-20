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
  scotty 3000 $ do
    get "/hello/:name" $ do
        name <- param "name"
        text ("hello " <> name <> "!")

    get "/users" $ do
      json allUsers

    get "/users/:id" $ do
      id <- param "id"
      json (filter (matchesId id) allUsers)

matchesId :: Int -> User -> Bool
matchesId id user = userId user == id

allUsers :: [User]
allUsers = [bob, jenny]

bob :: User
bob = User { userId = 1, userName = "bob" }

jenny :: User
jenny = User { userId = 2, userName = "jenny" }
