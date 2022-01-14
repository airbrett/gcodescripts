--Convert a tool into a layer pattern of other tools

dofile("Slicer.lua")

--parameters
local InFileName = "CFFFP_paint_pyramid.gcode"
local OutFileName = "CFFFP_paint_pyramid_new.gcode"
local SillyTool = 2

--other stuff
local ToolSequence = {0, 1}
local ToolSequenceIndex = 0
local SeldTool = -1
local Slicer = {}
local OutFile = io.open(OutFileName, "w")

function main()
	Slicer = Cura

	for Line in io.lines(InFileName) do
		Info = Slicer:Parse(Line)

		if Info.LayerChange then
			OutFile:write(Line.."\n")

			if SeldTool == SillyTool then
				SillyToolChange()
			end
		elseif Info.ToolChange then
			SeldTool = Info.Number

			if SeldTool == SillyTool then
				SillyToolChange()
			else
				OutFile:write(Line.."\n")
			end
		else
			OutFile:write(Line.."\n")
		end
	end
end

function SillyToolChange()
	ToolSequenceIndex = ToolSequenceIndex + 1

	if ToolSequenceIndex > #ToolSequence then
		ToolSequenceIndex = 1
	end

	OutFile:write(Slicer:ToolChange(ToolSequence[ToolSequenceIndex]).."\n")
end

main()
