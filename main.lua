--[[
	Example use of the bezier module.
	Click and drag the rects to update the curve.
]]
local bezier = require "bezier"

--[[ Control Points ]]--
local P = {
	display.newRect(  0,  0, 50,50),
	display.newRect(150, 50, 25,25),
	display.newRect( 50,150, 25,25),
	display.newRect(300,300, 50,50),
}

local target = false

local function onTouch(self,event) 
	if event.phase == "began" then 
		target = self
	end
end

for i=1,4 do
	P[i].index = i
	P[i].touch = onTouch
	P[i]:addEventListener("touch", P[i])
end

local curve = bezier.new( P[1].x,P[1].y, P[2].x,P[2].y, P[3].x,P[3].y, P[4].x,P[4].y) --Represents a bezier curve, but is not a diplay object
local curveDisplayObject = curve:get() -- Creates a diplay object from the curves current state.

function updateCurve(event)
	if target then
		target.x = event.x -- Move control rect
		target.y = event.y
		
		curve.x[target.index] = event.x -- Change curve control point to reflect the change.
		curve.y[target.index] = event.y

		display.remove( curveDisplayObject ) -- Delete old curve
		curveDisplayObject = curve:get() -- Get new one

		curveDisplayObject:setColor(0,255,0) -- The display object is an ordinary line object, so you can set the color or whatever

		if event.phase == "ended" then
			target = false
		end
	end
end
Runtime:addEventListener("touch", updateCurve)