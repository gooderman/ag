debug = true
local sps={}
local vd=nil
local music=nil
local isrun=true
local ldt=0
local cdt=0
local ddt=1/20
function love.addsp()
	local sp={}
	sp.img = love.graphics.newImage('assets/loading.png')
	sp.r=0
	sp.x=0
	sp.y=0
	sp.kx=1
	sp.ky=1
	table.insert(sps,sp)
	--[[
	vd=love.graphics.newVideo("assets/bg.mp3")
	-- if(vd) then
		vd:play()
	end
	--]]
end

function love.subsp()
	local ct = #sps
	if(ct>0) then
		sps[ct]=nil
	end	
end

function love.load(arg)
	love.addsp();
	isrun=true
	print("hasKeyRepeat",love.keyboard.hasKeyRepeat())
	love.keyboard.setKeyRepeat(true)	
end

function love.update(dt)
	cdt=cdt+dt
	if(cdt-ldt>ddt) then
		ldt = cdt
		if(isrun==true) then
			for _,sp in pairs(sps) do
				sp.r = sp.r+0.1
				--sp.kx = math.abs(math.cos(sp.r))
				--sp.ky = math.abs(math.cos(sp.r))
				sp.x = math.random(0,love.graphics.getWidth())
				sp.y = math.random(0,love.graphics.getHeight())
			end
		end
	end
end

function love.keypressed(key)
   --print("--keypressed--"..key)
   if key == "space" then
      isrun=false
   elseif key=='kp+' then
	  love.addsp();
   elseif key=='kp-' then
	  love.subsp();   
   end
end     

function love.keyreleased(key)
   --print("--keyreleased--"..key)
   if key == "space" then
      isrun=true
   end
end

function love.draw(dt)
	for _,sp in pairs(sps) do
		love.graphics.draw(sp.img, sp.x, sp.y,sp.r,1,1,38,38)
	end	
	--[[
	if(vd) then
		love.graphics.draw(vd, 0, 0)
	end
	--]]
end