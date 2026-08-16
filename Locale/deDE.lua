-- Translate RCLootCouncil to your language at:
-- http://wow.curseforge.com/addons/rclootcouncil/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("RCLootCouncil", "deDE")
if not L then return end

--@localization(locale="deDE", format="lua_additive_table", same-key-is-true=true)@

-- Fallback for missing translations (German)
-- If these are translated by the localization system above, these will be overwritten
L["chat version String"] = L["chat version String"] or "|cFF87CEFARCLootCouncil |cFFFFFFFFVersion|cFFFFA500 %s"
L["chat tVersion string"] = L["chat tVersion string"] or "|cFF87CEFARCLootCouncil |cFFFFFFFFVersion|cFFFFA500 %s |cFF1EFF00(Toc: %s)|r"
L["chat_restrictions_enabled"] = L["chat_restrictions_enabled"] or "Chat restrictions are enabled. Cannot use chat commands."
