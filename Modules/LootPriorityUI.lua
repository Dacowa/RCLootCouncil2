--- LootPriorityUI.lua Module for handling Loot Priority UI and Auto-pass functionality
-- @author Potdisc (Extended with Season 2 Priority System)
-- Handles Reset button, Auto-reset on Wednesdays, and Auto-pass logic

--- @type RCLootCouncil
local addon = select(2, ...)
--- @class LootPriorityUI : AceModule, AceEvent-3.0, AceTimer-3.0
local LootPriorityUI = addon:NewModule("LootPriorityUI", "AceEvent-3.0", "AceTimer-3.0")
--- @type RCLootCouncilLocale
local L = LibStub("AceLocale-3.0"):GetLocale("RCLootCouncil")
local LootPriority = addon.Require "Data.LootPriority"

local db
local resetTimerID = nil
local autoResetCheckTimer = nil

function LootPriorityUI:OnInitialize()
    addon.Log("LootPriorityUI", "Initializing")
    self.Log = addon.Require "Utils.Log":New("LootPriorityUI")
end

function LootPriorityUI:OnEnable()
    self.Log:D("Enabling LootPriorityUI")
    db = addon:Getdb()

    self:RegisterMessage("RCLootPriorityIDReset", "OnIDReset")
    self:RegisterMessage("RCLootPriorityUpdated", "OnPriorityUpdated")

    -- Register loot frame events for auto-pass
    self:RegisterEvent("LOOT_OPENED", "OnLootOpened")
    self:RegisterEvent("LOOT_SLOT_CLEARED", "OnLootSlotCleared")

    -- Setup auto-reset timer check (every 30 seconds)
    self:ScheduleRepeatingTimer("CheckForWeeklyReset", 30)

    addon:ModuleChatCmd(self, "OnFFACommand", "ffa [item link]", L["chat_commands_ffa"], "ffa")
    addon:ModuleChatCmd(self, "OnSetPriorityCommand", "priority <player> <value>", L["chat_commands_priority"], "priority")

    addon.Log("LootPriorityUI", "enabled")
end

function LootPriorityUI:OnDisable()
    self:UnregisterAllMessages()
    self:UnregisterAllEvents()
    if resetTimerID then
        self:CancelTimer(resetTimerID)
        resetTimerID = nil
    end
    if autoResetCheckTimer then
        self:CancelTimer(autoResetCheckTimer)
        autoResetCheckTimer = nil
    end
end

--- Create the reset button and add it to the voting frame
function LootPriorityUI:CreateResetButton()
    if not addon.isMasterLooter then return end
    
    -- This will be integrated into the voting frame header
    -- Create a simple button that can be added to the UI
    local frame = CreateFrame("Button", "RCLootPriority_ResetButton", UIParent, "GameMenuButtonTemplate")
    frame:SetSize(120, 30)
    frame:SetText("Reset Loot ID")
    frame:SetPoint("CENTER", UIParent, "CENTER")
    
    frame:SetScript("OnClick", function()
        self:OnResetButtonClick()
    end)
    
    return frame
end

--- Handle reset button click
function LootPriorityUI:OnResetButtonClick()
    if not addon.isMasterLooter then
        addon:Print(L["Only the Master Looter can reset the loot ID"])
        return
    end

    local LibDialog = LibStub("LibDialog-1.1")
    if LibDialog and LibDialog.ActiveDialog and LibDialog:ActiveDialog("RC_LOOT_PRIORITY_RESET_CONFIRM") then
        LibDialog:Dismiss("RC_LOOT_PRIORITY_RESET_CONFIRM")
    end

    LibDialog:Spawn("RC_LOOT_PRIORITY_RESET_CONFIRM", {
        onAccept = function()
            self:PerformReset()
        end
    })
end

--- Perform the actual reset
function LootPriorityUI:PerformReset()
    LootPriority:StartNewID()
    LootPriority:ResetPlayerStats()
    addon:Print("Loot Priority: New raid ID started. All players reset to 100")

    -- Announce to group if in raid
    if IsInRaid() then
        addon.SendChatMessage("Loot Priority Reset! All players start with priority 100", "RAID")
    end
end

--- Check if it's Wednesday and time to reset
function LootPriorityUI:CheckForWeeklyReset()
    db = addon:Getdb()
    if not addon.isMasterLooter then return end
    if not db.season2Enabled or not db.season2AutoResetEnabled then return end

    -- GetServerTimeLocal() returns a unix timestamp, not a table, so it must be converted with date("*t", ...)
    local serverTimeLocal = C_DateAndTime.GetServerTimeLocal()
    local dateTable = date("*t", serverTimeLocal)

    -- Check if today is Wednesday (wday: Sunday = 1 ... Saturday = 7)
    local weekday = dateTable.wday
    local hour = dateTable.hour

    if weekday == 4 and hour == 19 and not self.hasResetThisWeek then
        self:PerformReset()
        self.hasResetThisWeek = true
    elseif weekday ~= 4 then
        self.hasResetThisWeek = false
    end
end

--- Handle loot opened - apply auto-pass
function LootPriorityUI:OnLootOpened()
    db = addon:Getdb()
    if addon.isMasterLooter then return end
    if not db.season2Enabled or not db.season2AutoPass then return end

    -- Schedule auto-pass after a short delay to let the loot window fully open
    self:ScheduleTimer("ApplyAutoPass", 0.5)
end

--- Apply auto-pass to all loot slots
function LootPriorityUI:ApplyAutoPass()
    if addon.isMasterLooter then return end
    if not db or not db.season2Enabled or not db.season2AutoPass then return end

    for slot = 0, GetNumLootItems() - 1 do
        local link = GetLootSlotLink(slot)
        if link and not (GetLootSlotType(slot) == -1) then
            LootSlot(slot)
        end
    end
end

--- Handle when loot slot is cleared
function LootPriorityUI:OnLootSlotCleared(event, slot)
    -- Could be used for additional logic if needed
end

--- Handle ID reset message
function LootPriorityUI:OnIDReset(message, newID, oldID)
    self.Log:I("Raid ID has been reset. New ID:", newID)
    
    -- Update voting frame if visible
    if addon.VotingFrame and addon.VotingFrame:IsShown() then
        addon:SendMessage("RCLootPriorityVisualUpdate")
    end
end

--- Handle priority updated message
function LootPriorityUI:OnPriorityUpdated(message, playerName, itemsWon)
    self.Log:D("Priority updated for", playerName, "Items won:", itemsWon)
    
    -- Update voting frame if visible
    if addon.VotingFrame and addon.VotingFrame:IsShown() then
        addon:SendMessage("RCLootPriorityVisualUpdate")
    end
end

--- Announce a Free-For-All roll to the group. Fully separate from the priority system.
-- Usage: /rc ffa [item link]
function LootPriorityUI:OnFFACommand(itemLink)
    if not addon.isMasterLooter then
        addon:Print(L["Only the Master Looter can start a Free-For-All roll"])
        return
    end

    local msg = (itemLink and itemLink ~= "")
        and format(L["Free-For-All roll announcement with item"], itemLink)
        or L["Free-For-All roll announcement"]

    addon:Print(msg)
    addon:SendAnnouncement(msg, IsInRaid() and "RAID" or "PARTY")
end

--- Manually correct a player's priority, e.g. when the weekly auto-reset failed or a roll wasn't tracked.
-- Usage: /rc priority <player> <value>
function LootPriorityUI:OnSetPriorityCommand(playerName, value)
    if not addon.isMasterLooter then
        addon:Print(L["Only the Master Looter can set player priority"])
        return
    end

    local rollValue = tonumber(value)
    if not playerName or playerName == "" or not rollValue then
        addon:Print(L["Usage: /rc priority <player> <value>"])
        return
    end

    LootPriority:SetPriorityRoll(playerName, rollValue)
    addon:Print(format(L["Set priority for player to value"], playerName, LootPriority:GetPriorityRoll(playerName)))

    if addon.VotingFrame and addon.VotingFrame:IsShown() then
        addon:SendMessage("RCLootPriorityVisualUpdate")
    end
end

return LootPriorityUI
