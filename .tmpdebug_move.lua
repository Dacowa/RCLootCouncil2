require 'busted.runner' ()
local addon = dofile('.specs/AddonLoader.lua').LoadToc('RCLootCouncil.toc')
local module = addon:GetModule('RCVotingFrame')
dofile('.specs/EmulatePlayerLogin.lua')
addon.Print = function() end
module:OnInitialize()
local rollIndex = module:GetColumnIndex('roll')
local responseIndex = module:GetColumnIndex('response')
print('initial', rollIndex, responseIndex)
module:MoveColumn('roll', 'response', 'before')
print('after first move')
for i,col in ipairs(module.scrollCols) do print(i, col.colName, 'sortnext=', col.sortnext, 'sortnextRef=', col.sortnextRef) end
print('idxs', module:GetColumnIndex('roll'), module:GetColumnIndex('response'))
module:MoveColumn(responseIndex, 30, 'after')
print('after second move')
for i,col in ipairs(module.scrollCols) do print(i, col.colName, 'sortnext=', col.sortnext, 'sortnextRef=', col.sortnextRef) end
print('final idxs', module:GetColumnIndex('roll'), module:GetColumnIndex('response'))
