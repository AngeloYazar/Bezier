local Bezier = {
	c = { x = {0,0,0}, y = {0,0,0}, },
	x = { 10, 50, 160, 200 },
	y = { 50, 100, 100, 50 },
	quality = 0.01,
}
Bezier.__index = Bezier

function Bezier:getU(u, t)
	local a,b,c,u0 = self.c[u][1],self.c[u][2],self.c[u][3],self[u][1]
	return a*(t*t*t) + b*(t*t) + c*t + u0
end

function Bezier:getX(t)
	return self:getU("x",t)
end

function Bezier:getY(t)
	return self:getU("y",t)
end

function Bezier:calcConstants()
	self.c.x[3] = 3 * ( self.x[2] - self.x[1] )
	self.c.x[2] = 3 * ( self.x[3] - self.x[2] ) - self.c.x[3]
	self.c.x[1] = self.x[4] - self.x[1] - self.c.x[3] - self.c.x[2]

	self.c.y[3] = 3 * ( self.y[2] - self.y[1] )
	self.c.y[2] = 3 * ( self.y[3] - self.y[2] ) - self.c.y[3]
	self.c.y[1] = self.y[4] - self.y[1] - self.c.y[3] - self.c.y[2]
end

function Bezier:get(existingLine)
	self:calcConstants()
	local curve = existingLine
	if curve == false or curve == nil or not curve.append then
		curve = display.newLine( self.x[1], self.y[1], self:getU("x",self.quality*2), self:getU("y",self.quality*2) )
	end
	for t = self.quality,1,self.quality do
		curve:append(self:getU("x",t), self:getU("y",t))
	end
		curve:append(self:getU("x",1), self:getU("y",1))
	return curve
end

function Bezier.newCurve(x1,y1,x2,y2,x3,y3,x4,y4)
	local curve = { x={x1,x2,x3,x4}, y={y1,y2,y3,y4}, c={x={0,0,0},y={0,0,0}} }
	setmetatable( curve, Bezier )
	return curve:get(), curve
end

function Bezier.new(x1,y1,x2,y2,x3,y3,x4,y4)
	local curve = { x={x1,x2,x3,x4}, y={y1,y2,y3,y4}, c={x={0,0,0},y={0,0,0}} }
	setmetatable( curve, Bezier )
	curve:calcConstants()
	return curve
end

return Bezier