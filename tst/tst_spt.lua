require "lib.spt"
local M={}
function M.load()
	-------------------------------------------------------
	local textpack,info = TexturePack("assets/aaa.json","assets/aaa.png")
	if(textpack) then
		packspt = textpack:getPackSpt("drink.png");
	end
	-------------------------------------------------------
	spt=Spt("assets/loading.png");
	--if mount aa
	-- spt=Spt("aa/pig.jpg");
	-------------------------------------------------------
	batchspt = BatchSpt("assets/aaa.json","assets/aaa.png")
	local bb=batchspt:add("icecream.png",300,200)
	local cc=batchspt:add("orange.png",300,300)
	for i=1,20 do
		batchspt:add("icecream.png",math.random(200,300),math.random(200,600))
	end
	M.spt=spt
	-------------------------------------------------------
	Timer.every(1.0,function()
		-- body
		Timer.tween(1.0,spt,{r=spt.r+0.3},"linear")
		--Timer.tween(1.0,spt,{sx=spt.sx+0.02},"linear")		
	end)
	-------------------------------------------------------ß
	local pixelcode = [[
        extern float u_ctime;
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
        {
        	texture_coords.x+=(sin(texture_coords.y *10.0+u_ctime *10.0)/30.0);
            return Texel(texture, texture_coords);
        }
    ]]
 
    local vertexcode = [[
        vec4 position( mat4 transform_projection, vec4 vertex_position )
        {
            return transform_projection * vertex_position;
        }
    ]] 
    shader = love.graphics.newShader(pixelcode, vertexcode) 
    uctime = 0
	-------------------------------------------------------
	local pixelcode = [[
        extern float u_ctime;
        extern float u_gtime;
		extern vec4 u_color;
        float easeOutCubic(float t,float b,float c,float d)
        {
			t/=d;
			t--;
			return c*(t*t*t+1.0)+b;
		}
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
        {
        	vec4 tex = Texel(texture, texture_coords);
        	float progress = easeOutCubic(u_ctime,-2.0,3.0,u_gtime);
			progress += texture_coords.y;
			float diff = texture_coords.x-progress;
			if(diff<=0.8 && diff>0.0){
				tex = tex + (u_color * diff) * tex.a * u_color.a;
			}
            return tex;
        }
    ]]
    shader2 = love.graphics.newShader(pixelcode) 
    u_gtime=0.5
    u_color={255,255,0,80}
    shader2:send("u_gtime",u_gtime)
    shader2:send("u_color",u_color)
	-------------------------------------------------------
	local pixelcode = [[
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
        {
        	vec4 tex = Texel(texture, texture_coords)*0.8;
        	vec4 tex2=Texel(texture, texture_coords-vec2(0.02,0.02))*0.5;
			tex= tex + tex2;
            return tex;
        }
    ]]
    shader3 = love.graphics.newShader(pixelcode) 
    u_gtime=1.0
    u_color={255,255,0,128}
	-------------------------------------------------------

end

function M.draw()
	--love.graphics.setShader(shader)
  	--shader:send("u_ctime",uctime);
	spt:draw(100,100)
  	--love.graphics.setShader();	

	--love.graphics.setShader(shader2)
  	--shader2:send("u_ctime",uctime);
	packspt:draw(200,100)
  	--love.graphics.setShader();

	--batchspt:draw()
  	
	
end

function M.update(dt)
	--spt:setRotate(spt.r+0.1)
	--packspt:setRotate(packspt.r+0.05)
	uctime = uctime + dt/5
end

function M.mousepressed(x, y, button, istouch)
	if(spt:contain(x,y)) then
		Timer.tween(.2,spt,{sx=1.5,sy=1.5},"cubic")
	end
end

function M.mousereleased(x, y, button)
   Timer.tween(.2,spt,{sx=1.0,sy=1.0},"cubic")
end

function M.mousemoved( x, y, dx, dy )
	
end

function M.wheelmoved( dx, dy )
    
end

return M
