require "busted.runner" ()

local addon = dofile('.specs/AddonLoader.lua').LoadToc('RCLootCouncil.toc')
local module = addon:GetModule('RCVotingFrame')
dofile('.specs/EmulatePlayerLogin.lua')
addon.Print = function() end
module:OnInitialize()

print('initial')
for i, col in ipairs(module.scrollCols) do
  print(i, col.colName, 'sortnext=', col.sortnext, 'sortnextRef=', col.sortnextRef)
end

module:AddColumn({ id = 'a', colName = 'a', name = 'A', width = 40, sortnext = 'b' }, nil, nil)
module:AddColumn({ id = 'b', colName = 'b', name = 'B', width = 40, sortnext = 'c' }, nil, nil)
module:AddColumn({ id = 'c', colName = 'c', name = 'C', width = 40, sortnext = 'd' }, nil, nil)
module:AddColumn({ id = 'd', colName = 'd', name = 'D', width = 40, sortnext = 'e' }, nil, nil)
print('before-e')
for i, col in ipairs(module.scrollCols) do
  print(i, col.colName, 'sortnext=', col.sortnext, 'sortnextRef=', col.sortnextRef)
end
local ok, err = pcall(function()
  module:AddColumn({ id = 'e', colName = 'e', name = 'E', width = 40, sortnext = 'a' }, nil, nil)
end)
print('ok', ok)
if err then print('err', err) end
print('after-e')
for i, col in ipairs(module.scrollCols) do
  print(i, col.colName, 'sortnext=', col.sortnext, 'sortnextRef=', col.sortnextRef)
end
