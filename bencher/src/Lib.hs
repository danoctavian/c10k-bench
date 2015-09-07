{-# LANGUAGE OverloadedStrings #-}
module Lib
    ( run
    ) where

import Data.Conduit.Network
import Data.Conduit.List as CL
import Data.Conduit
import System.Environment
import Control.Concurrent
import Control.Concurrent.Async
import Data.Time.Clock.POSIX

import qualified Data.ByteString as BS

msg = BS.concat $ Prelude.replicate 100 "this is my message bitch"


run = runBench

runBench :: IO ()
runBench = do
  args <- getArgs 
  let clientCount = read $ args !! 0
  let testTime =  read $ args !! 1 -- in seconds
  putStrLn $ "testing for " ++ show clientCount ++ " clients for " ++ show testTime ++ " seconds."

  reqCounts <- mapConcurrently (connThread testTime) [1..clientCount]

  putStrLn $ "the server completed " ++ show (sum reqCounts)

connThread testTime tid = do
  start <- getTime
  loop testTime start 0 

loop testTime startTime reqCount = do
  runConn
  now <- getTime
  if (now - startTime < testTime)
    then loop testTime startTime (reqCount + 1)
    else return reqCount -- we're done

runConn :: IO ()
runConn = runTCPClient (clientSettings 4000 "127.0.0.1") $ \app -> do
  sourceList [msg] $$ appSink app
  res <- appSource app $$ CL.take 1
  return ()

getTime :: IO Integer
getTime = (round) `fmap` getPOSIXTime
