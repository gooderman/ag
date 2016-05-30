gh = cfg_gh
gw = cfg_gw
mx = {}
mxpos={}
mxpos_bak={}
elem = {1,2,3,4,5,6,7,8}
local log = function()end
--log = print
local logd = function()end
logd = print
function init()
	for i=1,gh do
		local tc={}	
		for j=1,gw do
			tc[j] = elem[math.random(1,#elem-3)]
		end
		mx[i]=tc
	end
end
function swap(a,b)
	mx[a[1]][a[2]],mx[b[1]][b[2]] = mx[b[1]][b[2]],mx[a[1]][a[2]]
end
function gen(a)
	mx[a[1]][a[2]] = elem[math.random(1,#elem)]
end
function delete(a)
	for _,v in ipairs(a) do
		log("delete",v[1],v[2])
		mx[v[1]][v[2]]=0
	end
end
function rotate(idx,n)
	local r={}
	for k,v in ipairs(idx) do
		if(1==n) then
			r[k]={-v[2],v[1]}
		elseif(2==n) then
			r[k]={-v[1],-v[2]}
		elseif(3==n) then
			r[k]={v[2],-v[1]}
		elseif(4==n) then	
			r[k]={v[1],v[2]}
		end
	end
	return r
end
function trans(t,v)
	local r={}
	for i=1,#t do
		r[i]={t[i][1]-v[1],t[i][2]-v[2]}
	end
	return r
end
function combine(...)
	local r={}
	local one={}
	local t={...}
	for _,v in pairs(t) do
		for _,k in pairs(v) do
			if(not one[k[1]..k[2]]) then
				table.insert(r,k)
				one[k[1]..k[2]]=0	
			end	
		end 
	end
	return r
end
function append(a,b)
	for _,k in ipairs(b) do
		table.insert(a,k)
	end
	return a
end
function dump(t)
	t=t or mx
	for i=gh,1,-1 do
		local str = ''
		for j=1,gw do
			str=str..string.format("%d  ",t[i][j])
		end
		logd(str)
	end
	logd("---------------")
end
function dumprst(x,y,r,flag)
	local t={}
	for i=gh,1,-1 do
		t[i]={}
		for j=1,gw do
			t[i][j] = 0
		end
	end
	for _,v in ipairs(r) do
		t[v[1]+x][v[2]+y] = flag
	end
	dump(t)
end

local rst   = 0
local flag  = 0
local rsttb = {}

function find(c,x,y)
	if(mx[x] and mx[x][y] and c>0 and c==mx[x][y]) then
		return 1
	end
	return 0
end
--------------------------------------
function search_all()
	local group={}
	local _bmx={}
	local _mx={}
	for i=1,gh do
		local tc={}	
		for j=1,gw do
			tc[j] = 0
		end
		_mx[i]=tc
		_bmx[i]={}
	end
	local atb={}
	local _c=0
	--h all group
	for i=1,gh do
		local j=1
		local tb={}
		while(j<=gw-2) do
			if(mx[i][j]==mx[i][j+1] and mx[i][j]==mx[i][j+2]) then
			    _c = mx[i][j]				
				_mx[i][j] = _c
				_mx[i][j+1]= _c
				_mx[i][j+2]= _c	
			end
			j=j+1

		end
	end
	--v all group
	for j=1,gw do
		local i=1
		local tb={}
		while(i<=gh-2) do
			if(mx[i][j]==mx[i+1][j] and mx[i][j]==mx[i+2][j]) then
				_c = mx[i][j]				
				_mx[i][j] = _c
				_mx[i+1][j]= _c
				_mx[i+2][j]= _c
			end
			i=i+1
		end
	end
	print("dump _mx")
	dump(_mx)
	--corss vh group
	local function wa(g,c,i,j)
		if(i>=1 and i<=gh and j>=1 and j<=gw and _mx[i][j]==c and (not _bmx[i][j])) then
			_bmx[i][j]=1
			table.insert(g,{i,j})
			wa(g,c,i+1,j)
			wa(g,c,i-1,j)
			wa(g,c,i,j-1)			
			wa(g,c,i,j+1)
		end
	end
	for i=1,gh do
		for j=1,gw do
			local c=_mx[i][j] 
			if(c~=0 and not _bmx[i][j]) then
				local g = {}
				wa(g,c,i,j)
				print("dump _group")
				table.insert(group,g)
				dumprst(0,0,g,1)
			end
		end
	end
	return group

end
--------------------------------------
function search_v(numb,x,y)
	log("---------------")
	log("line_v ",mx[x][y])
	log("numb ",numb)
	log("pox  ",x,y)
	rst  =0
	flag =mx[x][y]
	rsttb={}
	for i=x,1,-1 do
		if(find(flag,i,y)<=0) then
			break
		end
		table.insert(rsttb,{i,y})
		rst=rst+1
	end
	for i=x+1,gh do
		if(find(flag,i,y)<=0) then
			break
		end
		table.insert(rsttb,{i,y})
		rst=rst+1
	end
	log("V",rst>=numb,rst)
	log("---------------")
	return 	rst>=numb,rsttb
end
function search_h(numb,x,y)
	log("---------------")
	log("line_h ",mx[x][y])
	log("numb ",numb)
	log("pox  ",x,y)
	rst  =0
	flag =mx[x][y]
	rsttb={}
	for i=y,1,-1 do
		if(find(flag,x,i)<=0) then
			break
		end
		table.insert(rsttb,{x,i})
		rst=rst+1
	end
	for i=y+1,gw do
		if(find(flag,x,i)<=0) then
			break
		end
		table.insert(rsttb,{x,i})
		rst=rst+1
	end
	log("H",rst>=numb,rst)
	log("---------------")
	return 	rst>=numb,rsttb
end
function search_AB(numb,x1,y1,x2,y2)
	local r1,tb1 = search_v(numb,x1,y1)
	local r2,tb2 = search_h(numb,x1,y1)
	local r3,tb3 = search_v(numb,x2,y2)
	local r4,tb4 = search_h(numb,x2,y2)
	if(r1 or r2 or r3 or r4) then
		print("search_AB true")
		if(not r1) then tb1={} end
		if(not r2) then tb2={} end
		if(not r3) then tb3={} end
		if(not r4) then tb4={} end
		return combine(tb1,tb2,tb3,tb4)
	end	
end
--------------------------------------
function search_square(x,y)
	log("---------------")
	log("square ",mx[x][y])
	log("numb ",4)
	log("pox  ",x,y)
	rst  =0
	flag =mx[x][y]
	rsttb={}
	local function fs(x,y,idx)
		for _,v in ipairs(idx) do
			if(find(flag,x+v[1],y+v[2])<=0) then
				return false
			end
		end
		return true
	end
	log("TL",fs(x,y,{{0,-1},{-1,0},{-1,-1}}))
	log("TR",fs(x,y,{{0,1},{-1,0},{-1,1}}))
	log("BL",fs(x,y,{{0,-1},{1,0},{1,-1}}))
	log("BR",fs(x,y,{{0,1},{1,0},{1,1}}))
	log("---------------")
end
function search_l(numb,x,y)
	log("---------------")
	log("L ",mx[x][y])
	log("numb ",numb)
	log("pox  ",x,y)
	rst  =0
	flag =mx[x][y]
	rsttb={}
	local function fs(idx)
		local n=0
		for _,v in ipairs(idx) do
			if(find(flag,v[1],v[2])<=0) then
				break
			else
				n=n+1
			end
		end
		return n>=numb,n
	end
	local idxtb

	idxtb={}
	for i=y,1,-1 do
		table.insert(idxtb,{x,i})
	end
	log("L",fs(idxtb))
	
	idxtb={}
	for i=y,gh,1 do
		table.insert(idxtb,{x,i})
	end
	log("R",fs(idxtb))
	
	idxtb={}
	for i=x,1,-1 do
		table.insert(idxtb,{i,y})
	end
	log("T",fs(idxtb))

	idxtb={}
	for i=x,gw,1 do
		table.insert(idxtb,{i,y})
	end
	log("D",fs(idxtb))
	log("---------------")
end
--------------------------------------
function search_custom(x,y,idx)
	-- log("---------------")
	-- log("custom ",mx[x][y])
	-- log("numb ",#idx)
	-- log("pox  ",x,y)
	rst  =0
	flag =mx[x][y]
	rsttb={}
	local tx,ty=x,y
	for _,v in ipairs(idx) do
		tx=x+v[1]
		ty=y+v[2]
		--log(tx,ty)
		if(find(flag,tx,ty)<=0) then
			return false
		end
	end
	return true
end
function search_custom_t_r(x,y,t,ts,r)
	-- local t={{0,0},{0,1},{-1,1},{-1,2}}
	local idx={}
	for i=1,#t do
		local s = t[i]
		idx = trans(t,s)
		-- for j=1,#t do
		-- 	idx[j]={t[j][1]-s[1],t[j][2]-s[2]}
		-- end
		if(search_custom(x,y,idx)) then
			log("search r0 ok")			
			dumprst(x,y,idx,mx[x][y])
		end
		if(r) then
			idx=rotate(idx,1)
			if(search_custom(x,y,idx)) then
				log("search r1 ok")			
				dumprst(x,y,idx,mx[x][y])
			end
			idx=rotate(idx,1)
			if(search_custom(x,y,idx)) then
				log("search r2 ok")			
				dumprst(x,y,idx,mx[x][y])
			end
			idx=rotate(idx,1)
			if(search_custom(x,y,idx)) then
				log("search r3 ok")			
				dumprst(x,y,idx,mx[x][y])
			end
		end
		if(not ts) then
			break
		end
	end
end
function search_Z(x,y)
	local t={{0,0},{0,1},{-1,1},{-1,2}}
	search_custom_t_r(x,y,t,true,false)	
end
function search_RECT(x,y)
	local t={{0,0},{-1,0},{-2,0},{-2,1},{-2,2},{-1,2},{0,2},{0,1}}
	search_custom_t_r(x,y,t,true,false)	
end
function search_LINE(x,y)
	local t={{0,0},{0,1},{0,2}}
	search_custom_t_r(x,y,t,true,false)
end
function search_L(x,y)
	local t={{0,0},{0,1},{0,2},{1,2},{2,2}}
	search_custom_t_r(x,y,t,true,false)
end
--------------------------------------
init()
dump()
--search_square(3,4)
--swap({3,4},{4,4})
--dump()
--search_line(3,4,2)
--search_AB(3,3,4,3,5)
search_all()
--search_l(3,5,1)
--search_l(2,3,3)
--search_square(3,4)
--search_Z(3,3)
--search_RECT(3,3)
--search_LINE(3,3)
--search_LINE(3,3)