----------------lg_short--------------------------
lg_arc                      =love.graphics.arc
lg_clear                    =love.graphics.clear
lg_circle                   =love.graphics.circle
lg_draw                     =love.graphics.draw
lg_discard                  =love.graphics.discard
lg_ellipse                  =love.graphics.ellipse
lg_getWidth                 =love.graphics.getWidth
lg_getLineJoin              =love.graphics.getLineJoin
lg_getShader                =love.graphics.getShader
lg_getColorMask             =love.graphics.getColorMask
lg_getScissor               =love.graphics.getScissor
lg_getStencilTest           =love.graphics.getStencilTest
lg_getRendererInfo          =love.graphics.getRendererInfo
lg_getSystemLimits          =love.graphics.getSystemLimits
lg_getColor                 =love.graphics.getColor
lg_getFont                  =love.graphics.getFont
lg_getCompressedImageFormats=love.graphics.getCompressedImageFormats
lg_getLineStyle             =love.graphics.getLineStyle
lg_getPointSize             =love.graphics.getPointSize
lg_getDefaultFilter         =love.graphics.getDefaultFilter
lg_getCanvasFormats         =love.graphics.getCanvasFormats
lg_getSupported             =love.graphics.getSupported
lg_getLineWidth             =love.graphics.getLineWidth
lg_getBackgroundColor       =love.graphics.getBackgroundColor
lg_getBlendMode             =love.graphics.getBlendMode
lg_getDefaultMipmapFilter   =love.graphics.getDefaultMipmapFilter
lg_getCanvas                =love.graphics.getCanvas
lg_getStats                 =love.graphics.getStats
lg_getHeight                =love.graphics.getHeight
lg_getDimensions            =love.graphics.getDimensions
lg_intersectScissor         =love.graphics.intersectScissor
lg_isGammaCorrect           =love.graphics.isGammaCorrect
lg_isActive                 =love.graphics.isActive
lg_isCreated                =love.graphics.isCreated
lg_isWireframe              =love.graphics.isWireframe
lg_line                     =love.graphics.line
lg_newQuad                  =love.graphics.newQuad
lg_newVideo                 =love.graphics.newVideo
lg_newParticleSystem        =love.graphics.newParticleSystem
lg_newText                  =love.graphics.newText
lg_newScreenshot            =love.graphics.newScreenshot
lg_newMesh                  =love.graphics.newMesh
lg_newShader                =love.graphics.newShader
lg_newCanvas                =love.graphics.newCanvas
lg_newImageFont             =love.graphics.newImageFont
lg_newSpriteBatch           =love.graphics.newSpriteBatch
lg_newImage                 =love.graphics.newImage
lg_newFont                  =love.graphics.newFont
lg_origin                   =love.graphics.origin
lg_pop                      =love.graphics.pop
lg_present                  =love.graphics.present
lg_push                     =love.graphics.push
lg_points                   =love.graphics.points
lg_printf                   =love.graphics.printf
lg_print                    =love.graphics.print
lg_polygon                  =love.graphics.polygon
lg_rotate                   =love.graphics.rotate
lg_rectangle                =love.graphics.rectangle
lg_reset                    =love.graphics.reset
lg_setColor                 =love.graphics.setColor
lg_stencil                  =love.graphics.stencil
lg_setCanvas                =love.graphics.setCanvas
lg_setColorMask             =love.graphics.setColorMask
lg_setNewFont               =love.graphics.setNewFont
lg_setLineStyle             =love.graphics.setLineStyle
lg_setDefaultFilter         =love.graphics.setDefaultFilter
lg_shear                    =love.graphics.shear
lg_setFont                  =love.graphics.setFont
lg_setShader                =love.graphics.setShader
lg_setPointSize             =love.graphics.setPointSize
lg_setBlendMode             =love.graphics.setBlendMode
lg_setScissor               =love.graphics.setScissor
lg_setStencilTest           =love.graphics.setStencilTest
lg_setLineWidth             =love.graphics.setLineWidth
lg_scale                    =love.graphics.scale
lg_setDefaultMipmapFilter   =love.graphics.setDefaultMipmapFilter
lg_setBackgroundColor       =love.graphics.setBackgroundColor
lg_setWireframe             =love.graphics.setWireframe
lg_setLineJoin              =love.graphics.setLineJoin
lg_translate                =love.graphics.translate
----------------lg_short--------------------------
lg_w = lg_getWidth()
lg_h = lg_getHeight()
--------------------------------------------------
lms_getRelativeMode          =love.mouse.getRelativeMode
lms_getCursor                =love.mouse.getCursor
lms_getY                     =love.mouse.getY
lms_getPosition              =love.mouse.getPosition
lms_getSystemCursor          =love.mouse.getSystemCursor
lms_getX                     =love.mouse.getX
lms_hasCursor                =love.mouse.hasCursor
lms_isDown                   =love.mouse.isDown
lms_isGrabbed                =love.mouse.isGrabbed
lms_isVisible                =love.mouse.isVisible
lms_newCursor                =love.mouse.newCursor
lms_setPosition              =love.mouse.setPosition
lms_setX                     =love.mouse.setX
lms_setCursor                =love.mouse.setCursor
lms_setGrabbed               =love.mouse.setGrabbed
lms_setY                     =love.mouse.setY
lms_setVisible               =love.mouse.setVisible
lms_setRelativeMode          =love.mouse.setRelativeMode
----------------lg_short--------------------------
amd 	= 	require
Bird 	=	require "lib.lovebird"
Vector 	= 	require "lib.hump.vector"
Vecl    =   require "lib.hump.vector-light"
Timer 	= 	require "lib.hump.timer"
Gs 		= 	require "lib.hump.gamestate" 
--------------------------------------------------
require "lib.json"
DEBUG=1
require "lib.functions"
require "lib.debugs"
require "lib.spt"
require "lib.shape"
dumptb=dump
--------------------------------------------------
local function gen_lg_short()
    local tb = {}
    for k,v in pairs(love.graphics) do
    	if(string.sub(k,1,1)~='_') then
    		local str = string.format("lg_%-25s=%s",k,"love.graphics."..k)
    		table.insert(tb,str)
    	end	
    end
    table.sort(tb,function(a,b)
    	if(string.byte(a,4)<string.byte(b,4)) then
    		return true
    	end
    end)
    for k,v in ipairs(tb) do
    	print(v)
    end

    tb={}
    for k,v in pairs(love.mouse) do
        if(string.sub(k,1,1)~='_') then
            local str = string.format("lms_%-25s=%s",k,"love.mouse."..k)
            table.insert(tb,str)
        end
    end
    table.sort(tb,function(a,b)
        if(string.byte(a,5)<string.byte(b,5)) then
            return true
        end
    end)
    for k,v in ipairs(tb) do
        print(v)
    end
end	
--gen_lg_short()
--------------------------------------------------
--sc_menu = amd("sc.menu")
--sc_test = amd("sc.test")
sc_game = amd("sc.game")
--sc_xx   = amd("sc.xx.xx")

function love.load(arg)
	--Bird.update()
	Gs.registerEvents()
    Gs.switch(sc_game)
    --Gs.switch(sc_xx)
end

function love.update(dt)	
	Timer.update(dt)
	--Bird.update()	
end

-- local ft = lg_newFont("assets/zy.ttf",48)
-- local txt = lg_newText(ft,"LooK")
-- local pixelcode = [[

-- extern vec4 u_effectColor;
-- extern vec4 u_textColor;
-- vec4 effect( vec4 col, Image texture, vec2 texturePos, vec2 screenPos )
-- {
--     // get color of pixels:
--     vec4 sample = texture2D( texture, texturePos );
--     float fontAlpha = sample.a; 
--     float outlineAlpha = (sample.r+sample.g+sample.b)/3.0;
--     if (outlineAlpha > 0.0){ 
--         vec4 color = u_textColor * fontAlpha + u_effectColor * (1.0 - fontAlpha);
--         return vec4( color.rgb,max(fontAlpha,outlineAlpha)*color.a);
--     }
--     else {
--         discard;
--     }
-- }
-- ]]
-- local shader = love.graphics.newShader(pixelcode)
-- shader:send("u_textColor",{1.0,0.0,1.0,1.0})
-- shader:send("u_effectColor",{1.0,1.0,0.0,1.0})
-- local canvs = lg_newCanvas(txt:getDimensions())
-- print("canvs",canvs:getDimensions())

function love.draw(dt)
    
    -- lg_setCanvas(canvs)
    -- love.graphics.clear()
    -- lg_setColor(255,255,255,255)
    -- lg_draw(txt,0,0,0.0,1,1)
    -- lg_setCanvas()

    -- lg_setShader(shader)
    -- --lg_draw(txt,100,20)
    -- lg_draw(canvs,50,40)
    -- lg_setShader()
    -- lg_setColor(255,255,0,255)
    lg_print(" FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

function love.keypressed(key)

end

function love.keyreleased(key)

end


function love.mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button)

end

function love.mousemoved( x, y, dx, dy )

end

function love.wheelmoved( dx, dy )

end




