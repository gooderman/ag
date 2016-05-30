--[[
function love.load()
    image = love.graphics.newImage("assets/pig.png")
    local w,h = image:getDimensions()
    print("load pig.jpg",w,h)
	if(w>love.graphics.getWidth()) then
		w = love.graphics.getWidth()
	end
	if(h>love.graphics.getHeight()) then
		h = love.graphics.getHeight()
	end
	print("load pig.jpg",w,h)
    -- We want to make a Mesh with 1 vertex in the middle of the image, and 4 at the corners.
    local vertices = {
        {w, h, 1, 1,   255,   0,   0}, -- Center vertex, with a red tint.
        {0,   0,   0,   0,   0, 255, 0}, -- Top left.
        {w*0.5,   0,   1,   0,   0, 0, 255}, -- Top right.
        {w*0.5,   h,   1,   1,   255, 255, 255}, -- Bottom right.
        {0,   h,   0,   1,   255, 255, 255}, -- Bottom left.
    }
 
    -- But there's a problem! The drawn mesh will have a big triangle missing on its left side.
    -- This is because, in the default mesh draw mode ("fan"), the vertices don't "loop": the top left vertex (#2) is unconnected to the bottom left one (#5).    
	mesh = love.graphics.newMesh(vertices, "fan")
    mesh:setTexture(image)
 
    -- We could copy/paste the second vertex onto the end of the table of vertices.
    -- But instead we can just change the vertex map!
    mesh:setVertexMap(1, 2, 3, 4, 5, 2)
end
 
function love.draw()
    love.graphics.draw(mesh, 0, 0)
	love.graphics.draw(image, 0, 400)
end


function CreateCircle(segments)
	segments = segments or 40
	local vertices = {}
 
	-- The first vertex is at the origin (0, 0) and will be the center of the circle.
	table.insert(vertices, {0, 0})
 
	-- Create the vertices at the edge of the circle.
	for i=0, segments do
		local angle = (i / segments) * math.pi * 2
 
		-- Unit-circle.
		local x = math.cos(angle)
		local y = math.sin(angle)
 
		table.insert(vertices, {x, y})
	end
 
	-- The "fan" draw mode is perfect for our circle.
	return love.graphics.newMesh(vertices, "fan")
end
 
function love.load()
	mesh = CreateCircle()
end
 
function love.draw()
	local radius = 50
	local mx, my = love.mouse.getPosition()
	love.graphics.setColor(255,0,0,200)
	-- We created a unit-circle, so we can use the scale parameter for the radius directly.
	love.graphics.draw(mesh, mx, my, 0, radius, radius)
	love.graphics.setColor(255,255,0)
	-- We created a unit-circle, so we can use the scale parameter for the radius directly.
	love.graphics.draw(mesh, mx, my, 0, 20, 20)
end

--]]

function CreateTexturedCircle(image, segments)
	segments = segments or 40
	local vertices = {}
 
	-- The first vertex is at the center, and has a red tint. We're centering the circle around the origin (0, 0).
	table.insert(vertices, {0, 0, 0.5, 0.5, 255, 255, 255})
 
	-- Create the vertices at the edge of the circle.
	for i=0, segments do
		local angle = (i / segments) * math.pi * 2
 
		-- Unit-circle.
		local x = math.cos(angle)
		local y = math.sin(angle)
 
		-- Our position is in the range of [-1, 1] but we want the texture coordinate to be in the range of [0, 1].
		local u = (x + 1) * 0.5
		local v = (y + 1) * 0.5
 
		-- The per-vertex color defaults to white.
		table.insert(vertices, {x, y, u, v,255,255,255,255})
	end
 
	-- The "fan" draw mode is perfect for our circle.
	local mesh = love.graphics.newMesh(vertices, "fan")
        --mesh:setTexture(image)
 
        return mesh
end
 
function love.load()
  --love.window.setFullscreen(true)
	image = love.graphics.newImage("assets/loading.png")
	mesh = CreateTexturedCircle(nil)
	
	local pixelcode = [[
        extern float galpha;
        extern Image tt2;
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
        {
			float a = (0.5-texture_coords[0]);
			float b = (0.5-texture_coords[1]);
			float alpha=1-(a*a+b*b)/0.25;
			//if(alpha>0.99){alpha=1.0;}
			vec4 alcolor = vec4(1.0,1.0,1.0,alpha*galpha);
            vec4 texcolor = Texel(tt2, texture_coords);			
            return texcolor * color*alcolor;
        }
    ]]
 
    local vertexcode = [[
        vec4 position( mat4 transform_projection, vec4 vertex_position )
        {
            return transform_projection * vertex_position;
        }
    ]]
 
    shader = love.graphics.newShader(pixelcode, vertexcode) 
    rotate = 0;
    galpha = 0.0;
    shader:send("tt2",image);
end

function love.draw()  
	local radius = 100
	local mx, my = love.mouse.getPosition()
  mx, my=480/2,800/2
	love.graphics.setShader(shader)
  local _,a = math.modf(galpha)
  if(a>=0.5) then
    a=1-a
  end
  a=2*a;
  shader:send("galpha",a);
	-- We created a unit-circle, so we can use the scale parameter for the radius directly.
	-- for i=1,100 do
  --  love.graphics.draw(mesh, mx+i, my+i, rotate-i+100, radius-i+100, radius)
  -- end
  love.graphics.draw(mesh, mx, my, rotate, radius, radius)
  love.graphics.setColor(255,255,255)
  love.graphics.setShader()
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end
function love.update(dt)  
  rotate = rotate+dt;
  galpha = galpha+dt/20;
end