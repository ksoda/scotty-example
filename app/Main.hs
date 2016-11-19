{-# LANGUAGE OverloadedStrings #-}
module Main where
import Web.Scotty
import Data.Monoid (mconcat, (<>))

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
