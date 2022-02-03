--Make a gradiant effect with 2 tools

dofile("Slicer.lua")

--Parameters
local InFileName = "Input.gcode"
local OutFileName = "Output.gcode"

local LayerSegment = 10
local StartLayer = 2

function main()
	local Line = ""
	local LayerCount = nil
	local Tool = 0
	local NumToolChanges = 0
	local OutFile = io.open(OutFileName, "w")
	local Slicer = Cura
	local LayerT0 = LayerSegment
	local LayerT1 = 0

	InFile = io.open(InFileName)

	for Line in io.lines(InFileName) do
		Info = Slicer:Parse(Line)
		
		OutFile:write(Line, "\n")

		if Info.LayerCount then
			LayerCount = Info.Number
		elseif Info.LayerChange and Info.Number >= StartLayer then
			if LayerCount == nil then
				print("ERROR: Never got LayerCount")
				break;
			end
		
			if LayerT0 > 0 then
				LayerT0 = LayerT0 - 1
				
				if Tool ~= 0 then
					Tool = 0
					NumToolChanges = NumToolChanges + 1
					OutFile:write("T0\n")
				end
			elseif LayerT1 > 0 then
				LayerT1 = LayerT1 - 1
				
				if Tool ~= 1 then
					Tool = 1
					NumToolChanges = NumToolChanges + 1
					OutFile:write("T1\n")
				end
			else
				local Ratio = (Info.Number+LayerSegment) / LayerCount
				LayerT1 = round(LayerSegment * Ratio)
				LayerT0 = LayerSegment - LayerT1
			end
		end
	end
	
	print("NumToolChanges="..NumToolChanges)
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

main()
