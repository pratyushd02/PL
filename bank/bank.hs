{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Bank where

import Control.Monad.State

newtype BankOp a = BankOp { runBankOp' :: State Float a }
  deriving (Functor, Applicative, Monad)

deposit :: Float -> BankOp ()
deposit amount = BankOp $ modify (+ amount)

withdraw :: Float -> BankOp Float
withdraw amount = BankOp $ do
    balance <- get
    let withdrawAmount = min amount (balance + 100)
    put (balance - withdrawAmount)
    return withdrawAmount

getBalance :: BankOp Float
getBalance = BankOp get

runBankOp :: BankOp a -> a
runBankOp op = evalState (runBankOp' op) 0.0

