local sps={}
Bird=require("base.lovebird")
Vector = require "base.hump.vector"
Timer = require "base.hump.timer"
require "base.json"
DEBUG=1
require "base.functions"
require "base.debugs"
require "base.spt"
csv = require "base.csv"

function love.addsp()
	local sp={}
	sp.img = love.graphics.newImage('assets/pig.png')
	sp.r=math.pi/2
	sp.x=100
	sp.y=100
	sp.kx=1
	sp.ky=1
	sp.sx=0.5
	sp.sy=0.5
	sp.ox=sp.img:getWidth()/2
	sp.oy=sp.img:getHeight()/2
	table.insert(sps,sp)
	--[[
	vd=love.graphics.newVideo("assets/bg.mp3")
	if(vd) thenhttp://hump.readthedocs.org/en/latest/
		vd:play()
	end
	--]]
	av = Vector.new(100,100);
	cv = Vector.new(love.graphics.getWidth()/2,love.graphics.getHeight()/2);
	tv = cv+av;
end

function love.subsp()
	local ct = #sps
	if(ct>0) then
		sps[ct]=nil
	end	
end

function love.genmesh()	
	local gw=3
	local gh=3
	local gt=10
	local vertices = {} 
	-- Create the vertices at the edge of the circle.
	for i=1, gh do
		for j=1, gw do
			local x = (j-1)*gw*(gt+love.math.random(-25,25))
			local y = (i-1)*gh*(gt+love.math.random(-25,25))
			local u = (j - 1) /2
			local v = (i - 1) /2
			table.insert(vertices, {x, y, u, v,255,255,255,255})
		end
	end
 
	-- The "fan" draw mode is perfect for our circle.
	local mesh = love.graphics.newMesh(vertices, "strip")
	mesh:setVertexMap(  1,3,7, 
						7,3,9)
    mesh:setTexture(love.graphics.newImage('assets/hb.png')) 
    return mesh
end

function love.randmesh()
	local gw=3
	local gh=3
	local gt=10
	local vertices = {} 
	-- Create the vertices at the edge of the circle.
	for i=1, gh do
		for j=1, gw do
			local x = (j-1)*gw*gt+love.math.random(-5,15)
			local y = (i-1)*gh*gt+love.math.random(-5,15)
			local u = (j - 1) /2
			local v = (i - 1) /2
			table.insert(vertices, {x, y, u, v,255,255,255,255})
		end
	end 
	pigmesh:setVertices(vertices)
end

function love.load(arg)
	pigmesh = love.genmesh()
	love.addsp();
	isrun=true
	Bird.update()	
	--print("hasKeyRepeat",love.keyboard.hasKeyRepeat())
	love.keyboard.setKeyRepeat(true)

	textpack,info = TexturePack("assets/aaa.json","assets/aaa.png")
	dump(textpack,"TexturePack",2)
	if(textpack) then
		packspt = textpack:getPackSpt("drink.png");
		dump(packspt,"packspt",2)
	end
	spt=Spt("assets/aaa.png");
	batchspt = BatchSpt("assets/aaa.json","assets/aaa.png")
	local aa=batchspt:add("drink.png",100,100)
	local bb=batchspt:add("icecream.png",200,200)
	local cc=batchspt:add("orange.png",300,300)
	for i=1,30000 do
		batchspt:add("icecream.png",math.random(100,400),math.random(100,700))
	end
	dump(aa,"aa")
	Timer.tween.sqrt = function(t,scale) return math.sqrt(t) end
	Timer.script(
		function (wait)
			wait(1)
			Timer.tween(2, aa, {r = math.pi},"in-sqrt",function(iiii)end,1)
			wait(1)
			Timer.tween(1, bb, {sx = 2.0})
			wait(1)
			Timer.tween(1, cc, {sy = 0.5})  
	    	wait(1)
	    	Timer.tween(1, cc, {sy = 1.0})
	end)
end
local dtnumb=1
function love.update(dt)	
	Timer.update(dt)
	Bird.update()	
	av:rotateInplace(0.005)
	tv = cv+av
	--tv = tv:perpendicular()
	for _,sp in pairs(sps) do
		sp.r=sp.r+0.02
	end	
	dtnumb=dtnumb+1;
	if(math.mod(dtnumb,3)==1) then
		love.randmesh()
	end
end

function love.keypressed(key)

end

function love.keyreleased(key)

end

function love.draw(dt)
	love.graphics.setLineWidth(10)
	love.graphics.setColor(255,0,0,255)
	love.graphics.line(cv.x,0,cv.x,2*cv.y)
	love.graphics.line(0,cv.y,cv.y*2,cv.y)	
	love.graphics.setColor(0,255,0,255)
	love.graphics.line(cv.x,cv.y,tv.x,tv.y)

	love.graphics.line(0,2*cv.y,tv.x,tv.y)
	--love.graphics.setColor(255,255,0,255)
	--love.graphics.line(0,0,cv.x,cv.y)
	love.graphics.setColor(255,255,255,255)

	local str = string.format("deg = %.2f",math.deg((tv-cv):angleTo()));
	love.graphics.print(str,cv.x+20,2*cv.y-50)
	local vtb={cv.x,cv.y,tv.x,tv.y,0,cv.y*2}
	love.graphics.polygon("line", vtb)

	love.graphics.stencil(function()	
							love.graphics.push()
							love.graphics.setColor(255,0,0,255)
   							love.graphics.circle('fill',100,100,80)
   							love.graphics.setColor(255,255,255,255)
   							love.graphics.pop()
   						  end, "replace", 1)
	love.graphics.setStencilTest("greater", 0)    
    for _,sp in pairs(sps) do
		love.graphics.draw(sp.img, sp.x, sp.y,sp.r,sp.sx,sp.sy,sp.ox,sp.oy)
	end
    love.graphics.setStencilTest()

    --packspt:draw(300,300)
    --batchspt:draw()
    --for i=1,5000 do
    	love.graphics.draw(pigmesh,150,200)
	--end
    --spt:draw(200,200)

    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end