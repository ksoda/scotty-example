{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Spock
import Web.Spock.Config
import Network.HTTP.Types.Status (status400)
import Network.Wai.Handler.Warp (Port)
import System.Environment (getEnvironment)
import Control.Monad.IO.Class (MonadIO)
import Data.List (lookup)
import Data.Maybe
import qualified Data.Text as T

userList :: [(T.Text, T.Text)]
userList =
  [ ("lotz", "password1")
  , ("alice", "password2")
  , ("bob", "password3")
  ]

findCredential :: MonadIO m => ActionCtxT ctx m (Maybe (T.Text, T.Text))
findCredential = do
  username <- param "username"
  password <- param "password"
  pure $ (,) <$> username <*> password


main :: IO ()
main = do
  port <- getPort
  putStr "start Server: http://localhost:"
  print port
  spockCfg <- defaultSpockCfg () PCNoDatabase ()
  runSpock port $ spock spockCfg $ do

    get root $
      text "Hello Spock!"

    get ("hello" <//> var) $ \name ->
      text (T.concat ["Hello ", name, "!"])

    post "login" $ do
      credential <- findCredential
      case credential of
        Nothing -> setStatus status400 >> text "Missing parameter."
        Just (username, password) ->
          if lookup username userList == Just password
            then text "Login succeed."
            else setStatus status400 >> text "Wrong parameter."

getPort :: IO Port
getPort = fmap port getEnvironment
  where
    port = maybe defaultPort read . lookup "PORT"

defaultPort :: Port
defaultPort = 3000
