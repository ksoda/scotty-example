{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Main where
import GHC.Generics

import Web.Spock
import Web.Spock.Config
import Network.HTTP.Types.Status (status400)
import Control.Monad.IO.Class (MonadIO)
import qualified Data.Text as Text
-- import Data.Aeson (FromJSON, ToJSON)

-- data User = User { userName :: String
--                  , password :: String
--                  } deriving (Show, Generic)

-- instance ToJSON User
-- instance FromJSON User

userList :: [(Text, Text)]
userList =
  [ ("lotz", "password1")
  , ("alice", "password2")
  , ("bob", "password3")
  ]
  -- [ User { userName = "lotz", password = "password1"}
  -- , User { userName = "alice", password = "password2"}
  -- , User { userName = "bob", password = "password3"}
  -- ]

findCredential :: MonadIO m => ActionCtxT ctx m (Maybe (Text, Text))
findCredential = do
  username <- param "username"
  password <- param "password"
  pure $ (,) <$> username <*> password


main :: IO ()
main = do
  spockCfg <- defaultSpockCfg () PCNoDatabase ()
  runSpock 8080 $ spock spockCfg $ do

    get root $
      text "Hello Spock!"

    get ("hello" <//> var) $ \name ->
      text (Text.concat ["Hello ", name, "!"])

    post "login" $ do
      credential <- findCredential
      case credential of
        Nothing -> setStatus status400 >> text "Missing parameter."
        Just (username, password) ->
          if lookup username userList == Just password
            then text "Login succeed."
            else setStatus status400 >> text "Wrong parameter."
