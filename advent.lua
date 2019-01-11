#! /bin/env lua
--[[-%tabs=4-----------------------------------------------------------------
|	                                                                    	|
|	Module:		advent.lua                                               	|
|	Function:	Load data for Advent of Code puzzle                        	|
|	Created:	16:04:10  15 Dec  2018                                  	|
|	Author:		Andrew Cannon <ajc@gmx.net>                                	|
|	                                                                    	|
|	Copyright(c) 2018-2019 Andrew Cannon                                  	|
|	Licensed under the terms of the MIT License                            	|
|	                                                                    	|
]]---------------------------------------------------------------------------
local advent = {}
if _VERSION:match"Lua 5%.[12]" then
	module("advent",package.seeall)
	advent = _G.advent
end


local function loadData(file, block)
	local fd = file == '-' and io.stdin or io.open(file, "r")
	local start = true
	local active = not block
	local out = {}
	local blank = "^%s*$"
	local sentinel
	local havesentinel
	local lnum = 1
	
--	print(file)
	
	if not fd then return nil, "data file not found" end
	
--	print(block)
	
	local getline = fd:lines()
	for line in getline do
		lnum = lnum + 1
		if line:match"^%s*$" and (not sentinel or havesentinel) then
--			print("eop at "..lnum)
			if active then
				break
			else
				start = true
			end
		elseif start and line:match"%S+" == block then
			sentinel = line:match"%S+%s+(%S+)"
			
--			print("found block " .. block)
			if sentinel then
				sentinel = "^" .. sentinel:gsub("%^%$%(%)%%%.%[%]%*%+%-%?", "%1") .. "%s*$"
--				print("sentinel="..sentinel)
			end
			active = true
		elseif active then
			havesentinel = sentinel and line:match(sentinel)
			table.insert(out, line)
		elseif start then
			start = false
		end
	end
	if file ~= '-' then
		fd:close()
	end	
	
	if not active then return nil, "data not found" end
	
	return table.concat(out, "\n") .. "\n", out
end

local function getData(x)
	local name = arg[0]:match"advent%d%d%d%d"
--	print(name)
	if x then
		if x == true or tonumber(x) then
			name = name .. "example" .. (x == true and "" or tostring(x))
		else
			return loadData(x)	-- x is filename or "-"
		end
	end
	return loadData(name:sub(1,8) .. ".dat", name)
end

advent.getData = getData

return advent
