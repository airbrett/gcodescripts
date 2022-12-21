--convert firmware retraction gcode into normal retraction split across 3 extruders

local RetractAmount = 5
local RetractSpeed = 60*60
local UnretractAmount = RetractAmount
local UnretractSpeed = RetractSpeed
local RetractionTool = 15


local OutFile = io.open(arg[2], "w")

local RetractTotal = RetractAmount * 3
local UnretractTotal = UnretractAmount * 3
local Tool = 0

function get_gcode(gcode)
	first, last, address, code = gcode:find('^(%a)(%d+)')
	return address, code
end

function get_parameter(gcode, param)
	first, last, val = gcode:find(param..'(%d+%.?%d*)')
	return val
end

for Line in io.lines(arg[1]) do
	addr, code = get_gcode(Line)
	
	if addr == 'G' then
		if code == '10' then
			--retract
			if Tool ~= RetractionTool then
				OutFile:write("T"..tostring(RetractionTool).."\n")
			end
			
			OutFile:write("G1 F"..RetractSpeed.." E-"..RetractTotal.."\n")
		elseif code == '11' then
			--unretract
			if Tool ~= RetractionTool then
				OutFile:write("T"..tostring(RetractionTool).."\n")
			end
			
			OutFile:write("G1 F"..UnretractSpeed.." E"..UnretractTotal.."\n")
			
			if Tool ~= RetractionTool then
				OutFile:write("T"..tostring(Tool).."\n")
			end
		else
			OutFile:write(Line,"\n")
		end
	elseif addr == 'T' then --tool change
		Tool = tonumber(code)
		OutFile:write(Line,"\n")
	else
		OutFile:write(Line,"\n")
	end
end