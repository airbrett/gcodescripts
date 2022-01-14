dofile("Slicer.lua")

--Slicer settings
local Slicer = Cura

--I/O settings
local InFileName = "C:/Dev/gcodescripts/RetractTower.gcode"
local OutFileName = "C:/Dev/gcodescripts/RetractTower_new.gcode"

--model settings
local ChangeLayerOffset = 4
local ChangeLayer = 38

--distance(mm)
local StartingDistance = 1.5
local DistanceIncr = 0
local ResetDistance = 1.5

--speed(mm/sec)
local StartingSpeed = 15
local SpeedIncr = 10
local ResetSpeed = 30

local LayerCount = 0
local Counter = ChangeLayerOffset
local RetractDistance = StartingDistance
local RetractSpeed = StartingSpeed
local OutFile = io.open(OutFileName, "w")

for Line in io.lines(InFileName) do
	local Code = Slicer:Parse(Line)
	OutFile:write(Line,"\n")
	
	if Code.LayerChange then
		LayerCount = LayerCount + 1
		Counter = Counter - 1
		
		if Counter == 0 then
			Counter = ChangeLayer
			local gcode = "M207 S"..RetractDistance.." F"..(RetractSpeed*60).."\n"
			OutFile:write(gcode)
			print(LayerCount.."= "..gcode)
			
			RetractDistance = RetractDistance + DistanceIncr
			RetractSpeed = RetractSpeed + SpeedIncr
		end
	end
end

OutFile:write("M207 S"..ResetDistance.." F"..ResetSpeed*60, "\n")