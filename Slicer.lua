Generic = {}

function Generic:ExtractNumber(GCode, Arg)
	local Raw = GCode:match(Arg.."(-?%d*%.?%d+)")
	
	if Raw then
		local Data = {}
		Data.Number = tonumber(Raw)
		Data.Raw = Raw
		
		return Data
	end
	
	return nil
end

function Generic:Parse(GCode)
	local Info = {}
	
	local G = GCode:match("^G%d+")
	
	if G ~= nil then
		if G == "G0" or G == "G1" then
			Info.X = Generic:ExtractNumber(GCode, "X")
			Info.Y = Generic:ExtractNumber(GCode, "Y")
			Info.Z = Generic:ExtractNumber(GCode, "Z")
			Info.E = Generic:ExtractNumber(GCode, "E")
			Info.F = Generic:ExtractNumber(GCode, "F")
			
			if Info.E then
				Info.Move = true
			else
				Info.Travel = true
			end
			
			return Info
		elseif G == "G92" then
			Info.SetPosition = true
			Info.X = Generic:ExtractNumber(GCode, "X")
			Info.Y = Generic:ExtractNumber(GCode, "Y")
			Info.Z = Generic:ExtractNumber(GCode, "Z")
			Info.E = Generic:ExtractNumber(GCode, "E")
			
			return Info
		end
	end
	
	local M = GCode:match("^M%d+")
	
	if M ~= nil then
		if M == "M82" then
			Info.ExtruderAbsolute = true
			return Info
		elseif M == "M83" then
			Info.ExtruderRelative = true
			return Info
		end
	end
	
	local T = GCode:match("^T(%d+)")
	
	if T ~= nil then
		Info.ToolChange = true
		Info.Number = tonumber(T)
		return Info
	end
	
	return Info
end

function Generic:Create(Command)
	local GCode = nil
	if Command.ToolChange then
		GCode = "T"..tostring(Command.Number)
	elseif Command.ExtruderRelative then
		GCode = "M83"
	elseif Command.Retract then
		GCode = "G10"
	elseif Command.Unretract then
		GCode = "G11"
	elseif Command.FirmwareRetract then
		GCode = "M207 S"..Command.Distance.." F"..string.format("%.0f", Command.Speed)
	end
	
	return GCode
end

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
		return Info
	end
	
	fbegin,fend = string.find(GCode, ";LAYER_COUNT:")
	
	if fbegin ~= nil then
		Info.LayerCount = true
		Info.Number = tonumber(string.sub(GCode,fend+1))
		return Info
	end
	
	return Generic:Parse(GCode)
end

function Cura:Create(Command)
	return Generic:Create(Command)
end
--[[
function Cura:ToolChange(Number)
	return "T"..Number
end
--]]

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