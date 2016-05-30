
drawspt = Spt.draw
require "sc.xx.mx"
spt={}
winw=lg_getWidth()
winh=lg_getHeight()
spw=0
sph=0
sps=cfg_scale
notouch=false
local M={}
function M:init(arg)	
	for i=1,#elem do
		local a = Spt("assets/item_"..i..".png");
		a:setPos(math.random(10,200),math.random(10,200))
		a:setScale(sps,sps)
		spt[i]=a
	end
	spw,sph=spt[1]:getSize()
	spw=spw*cfg_scale
	sph=sph*cfg_scale
	print(spw,sph)
	initpos()
end
function M:enter()
	self.alpha=255
end
function initpos()
	for j=gh,1,-1 do
		mxpos[j]={}
		for i=1,gw do
			local x = (i-1)*spw+spw/2
			local y = (winh-sph)-(j-1)*sph+sph/2
			mxpos[j][i]={x=x,y=y,s=0.25,r=0}
		end
	end
	mxpos_bak = clone(mxpos)
end
function M:update(dt)
	--Timer.update(dt)
end
function M:keypressed(key)
end

function M:keyreleased(key)
end
press=false
p_col=0
p_row=0
n_col=0
n_row=0

function swap_anim()
	mxpos[p_row][p_col],mxpos[n_row][n_col] = mxpos[n_row][n_col],mxpos[p_row][p_col]
	local p_p=mxpos[p_row][p_col]
	local n_p=mxpos[n_row][n_col]
	Timer.script(function (wait)
					Timer.tween(0.2, p_p, {x = n_p.x,y=n_p.y},"out-sine")
			end)
	Timer.script(function (wait)
					Timer.tween(0.2, n_p, {x = p_p.x,y=p_p.y},"out-sine")
			end)
	Timer.script(function (wait)
					Timer.tween(0.1, p_p, {s = 0.10},"out-sine")
					wait(0.1)
					Timer.tween(0.1, p_p, {s = 0.25},"in-sine")
			end)
	Timer.script(function (wait)
					Timer.tween(0.1, n_p, {s = 0.4},"out-sine")
					wait(0.1)
					Timer.tween(0.1, n_p, {s = 0.25},"in-sine")
					wait(0.1)
					p_col=0
					p_row=0
					n_col=0
					n_row=0
			end)
end
function no_swap_anim()
	local p_p=mxpos[p_row][p_col]
	local n_p=mxpos[n_row][n_col]
	Timer.script(function (wait)
					print("no_swap_anim")
					Timer.tween(0.05, p_p, {r = 0.2},"out-sine") wait(0.05)					
					Timer.tween(0.05, p_p, {r = -0.2},"out-sine") wait(0.05)
					Timer.tween(0.05, p_p, {r = 0.2},"out-sine") wait(0.05)
					Timer.tween(0.05, p_p, {r = 0.0},"out-sine")
			end)
	Timer.script(function (wait)
					Timer.tween(0.05, n_p, {r = 0.2},"out-sine") wait(0.05)					
					Timer.tween(0.1, n_p, {r = -0.2},"out-sine") wait(0.1)					
					Timer.tween(0.05, n_p, {r = 0},"out-sine")
			end)
end
function diss_anim(t,func)
	for _,v in ipairs(t) do
		local p_p=mxpos[v[1]][v[2]]
		Timer.script(function (wait)
						wait(0.5)
						Timer.tween(0.1, p_p, {s = 0},"linear")	
						Timer.tween(0.1, p_p, {r = math.pi},"in-sine") wait(0.2)
						p_p.s=sps
						p_p.r=0			
				end)
	end
	Timer.script(function (wait)
						wait(0.5)
						wait(0.2)
						func()
						fllow_down()
				end)
end
function fllow_down()
	local r=1
	local h={}
	local dt=0
	for i=1,gw do
		-------------------
		local s=0
		local t={}
		for j=1,gh do
			if(mx[j][i]==0) then
				if(s==0) then
					s=j
					print("sss ",s)
				end	
			elseif(s>0) then
				swap({j,i},{s,i})
				mxpos[s][i].x = mxpos_bak[j][i].x
				mxpos[s][i].y = mxpos_bak[j][i].y
				local n_p = mxpos[s][i]					
				Timer.tween(0.1, n_p, {y=mxpos_bak[s][i].y},"out-sine")
				s=s+1
				print("sss ",s)
			end		
		end
		--print("new element ")
		Timer.script(function (wait)
			wait(0.2)
			local s = 0
			for k=gh,1,-1 do
				if(mx[k][i]~=0) then
					s=k
					break
				end
			end
			--print("new ele ",s)
			local n = gh-s
			--wait(0.07)
			for k=s+1,gh do
				gen({k,i})
				mxpos[k][i].x = mxpos_bak[k][i].x
				mxpos[k][i].y = mxpos_bak[k][i].y-n*sph
				local n_p = mxpos[k][i]					
				Timer.tween(0.15, n_p, {y=mxpos_bak[k][i].y},"out-sine")
				--wait(0.07)
			end							
		end)		
	end
	Timer.script(function (wait)
				wait(0.25)
				auto_swap1()
				auto_swap2()
				wait(0,15)
				auto_select()
	end)
end

function auto_select()
	local g = search_all()
	if(g and #g>0) then
		-- local i = math.random(1,#g)
		-- print("auto_select ok",i,#g[i])
		-- diss_anim(g[i],function() delete(g[i]) end)
		local r =combine(unpack(g))
		diss_anim(r,function() delete(r) end)
		
	else
		notouch	= false
	end	
end	

local swaptb1=
{
	{1,3},
	{2,3},
	{3,3},
	{4,3},
	{4,4},
	{4,5},
	{4,6},
	{3,6},
	{2,6},
	{1,6},		
	{1,5},
	{1,4},
	{1,3},
}
local swaptb2=
{
	{2,4},
	{2,5},
	{3,5},
	{3,4},
	{2,4}
}

function auto_swap(tb)
	local tb2={}
	for k,v in ipairs(tb) do
		tb2[k]=tb[k]
	end
	for i=1,#tb-1 do
		local r=tb[i][1]
		local c=tb[i][2]
		local rr =tb2[i+1][1]
		local cc =tb2[i+1][2]
		mx[r][c]=mx[rr][cc]
		mxpos[r][c].x = mxpos_bak[rr][cc].x
		mxpos[r][c].y = mxpos_bak[rr][cc].y
		local n_p = mxpos[r][c]					
		Timer.tween(0.15, n_p, {x=mxpos_bak[r][c].x,y=mxpos_bak[r][c].y},"out-sine")
	end

end	
function auto_swap1()
	auto_swap(swaptb1)
end	
function auto_swap2()
	--auto_swap(swaptb2)
end

function M:mousepressed(x, y, button, istouch)
	if(notouch) then return end
	press=true
	p_col= 1+math.floor(x/spw)
	p_row= 1+math.floor((winh-y)/sph)	
	print("=======press ",p_row,p_col)
	if(p_col>gw or p_row>gh or mx[p_row][p_col]==0) then
		press=false
		return
	end
end
function M:mousemoved( x, y, dx, dy )
	if(press) then
		n_col = 1+math.floor(x/spw)
		n_row = 1+math.floor((winh-y)/sph)	
		if(n_col~=p_col) then			
			n_row = p_row
			print("=======move  ",p_row,p_col)
			press=false			
		elseif(n_row~=p_row) then
			n_col = p_col
			print("=======move  ",n_row,p_col)
			press=false
		else
			return	
		end
		if(n_col>gw or n_row>gh or mx[n_row][n_col]==0) then
			press=false
			no_swap_anim()
			return
		end
		if(n_row~=p_row or n_col~=p_col) then
			--same no swap
			if(mx[p_row][p_col]==mx[n_row][n_col]) then
			--	no_swap_anim()
			--	return
			end
			--swap
			swap({p_row,p_col},{n_row,n_col})
			--dump()
			--search new
			local t = search_AB(3,n_row,n_col,p_row,p_col)	
			if(t) then
				notouch = true
				swap_anim()
				diss_anim(t,function() delete(t) end)
				--fllow_down()
			else
				--recover if fail
				swap({p_row,p_col},{n_row,n_col})
				no_swap_anim()
			end
		end
	end
end
function M:mousereleased(x, y, button)
    press=false
end
local pos
local pixelcode = [[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
    {
    	return Texel(texture, texture_coords)*1.5;
    }
]]
local shader = love.graphics.newShader(pixelcode)
function M:draw(dt)
    for j=gh,1,-1 do
		for i=1,gw do
			-- local x = (i-1)*spw+spw/2
			-- local y = (winh-sph)-(j-1)*sph+sph/2
			if not ((j==p_row and i==p_col) or  (j==n_row and i==n_col)) then
				if(spt[mx[j][i]]) then
					pos=mxpos[j][i]
					drawspt(spt[mx[j][i]],pos.x,pos.y,pos.r,pos.s,pos.s)
				end
			end			
		end
	end

 	lg_setShader(shader)
    if(mx[p_row] and mx[p_row][p_col] and spt[mx[p_row][p_col]]) then
		pos=mxpos[p_row][p_col]
		drawspt(spt[mx[p_row][p_col]],pos.x,pos.y,pos.r,pos.s,pos.s)
	end
	lg_setShader()
	if(mx[n_row] and mx[n_row][n_col] and spt[mx[n_row][n_col]]) then
		pos=mxpos[n_row][n_col]
		drawspt(spt[mx[n_row][n_col]],pos.x,pos.y,pos.r,pos.s,pos.s)
	end	
end
return M
