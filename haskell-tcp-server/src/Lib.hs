{-# LANGUAGE OverloadedStrings #-}
module Lib
    ( run
    ) where

import           Data.Conduit
import           Data.Conduit.Network
import qualified Data.ByteString.Char8 as BS

run :: IO ()
run = runTCPServer (serverSettings 4000 "*") $ \appData ->
    appSource appData $$ appSink appData
