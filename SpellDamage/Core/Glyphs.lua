local Glyphs = {}
function Glyphs:create()
	local glyphs = {}
	glyphs.glyphs = {}
	self.__index = self
	return setmetatable(glyphs, self)
end

function Glyphs:update()
	self.glyphs = {}
	for i = 1, GetNumGlyphSockets() do
		local enabled, _, _, id = GetGlyphSocketInfo(i, GetActiveSpecGroup())
		if enabled == true and id then self.glyphs[id] = true end
	end
end

function Glyphs:contains(glyphId)
	return self.glyphs[glyphId]
end

SD.Glyphs = Glyphs:create()