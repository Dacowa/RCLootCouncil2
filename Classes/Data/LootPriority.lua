--- LootPriority.lua Class for tracking loot priority based on items won per ID.
-- @author Potdisc (Extended with Season 2 Priority System)
-- Tracks items won per player per raid ID for fair loot distribution

--- @type RCLootCouncil
local addon = select(2, ...)
--- @class Data.LootPriority
local LootPriority = addon.Init "Data.LootPriority"
local Log = addon.Require "Utils.Log":New "Data.LootPriority"

local private = {
    --- @class LootPriorityData
    --- @field currentID string Current raid ID
    --- @field playerStats table<string, number> Items won per player
    --- @field trackingActive boolean Is tracking enabled
    currentID = nil,
    playerStats = {},
    trackingActive = true,
}

--- Gets the database path for loot priority
--- @return table The loot priority database
local function GetLootPriorityDB()
    if not addon.db.global.lootPriority then
        addon.db.global.lootPriority = {
            currentID = nil,
            playerStats = {},
        }
    end
    return addon.db.global.lootPriority
end

--- Initialize or get the current raid ID
--- @return string The current raid ID
function LootPriority:GetCurrentID()
    local db = GetLootPriorityDB()
    if not db.currentID then
        db.currentID = self:GenerateID()
    end
    return db.currentID
end

--- Generate a new raid ID based on timestamp
--- @return string New raid ID
function LootPriority:GenerateID()
    return GetServerTime() .. "-" .. math.random(1000, 9999)
end

--- Start tracking for a new raid ID
--- Resets all player stats but keeps history
function LootPriority:StartNewID()
    local db = GetLootPriorityDB()
    local oldID = db.currentID

    db.currentID = self:GenerateID()
    db.playerStats = {}

    Log:I("New raid ID started:", db.currentID, "(Previous:", oldID .. ")")
    addon:SendMessage("RCLootPriorityIDReset", db.currentID, oldID)

    return db.currentID
end

--- Forcefully clear all tracked priority values for the current raid ID.
function LootPriority:ResetPlayerStats()
    local db = GetLootPriorityDB()
    db.playerStats = {}
    addon:SendMessage("RCLootPriorityUpdated", nil, 0)
end

--- Record a loot award for a player
--- @param playerName string The player who won the loot
--- @param itemLink string The item link (for reference)
function LootPriority:RecordLootWin(playerName, itemLink)
    if not private.trackingActive then return end
    
    local db = GetLootPriorityDB()
    if not db.playerStats then db.playerStats = {} end
    
    if not db.playerStats[playerName] then
        db.playerStats[playerName] = 0
    end
    
    db.playerStats[playerName] = db.playerStats[playerName] + 1
    
    Log:D("Recorded loot win:", playerName, "Total:", db.playerStats[playerName], "Item:", itemLink)
    addon:SendMessage("RCLootPriorityUpdated", playerName, db.playerStats[playerName])
end

--- Get the current priority roll number for a player
--- Priority: /rnd 100 for 0 items, /rnd 99 for 1 item, /rnd 98 for 2 items, etc.
--- @param playerName string The player to check
--- @return number The roll number (100, 99, 98, etc.)
function LootPriority:GetPriorityRoll(playerName)
    local db = GetLootPriorityDB()
    local itemsWon = db.playerStats[playerName] or 0
    
    local roll = 100 - itemsWon
    
    -- Minimum roll is 1
    if roll < 1 then
        roll = 1
    end
    
    return roll
end

--- Get items won count for a player
--- @param playerName string The player to check
--- @return number Count of items won
function LootPriority:GetItemsWon(playerName)
    local db = GetLootPriorityDB()
    return db.playerStats[playerName] or 0
end

--- Get all current player stats for this ID
--- @return table Player stats for current ID
function LootPriority:GetAllPlayerStats()
    local db = GetLootPriorityDB()
    return db.playerStats or {}
end

--- Reset tracking (completely wipe current ID and stats)
function LootPriority:ResetTracking()
    local db = GetLootPriorityDB()
    Log:I("Full reset of loot priority tracking")
    db.currentID = nil
    db.playerStats = {}
    addon:SendMessage("RCLootPriorityTrackerReset")
end

--- Enable or disable tracking
--- @param enabled boolean
function LootPriority:SetTrackingActive(enabled)
    private.trackingActive = enabled
    Log:I("Tracking active:", enabled)
end

--- Check if tracking is active
--- @return boolean
function LootPriority:IsTrackingActive()
    return private.trackingActive
end

--- Get the currently active priority value for display.
--- This is the only value players should see in the UI; the underlying roll window is
--- calculated as 100 - itemsWon, and it is reduced only after the award is finalized.
--- @param playerName string
--- @return string Display value, e.g. "100", "99", "98"
function LootPriority:GetPriorityString(playerName)
    local rollNumber = self:GetPriorityRoll(playerName)
    return tostring(rollNumber)
end

return LootPriority
