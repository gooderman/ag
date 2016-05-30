local M={}

function M:init(arg)
	self.canvas = lg_newCanvas(200, 200, "rgba4", 4)
	self.alpha = 255
	print("M:init")
end
function M:enter()
	self.alpha=255
end

function M:update(dt)	
	
end

function M:draw(dt)

	lg_setCanvas(self.canvas)
	lg_setColor(128, 255, 0, 255)	
	lg_circle("fill", 100, 100,100)		
	lg_setCanvas()

	lg_setColor(128, 255, 0, self.alpha)	
	lg_draw(self.canvas,100,100)
	lg_setColor(255, 255, 255, 255)
    
end

function M:keypressed(key)
	
end

function M:keyreleased(key)
	local target = self
	Timer.script(function(wait)
			Timer.tween(0.5,target,{alpha=0},"linear")
			wait(0.5)
			target.alpha=255
			Gs.push(sc_test)
		end)	
end


function M:mousepressed(x, y, button, istouch)
end

function M:mousereleased(x, y, button)
end

function M:mousemoved( x, y, dx, dy )
end
function M:wheelmoved( dx, dy )
end

return M



