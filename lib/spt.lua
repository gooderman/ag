require "json"

local class = require 'lib.middleclass'
--[[
spt=Spt("assets/aaa.png");
spt:draw(300,300)
--]]
local spattr=
{
	x=0,
	y=0,
	ox=0,
	oy=0,
	sx=1,
	sy=1,
	r=0,
	w=0,
	h=0,
	box={},
}
-------------------------------------------------------
-------------------------------------------------------
Spt = class("Spt")
Spt:include(spattr)
function Spt:initialize(imgname)	
	if(imgname) then
		self.texture = love.graphics.newImage(imgname)
		self:setArch(0.5,0.5)
		self:setRotate(0)
		self:getSize()
	end
end
function Spt:getSize()
	if(self.texture) then
		self.w,self.h=self.texture:getDimensions()
	end
	return self.w,self.h
end
function Spt:setPos(x,y)
	if(x) then self.x=x end
	if(y) then self.y=y end
end
function Spt:setScale(sx,sy)
	if(sx) then self.sx=sx end
	if(sy) then self.sy=sy end
end
function Spt:setArch(arcx,arcy)
	local w,h = self:getSize()
	self.ox = w*arcx
	self.oy = h*arcy
end
function Spt:setRotate(r)
	self.r = r
end
function Spt:draw(x,y,r,sx,sy)
	self.x, self.y = x or self.x,y or self.y
	self.r = r or self.r
	self.sx, self.sy = sx or self.sx,sy or self.sy
	love.graphics.draw(self.texture,self.x, self.y, self.r,self.sx, self.sy, self.ox, self.oy)
end

function Spt:tween(eft,dt,p,e)
	Timer.tween(dt,self,{p=e},"linear")
end 

function Spt:genbox()
	self.box[1]=self.x-self.sx*self.ox
	self.box[2]=self.y-self.sy*self.oy
	self.box[3]=self.box[1]+self.w
	self.box[4]=self.box[2]+self.h
end

function Spt:contain(x,y)
	self:genbox()
	return x > self.box[1] and y > self.box[2] and x < self.box[3] and y < self.box[4]
end
-------------------------------------------------------
-------------------------------------------------------
--[[
textpack = TexturePack("assets/aaa.json","assets/aaa.png")
dump(textpack,"TexturePack",2)
if(textpack) then
	packimg = textpack:getPackSpt("drink.png");
end
packimg:draw(300,300)
--]]

PackSpt = class("PackSpt",Spt)
function PackSpt:initialize(item,texture)
	Spt.initialize()
	self.item=item
	self.texture=texture
	self.quad = love.graphics.newQuad(item.frame.x, item.frame.y, item.frame.w, item.frame.h,texture:getWidth(),texture:getHeight())	
	self.rotate_default = item.rotated and -math.pi/2 or 0;
	self:setArch(0.5,0.5)
end

function PackSpt:getSize()
	return self.item.sourceSize.w,self.item.sourceSize.h
end
function PackSpt:draw(x,y)
	self.x, self.y = x or self.x,y or self.y
	love.graphics.draw(self.texture, self.quad, self.x, self.y, self.r+self.rotate_default,self.sx, self.sy, self.ox, self.oy)
end
function PackSpt:getparamforbatch()
	return self.quad, self.x, self.y, self.r+self.rotate_default,self.sx, self.sy, self.ox, self.oy
end

-------------------------------------------------------
-------------------------------------------------------

TexturePack = class("TexturePack")
function TexturePack:initialize(jsonfile,imgfile)	
	local jstr, _ = love.filesystem.read(jsonfile)	
	if(jstr) then
		local texture = love.graphics.newImage(imgfile)
		if(not texture) then			
			return false,"no img"
		end
		local jtb = json.decode(jstr);
		if not jtb then
			return false,"json decode error"
		end		
		self.array=jtb
		self.texture=texture
		return true
	end	
	return false
end
function TexturePack:getPackSpt(name)
	local item
	for _,v in pairs(self.array.frames) do
		if(v.filename==name) then
			item = v
			break
		end
	end	
	if(item) then
		return PackSpt(item,self.texture);
	end
end
-------------------------------------------------------
-------------------------------------------------------
--[[
btSp = BatchSpt("assets/aaa.json","assets/aaa.png")
local aa=btSp:add("drink.png",100,100)
local bb=btSp:add("icecream.png",200,200)
local cc=btSp:add("orange.png",300,300)
btSp:draw()
--]]
BatchSpt = class("BatchSpt")
function BatchSpt:initialize(jsonfile,imgfile)	
	self.texturepack = TexturePack(jsonfile,imgfile)	
	if(self.texturepack) then
		self.batchsp = love.graphics.newSpriteBatch(self.texturepack.texture)
		self.imgs={}
		return true
	else
		return false,"texturepack error"	
	end
end
function BatchSpt:add(name,x,y)
	local packspt = self.texturepack:getPackSpt(name)
	if(packspt) then
		packspt.x,packspt.y=x or 0,y or 0
		table.insert(self.imgs,packspt)
		return packspt
	end
end
function BatchSpt:draw()
	for _,packspt in pairs(self.imgs) do
		self.batchsp:add(packspt:getparamforbatch())
	end
	love.graphics.draw(self.batchsp)
	self.batchsp:clear()
end
