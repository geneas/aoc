{-
--[[-%tabs=6-------------------------------------------------------------------
|	                                                                    	|
|	Module:	advent.hs                                               	|
|	Function:	Load data for Advent of Code puzzle                        	|
|	Created:	16:04:10  15 Dec  2018                                  	|
|	Author:	Andrew Cannon <ajc@gmx.net>                                	|
|	                                                                    	|
|	Copyright(c) 2018-2019 Andrew Cannon                                  	|
|	Licensed under the terms of the MIT License                            	|
|	                                                                    	|
-------------------------------------------------------------------------------
-}

module Advent where

import System.Environment
import Data.List

data Mode = Normal | Example (Maybe Int) | File String

getData :: Mode -> IO [[String]]
getData mode = do
	progName <- getProgName
	let file = case mode of
		File f -> f
		otherwise -> take 8 progName ++ ".dat"
	content <- readFile file
	let	key = case mode of
			Normal -> progName
			Example Nothing -> progName ++ "example"
			Example (Just n) -> progName ++ "example" ++ show n
			File _ -> ""
		flines = lines content
		in case mode of
			File _ -> return [ flines ]
			otherwise ->
				let	(_, flines') = break (key `isPrefixOf`) flines
					sentinel = unwords $ tail $ words $ head flines'
					flines'' = tail flines'
					indata x = (not $ null x) && (not $ null $ head x)
					sep c s =
						let (s', s'') = break (c ==) s
						in case s'' of
						[] -> [s']
						otherwise -> s':sep c (tail s'')
				in return $
					if null flines' then error "*** data not found ***"
					else case sentinel of
					"" -> [ head $ sep "" flines'' ]
					s -> takeWhile indata $ sep s flines''
