Cura = {
	LayerNum = -1,
	LayerChange = false
}

function Cura:Parse(Line)
	local Info = {}
	fbegin,fend = string.find(Line, ";LAYER:")
	
	if fbegin ~= nil then
		Info.LayerChange = true
		Info.Number = tonumber(string.sub(Line,fend+1))
		return Info
	end
	
	return Info
end
--[[ This is hella broken
Slic3r = {
	LayerNum = -1,
	LayerChange = false
}

function Slic3r:Parse(Line)
	fbegin,fend = string.find(Line, ";LAYER_CHANGE")
	
	if fbegin ~= nil then
		return self.LayerNum + 1
	end
	
	return nil
end
--]]