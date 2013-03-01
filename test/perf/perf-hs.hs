#!/usr/bin/env runhaskell
import Language.DevSurf (parse2dm, elements, area)

main :: IO ()
main = interact $ render . sum . map area . elements . parse2dm

render :: Double -> String
render a = "Haskell Area" ++ show a
