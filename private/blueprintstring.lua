--[[
Blueprint String
Version: 1.0.1
LastModified: May 11 2015
Copyright (C) 2015 David McWilliams
	
This library is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
http://creativecommons.org/licenses/by-nc-sa/4.0/

This library helps you convert blueprints to text strings, and text strings to blueprints.

Saving Blueprints
-----------------
local BlueprintString = require "blueprintstring.blueprintstring"
local blueprint_table = {}
blueprint_table.icons = blueprint.blueprinticons
blueprint_table.entities = blueprint.getblueprintentities()
blueprint_table.myfield = "Add some extra fields if you want"
local str = BlueprintString.toString(blueprint_table)

Loading Blueprints
------------------
local BlueprintString = require "blueprintstring.blueprintstring"
local blueprint_table = BlueprintString.fromString(str)
blueprint.setblueprintentities(blueprint_table.entities)
blueprint.blueprinticons = blueprint_table.icons

]]--

local serpent = require "serpent0272"
local inflate = require "deflatelua"
local deflate = require "zlib-deflate"
local base64 = require "base64"

function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function item_count(t) 
	local count = 0
	if (#t >= 2) then return 2 end
	for k,v in pairs(t) do count = count + 1 end
	return count
end

function fix_entities(array)
	if (not array or type(array) ~= "table") then return {} end
	local entities = {}
	local count = 1
	for _, entity in ipairs(array) do
		if (type(entity) == 'table') then
			entity.entitynumber = count
			entities[count] = entity
			count = count + 1
		end
	end
	return entities
end

function fix_icons(array)
	if (not array or type(array) ~= "table") then return {} end
	if (#array > 1000) then return {} end
	local icons = {}
	local count = 1
	for _, icon in pairs(array) do
		if (count > 4) then break end
		if (type(icon) == 'string') then
			table.insert(icons, {index = count, name = icon})
			count = count + 1
		elseif (type(icon) == 'table' and icon.name) then
			table.insert(icons, {index = count, name = icon.name})
			count = count + 1
		end
	end
	return icons
end

function remove_useless_fields(entities)
	if (not entities or type(entities) ~= "table") then return end
	for _, entity in ipairs(entities) do
		if (type(entity) ~= "table") then entity = {} end

		-- Out of memory protection
		if (#entity > 1000) then entity = {} end
	
		-- Type is calculated from entity.name
		if (game.entityprototypes[entity.name] and game.entityprototypes[entity.name].type == entity.type) then
			entity.type = nil
		end

		-- Entitynumber is calculated in fix_entities()
		entity.entitynumber = nil

		-- 0 is the default direction
		if (entity.direction and entity.direction == 0) then
			entity.direction = nil
		end

		-- 0 is the default orientation
		if (entity.orientation and entity.orientation == 0) then
			entity.orientation = nil
		end

		-- "no-name > 1" is the default condition
		if (entity.conditions) then
			-- Out of memory protection
			if (#entity.conditions > 1000) then entity.conditions = {} end

			for key,value in pairs(entity.conditions) do
				if (not value.name and value.operator and value.operator == ">" and value.count and value.count == 1) then
					value.operator = nil
					value.count = nil
				end
			end
		end

		-- 1 is the default amount
		if (entity.requestfilters) then
			-- Out of memory protection
			if (#entity.requestfilters > 1000) then entity.requestfilters = {} end

			for key,value in pairs(entity.requestfilters) do
				if (value.amount and value.amount == 1) then
					value.amount = nil
				end
			end
		end

		-- Remove empty tables
		for key,value in pairs(entity) do
			if (type(value) == "table") then
				-- Out of memory protection
				if (#value > 1000) then value = {} end

				-- Remove sequential keys
				for i = #value, 1, -1 do
					if (type(value[i]) == "table") then
						if (item_count(value[i]) == 0) then
							table.remove(value, i)
						elseif (value[i].index and item_count(value[i]) == 1) then
							-- Index alone is useless
							table.remove(value, i)
						end
					end
				end
				-- Remove associative keys
				for key2,value2 in pairs(value) do
					if (type(value2) == "table") then
						if (item_count(value2) == 0) then
							value[key2] = nil
						elseif (value2.index and item_count(value2) == 1) then
							-- Index alone is useless
							value[key2] = nil
						end
					end
				end
				if (item_count(value) == 0) then
					entity[key] = nil
				end
			end
		end
		
		if (item_count(entity) == 0) then
			entity = nil
		end
	end
end


-- ====================================================
-- Public API

local M = {}

M.COMPRESS_STRINGS = true  -- Compress saved strings. Format is gzip + base64.
M.LINE_LENGTH = 120  -- Length of lines in compressed string. 0 means unlimited length.

M.toString = function(blueprint_table)
	remove_useless_fields(blueprint_table.entities)
	local str = serpent.dump(blueprint_table)
	if (M.COMPRESS_STRINGS) then
		str = deflate.gzip(str)
		str = base64.enc(str)
		if (M.LINE_LENGTH > 0) then
			str = str:gsub( ("%S"):rep(M.LINE_LENGTH), "%1\n" )
		end
	end
	str = str .. "\n"
	return str
end

M.fromString = function(data)
	data = trim(data)
	if (string.sub(data, 1, 8) ~= "do local") then
		-- Decompress string
		local output = {}
		local input = base64.dec(data)
		local status, result = pcall(inflate.gunzip, { input = input, output = function(byte) output[#output+1] = string.char(byte) end })
		if (status) then
			data = table.concat(output)
		else
			--game.player.print(result)
			return nil
		end
	end

	local status, result = serpent.load(data)
	if (not status) then
		--game.player.print(result)
		return nil
	end

	result.entities = fix_entities(result.entities)
	result.icons = fix_icons(result.icons)

	return result
end

return M