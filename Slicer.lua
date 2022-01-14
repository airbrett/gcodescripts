Cura = {
	LayerNum = -1,
	LayerChange = false
}

function Cura:Parse(GCode)
	local Info = {}
	fbegin,fend = string.find(GCode, ";LAYER:")
	
	if fbegin ~= nil then
		Info.LayerChange = true
		Info.Number = tonumber(string.sub(GCode,fend+1))
	elseif (GCode:sub(1,1) == "T") then
		Info.ToolChange = true
		Info.Number = tonumber(GCode:sub(2))
	end
	
	return Info
end

function Cura:ToolChange(Number)
	return "T"..Number
end

--[[ This is hella broken
Slic3r = {
	LayerNum = -1,
	LayerChange = false
}

function Slic3r:Parse(GCode)
	fbegin,fend = string.find(GCode, ";LAYER_CHANGE")
	
	if fbegin ~= nil then
		return self.LayerNum + 1
	end
	
	return nil
end
--]]