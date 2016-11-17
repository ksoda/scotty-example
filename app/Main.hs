{-# LANGUAGE OverloadedStrings #-}
module Main where
import Web.Scotty
import Data.Monoid (mconcat)

main :: IO ()
main = do
  putStrLn "Starting Server..."
  scotty 3000 $
    get "/hello" $
      text "hello world!"
-- main = scotty 3000 $ do
--   get "/:word" $ do
--     beam <- param "word"
--     html $ mconcat ["<h1>Scotty, ", beam, " me up!</h1>"]
