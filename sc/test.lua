t_spt = amd "tst.tst_spt"
t_csv = amd "tst.tst_csv"
t_http = amd "tst.tst_http"
t_fs = amd "tst.tst_fs"
local M={}
function M:init(arg)
	--Bird.update()
	t_fs.load()
	t_spt.load()
	t_csv.load()
	t_http.load()
	self.alpha = 255
	print("M:init")
end
function M:enter()
	self.alpha=255
end

function M:update(dt)	
	--Timer.update(dt)
	--Bird.update()	
	t_spt.update(dt)
	t_csv.update(dt)
	t_http.update(dt)

end

function M:draw(dt)
	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()
	love.graphics.push()
	love.graphics.setColor(128, 0, 0, self.alpha)
	love.graphics.rectangle("fill", 0, 0,400,400)

	love.graphics.translate(200, 200)
	--love.graphics.rotate(math.pi/4)
	--love.graphics.shear(0.2,0.2)
	love.graphics.translate(-200,-200)


	love.graphics.setColor(255,0,0,self.alpha)
	love.graphics.line(0,0,0,h)
	love.graphics.line(0,h,w,h)	
	love.graphics.line(w,h,w,0)	
	love.graphics.line(w,0,0,0)
	love.graphics.setColor(255,255,255,self.alpha)
		
	t_spt.draw(dt)	

	love.graphics.setBlendMode("subtract")

	love.graphics.setColor(128, 0, 0, self.alpha)
	love.graphics.circle("fill", 200, 200,200)
	love.graphics.setColor(255,255,255,255)

	love.graphics.setBlendMode("alpha")

    love.graphics.pop()

end

function M:keypressed(key)

end

function M:keyreleased(key)
	local target = self
	Timer.script(function(wait)
			Timer.tween(0.5,target,{alpha=0},"linear")
			wait(0.5)
			target.alpha=255
			Gs.push(sc_menu)
		end)	
end


function M:mousepressed(x, y, button, istouch)
	t_spt.mousepressed(x, y, button, istouch)
end

function M:mousereleased(x, y, button)
   t_spt.mousereleased(x, y, button)
end

function M:mousemoved( x, y, dx, dy )
	t_spt.mousemoved(x,y,dx,dy)
end
function M:wheelmoved( dx, dy )
	t_spt.wheelmoved(dx,dy)
end

return M




