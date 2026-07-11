insulate("RCVotingFrame column registry", function()
	local addon = dofile(".specs/AddonLoader.lua").LoadToc("RCLootCouncil.toc")
	local module = addon:GetModule("RCVotingFrame")
	dofile(".specs/EmulatePlayerLogin.lua")

	before_each(function()
		module:OnInitialize()
	end)

	it("can insert a column before another column and resolve sortnext by name", function()
		module:AddColumn({ id = "custom", colName = "custom", name = "Custom", width = 40, sortnext = "response", },
			"response", "before")

		local customIndex = module:GetColumnIndex("custom")
		assert.are.equal(customIndex, module:GetColumnIndex("response") - 1)
		assert.are.equal(module:GetColumnIndex("response"), module:GetColumn("custom").sortnext)
	end)

	it("can move a column and keep sortnext pointing to the correct column", function()
		module:AddColumn({ id = "custom", colName = "custom", name = "Custom", width = 40, sortnext = "name", },
			"response", "before")
		module:MoveColumn("custom", "roll", "after")

		local customIndex = module:GetColumnIndex("custom")
		assert.are.equal(customIndex, module:GetColumnIndex("roll") + 1)
		assert.are.equal(module:GetColumnIndex("name"), module:GetColumn("custom").sortnext)
	end)

	it("can update an existing custom column in place", function()
		module:AddColumn({ id = "custom", colName = "custom", name = "Custom", width = 40, sortnext = "response", },
			"response", "before")
		module:UpdateColumn("custom", { name = "Updated", width = 80, sortnext = "name", })

		local column = module:GetColumn("custom")
		assert.are.equal("Updated", column.name)
		assert.are.equal(80, column.width)
		assert.are.equal(module:GetColumnIndex("name"), column.sortnext)
	end)

	it("throws on circular sortnext references and clears only the final link", function()
		module:AddColumn({ id = "a", colName = "a", name = "A", width = 40, sortnext = "b", })
		assert.has.errors(function()
			module:AddColumn({ id = "b", colName = "b", name = "B", width = 40, sortnext = "a", })
		end)

		assert.are.equal(15, module:GetColumn("a").sortnext)
		assert.is_nil(module:GetColumn("b").sortnext)
		assert.is_nil(module:GetColumn("b").sortnextRef)
	end)
end)
