--- Certain functions that are not interchangable between WoW versions are reimplemented here.

--- @class RCLootCouncil
local addon = select(2, ...)

addon.C_Container = C_Container or {
    GetContainerNumSlots = GetContainerNumSlots,
    GetContainerItemLink = GetContainerItemLink,
    GetContainerNumFreeSlots = GetContainerNumFreeSlots,
    GetContainerItemInfo = GetContainerItemInfo,
    PickupContainerItem = PickupContainerItem,
}

addon.C_Item = C_Item or {}
if not addon.C_Item.GetItemStats then
	addon.C_Item.GetItemStats = GetItemStats
end

local function SendChatMessageCompat(text, chattype, language, destination)
	if C_ChatInfo and C_ChatInfo.SendChatMessage then
		local ok, err = pcall(C_ChatInfo.SendChatMessage, {
			text = text,
			channel = chattype,
			language = language,
			target = destination,
		})
		if ok then
			return
		end

		-- Some WoW builds still expect the legacy signature: text, chattype, language, destination
		local okLegacy, errLegacy = pcall(C_ChatInfo.SendChatMessage, text, chattype, language, destination)
		if okLegacy then
			return
		end

		-- Fall back to the global API as a last resort.
		if SendChatMessage then
			return SendChatMessage(text, chattype, language, destination)
		end

		error(errLegacy or err or "C_ChatInfo.SendChatMessage failed")
	end

	if SendChatMessage then
		return SendChatMessage(text, chattype, language, destination)
	end
end

addon.SendChatMessage = SendChatMessageCompat

local EnumLootMethod = Enum.LootMethod or {
	Freeforall = 0,
	Roundrobin = 1,
	Masterlooter = 2,
	Group = 3,
	Needbeforegreed = 4,
	Personal = 5,
}

addon.GetLootMethod = C_PartyInfo and C_PartyInfo.GetLootMethod or 
--- Shim between retail and classic and always return the Enum.
--- @return Enum.LootMethod method, integer? partyID, integer? raidId 
function()
	local method, partyID, raidId = GetLootMethod()
	if not method then
		method = EnumLootMethod.Personal
	elseif method == "freeforall" then
		method = EnumLootMethod.Freeforall
	elseif method == "roundrobin" then
		method = EnumLootMethod.Roundrobin
	elseif method == "master" then
		method = EnumLootMethod.Masterlooter
	elseif method == "group" then
		method = EnumLootMethod.Group
	elseif method == "needbeforegreed" then
		method = EnumLootMethod.Needbeforegreed
	elseif method == "personalloot" then
		method = EnumLootMethod.Personal
	end
	return method, partyID, raidId
end