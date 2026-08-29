-- Translate RCLootCouncil to your language at:
-- http://wow.curseforge.com/addons/rclootcouncil/localization/

local L = LibStub("AceLocale-3.0"):NewLocale("RCLootCouncil", "deDE")
if not L then return end

--@localization(locale="deDE", format="lua_additive_table", same-key-is-true=true)@

-- Fallback for missing translations (German)
-- NOTE: The locale proxy returned by NewLocale() for a non-default locale is write-only
-- (reading from it throws an error), so these must be plain assignments, not "L[k] or ...".
-- CurseForge-synced translations above always take priority since that block runs first.
L["chat version String"] = "|cFF87CEFARCLootCouncil |cFFFFFFFFVersion|cFFFFA500 %s"
L["chat tVersion string"] = "|cFF87CEFARCLootCouncil |cFFFFFFFFVersion|cFFFFA500 %s |cFF1EFF00(Toc: %s)|r"
L["chat_restrictions_enabled"] = "Chat restrictions are enabled. Cannot use chat commands."

-- Season 2 - Loot Priority / FFA (manually added, not yet in the CurseForge localization table)
L["chat_commands_ffa"] = "Startet eine Free-For-All-Wurf-Session für einen Gegenstand, ohne Prioritätsbegrenzung, z.B. '/rc ffa [Gegenstandslink]'"
L["chat_commands_priority"] = "Setzt die Priorität eines Spielers manuell, z.B. '/rc priority Spielername 100'"
L["Usage: /rc ffa <item link>"] = "Benutzung: /rc ffa <Gegenstandslink>"
L["Only the Master Looter can reset the loot ID"] = "Nur der Beuteverteiler kann die Loot-ID zurücksetzen"
L["Only the Master Looter can start a Free-For-All roll"] = "Nur der Beuteverteiler kann einen Free-For-All-Roll starten"
L["Free-For-All roll announcement"] = "Free-For-All! Diese Beute ist frei, würfelt mit /roll darauf!"
L["Free-For-All roll announcement with item"] = "Free-For-All! %s ist frei, würfelt mit /roll darauf!"
L["Only the Master Looter can set player priority"] = "Nur der Beuteverteiler kann die Priorität eines Spielers setzen"
L["Usage: /rc priority <player> <value>"] = "Benutzung: /rc priority <Spieler> <Wert>"
L["Set priority for player to value"] = "Priorität von %s auf %d gesetzt"
