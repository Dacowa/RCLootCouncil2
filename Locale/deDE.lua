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

-- Season 2 - Loot Priority / FFA (manually added, not yet in the CurseForge localization table)
L["chat_commands_ffa"] = L["chat_commands_ffa"] or "Kündigt der Gruppe einen Free-For-All-Roll an, z.B. '/rc ffa [Gegenstandslink]'"
L["chat_commands_priority"] = L["chat_commands_priority"] or "Setzt die Priorität eines Spielers manuell, z.B. '/rc priority Spielername 100'"
L["Only the Master Looter can reset the loot ID"] = L["Only the Master Looter can reset the loot ID"] or "Nur der Beuteverteiler kann die Loot-ID zurücksetzen"
L["Only the Master Looter can start a Free-For-All roll"] = L["Only the Master Looter can start a Free-For-All roll"] or "Nur der Beuteverteiler kann einen Free-For-All-Roll starten"
L["Free-For-All roll announcement"] = L["Free-For-All roll announcement"] or "Free-For-All! Diese Beute ist frei, würfelt mit /roll darauf!"
L["Free-For-All roll announcement with item"] = L["Free-For-All roll announcement with item"] or "Free-For-All! %s ist frei, würfelt mit /roll darauf!"
L["Only the Master Looter can set player priority"] = L["Only the Master Looter can set player priority"] or "Nur der Beuteverteiler kann die Priorität eines Spielers setzen"
L["Usage: /rc priority <player> <value>"] = L["Usage: /rc priority <player> <value>"] or "Benutzung: /rc priority <Spieler> <Wert>"
L["Set priority for player to value"] = L["Set priority for player to value"] or "Priorität von %s auf %d gesetzt"
