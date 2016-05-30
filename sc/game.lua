local M={}
local vangleTo = Vecl.angleTo
local vadd = Vecl.add
local vrotate = Vecl.rotate
local MAX_P = 8
local DISS_AUTO = true
local OUTLINE = true
local PLOYGON = false
local FILL = true
local LINE = false
function M:init(arg)
	self.alpha = 255
	self.r=0
	self.px=lg_w/2
	self.py=lg_h/2
	self.dy=-5
	-- Timer.tween(1.0,self,{px=lg_w-20},"linear")
	-- Timer.every(1,
	-- 				function()
	-- 					Timer.script(function(wait)
	-- 						Timer.tween(0.5, self, {dy = 15},"linear")
	-- 						wait(0.5)
	-- 						Timer.tween(0.5, self, {dy = -15},"linear")
	-- 					end)
	-- 				end)
	self.r=0
	self.pts={}
	self.dt=0
end
function M:enter()
	self.alpha=255
end

function M:update(dt)	
	self.dt=self.dt+dt	
	self.r = self.r+dt
	if(not DISS_AUTO) then
		return
	end
	if(not self.press) then
		if(self.dt>0.03) then
			self.dt=0
			if(#self.pts>0) then
				table.remove(self.pts,1)
			end
		end
	else
		if(self.dt>0.03) then
			self.dt=0
			if(#self.pts>2) then
				table.remove(self.pts,1)
			end
		end
	end
end

function M:gentb()
	--save ploygon
	--use for outline
	local tb={}
	--split to several small ploygon
	--use for fill
	local mtb={}
	--save tail point
	local tbt={}
	--save up point
	local tbu={}
	--save down point
	local tbd={}
	--save head point
	local tbh={}
	--local ws = {2,3,4,5,6,8}
	--local ws = {0,1, 0,1, 0,2, 0,2, 0,3, 0,3, 0,4,0,4, 0,5,0,5, 0,8,0,8}
	local ws={}
	if(MAX_P<=8) then
		ws = {2, 2, 4, 4, 6, 6, 8,8}
	else	
		for i=1,MAX_P/2 do
			table.insert(ws,i)
			table.insert(ws,i)
		end
	end
	--local pts= {10,100, 20,110, 50,130, 100,80, }
	-- local pts= {60,100, 80,100, 100,90, 140,60}
	local pts =self.pts
	local n = #pts
	local s = 1
	if(n<=1) then
		return
	end
	if(n>MAX_P) then
		s = n-MAX_P			
	end

	local px,py
	local x,y	
	local nx,ny
	local u,v
	local r
--[[	
	--near two point angle >90 witdh ==0
	if(n>2) then
		for i=s+1,n-1 do
			px=pts[i-1][1]
			py=pts[i-1][2]
			u=pts[i][1]
			v=pts[i][2]
			nx = pts[i+1][1]
			ny = pts[i+1][2]
			local r = vangleTo(u-px,v-py,nx-u,ny-v)
			if(r>math.pi/2 and r<math.pi*3/4) then
				ws[i]=0
				--print("r===",i+1, r)
			end
		end
	end
--]]
--------------------------------------------------
	--tail points
	local i=s
	px=pts[i][1]
	py=pts[i][2]
	u=pts[i+1][1]
	v=pts[i+1][2]
	r=vangleTo(u-px,v-py)
	x,y = vrotate(r,-8,0)
	table.insert(tbt,{px+x,py+y})

	--each two body point
	for i=s+1,n do
		px=pts[i-1][1]
		py=pts[i-1][2]
		u=pts[i][1]
		v=pts[i][2]
		r=vangleTo(u-px,v-py)
		if(ws[i-1]==0) then
			table.insert(tbu,{px,py})
			table.insert(tbd,{px,py})
		else	
			x,y = vrotate(r,0,-ws[i-1])
			table.insert(tbu,{px+x,py+y})
			x,y = vrotate(r,0,ws[i-1])
			table.insert(tbd,{px+x,py+y})
		end
	end

	--head up point
	i = n
	px=pts[i][1]
	py=pts[i][2]
	u=pts[i-1][1]
	v=pts[i-1][2]
	r=vangleTo(px-u,py-v)
	x,y = vrotate(r,0,-ws[i])
	table.insert(tbh,{px+x,py+y})

	--head point
	local www = n*2
	www =math.max(www,4)
	www =math.min(www,16)
	x,y = vrotate(r,www,0)
	table.insert(tbh,{px+x,py+y})
	--head down point
	x,y = vrotate(r,0,ws[i])
	table.insert(tbh,{px+x,py+y})
----------------------------------------------
	--line start
	for _,v in ipairs(tbt) do
		table.insert(tb,v[1])
		table.insert(tb,v[2])	
	end
	--line up
	for _,v in ipairs(tbu) do
		table.insert(tb,v[1])
		table.insert(tb,v[2])	
	end
	--line head
	for _,v in ipairs(tbh) do
		table.insert(tb,v[1])
		table.insert(tb,v[2])	
	end
	--line down
	for i=#tbd,1,-1 do
		table.insert(tb,tbd[i][1])
		table.insert(tb,tbd[i][2])
	end
	--line end close
	for _,v in ipairs(tbt) do
		table.insert(tb,v[1])
		table.insert(tb,v[2])	
	end
-----------------------------------------------
	--ploygon	
	local stb={}
	--tail ploygon
	table.insert(stb,tbt[1][1])
	table.insert(stb,tbt[1][2])
	table.insert(stb,tbu[1][1])
	table.insert(stb,tbu[1][2])
	table.insert(stb,tbd[1][1])
	table.insert(stb,tbd[1][2])
	table.insert(mtb,stb)
	
	--body ploygon
	for i=2,#tbu do
		stb={}
		table.insert(stb,tbu[i-1][1])
		table.insert(stb,tbu[i-1][2])		
		table.insert(stb,tbu[i][1])
		table.insert(stb,tbu[i][2])
	    if(tbd[i][1]~=tbu[i][1]  or tbd[i][2]~=tbu[i][2]) then
			table.insert(stb,tbd[i][1])
			table.insert(stb,tbd[i][2])
		end
		if(tbd[i-1][1]~=tbu[i-1][1] or tbd[i-1][2]~=tbu[i-1][2]) then
			table.insert(stb,tbd[i-1][1])
			table.insert(stb,tbd[i-1][2])
		end
		table.insert(mtb,stb)
	end
	
	stb={}
	i=#tbu	
	--head ploygon
	table.insert(stb,tbu[i][1])
	table.insert(stb,tbu[i][2])
	table.insert(stb,tbh[1][1])
	table.insert(stb,tbh[1][2])	
	table.insert(stb,tbh[3][1])
	table.insert(stb,tbh[3][2])
	table.insert(stb,tbd[i][1])
	table.insert(stb,tbd[i][2])	
	table.insert(mtb,stb)

	stb={}
	--head ploygon
	table.insert(stb,tbh[1][1])
	table.insert(stb,tbh[1][2])	
	table.insert(stb,tbh[2][1])
	table.insert(stb,tbh[2][2])
	table.insert(stb,tbh[3][1])
	table.insert(stb,tbh[3][2])
	
	table.insert(mtb,stb)

----------------------------------------------------
	return tb,mtb
end

local pixelcode = [[
extern float alpha;
extern float idx;
//extern Image img;
extern vec4 color;
vec4 effect(vec4 col, Image texture, vec2 texturePos, vec2 screenPos)
{
	int i = int(mod(idx,8));
    return color*vec4(1.0,1.0,1.0,1.0+alpha);
    //return Texel(img,texturePos+vec2(0.3,0.6));
}
]]

local colortb={
{0.0, 0.0, 1.0, 1.0},
{0.0, 1.0, 1.0, 1.0},
{0.0, 1.0, 0.0, 1.0},
{1.0, 1.0, 0.0, 1.0},
{1.0, 0.5, 0.0, 1.0},
{1.0, 0.0, 0.0, 1.0},
{1.0, 0.5, 1.0, 1.0},
}
local colorn=#colortb

local shader = love.graphics.newShader(pixelcode)
--shader:send("alpha",0.0)
--shader:send("idx",0)
--local spt=Spt("assets/pig.png");
--shader:send("img",spt.texture)

local IDX=0
function M:draw(dt)
	lg_setColor(255,0,255,255)
	lg_rectangle("fill",0,0,lg_w,lg_h)
	lg_setColor(255,255,255,255)
	lg_rectangle("fill",0,0,lg_w,lg_h,12,12)
	--spt:draw(lg_w/2,lg_h/2)
	lg_setLineStyle("smooth")
	lg_setLineJoin("none")
	lg_setLineWidth(2)
	local tb,mtb = self:gentb()
	
	if(tb) then
		lg_setShader(shader)
		for i,v in ipairs(mtb) do
			shader:send("alpha",i/10)
			shader:send("idx",IDX+i)
			local n=1+math.mod(IDX+i,colorn)
			shader:send("color",colortb[n])
			if(#v>=6) then
				if(FILL) then
					lg_setColor(0,255,250,255)
					lg_polygon("fill",unpack(v))
				end
				if(PLOYGON) then
					lg_setColor(0,255,0,255)
					lg_line(unpack(v))
				end
			else
				lg_line(unpack(v))
			end
		end
		lg_setShader()
		if(OUTLINE) then
			lg_setColor(255,0,0,255)
			lg_polygon("line",unpack(tb))
			lg_line(unpack(tb))
		end
		--lg_setColor(0,255,0,255)
		if(LINE) then
			local ptss={}
			for _,v in pairs(self.pts) do
				table.insert(ptss,v[1])
				table.insert(ptss,v[2])
			end
			lg_setColor(255,255,255,255)
			lg_line(unpack(ptss))
		end
	end
	lg_setColor(255,255,255,255)
end

function M:keypressed(key)
	
end

function M:keyreleased(key)
	-- local target = self
	-- Timer.script(function(wait)
	-- 		Timer.tween(0.5,target,{alpha=0},"linear")
	-- 		wait(0.5)
	-- 		target.alpha=255
	-- 		Gs.push(sc_test)
	-- 	end)	
end


function M:mousepressed(x, y, button, istouch)
	self.pts={}
	self.press = true
	self.px,self.py=0,0
end

function M:mousereleased(x, y, button)
	self.press = false
end

function M:mousemoved( x, y, dx, dy )
	if(self.dt>0.015 and self.press) then
		if(math.abs(x-self.px)>=2 or math.abs(y-self.py)>=2) then
			self.dt=0
			self.px,self.py = x,y
			table.insert(self.pts,{x,y})
			if(#self.pts>MAX_P) then
				table.remove(self.pts,1)
			end
		end		
		--print("numbs====",#self.pts)
		--dumptb(self.pts)
		IDX=IDX+1
	end
end

function M:wheelmoved( dx, dy )
end

return M



