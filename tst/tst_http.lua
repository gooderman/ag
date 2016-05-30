local http = require "socket.http"
local socket = require "socket"
local ltn12 = require("ltn12")
local io = require("io")
local M={}
function M.load()
--[[	
	local t={}
	local r,e,h= 
		http.request{ 
	    	url = "http://www.baidu.com", 
	    	sink = ltn12.sink.table(t),
	    	--sink = ltn12.sink.file(io.open("/Users/jeep/a.txt"))
	    	port= 80,
	    	timeout = 1,
	    	useragent= "good",
	    }

	print(e)
	print(r)
	dump(t)
--]]
	atcp = socket.tcp()
	atcp:settimeout(0)
	host = socket.dns.toip("www.baidu.com")

	thd = love.thread.newThread("tst/tst_thread.lua")
	channel = love.thread.getChannel("channel1")
   	thd:start()
   	print("channel1: ",channel)

end

function M.draw()

end

function M.update(dt)
	M.ddt = M.ddt or dt
	M.ddt = M.ddt + dt
	local __succ, __status = atcp:connect(host, 80)
	if(M.ddt>1.0) then
		--print(__succ,__status)
		M.ddt=0
	end

	v = channel:pop()
    if v then
	  print("channel pop:   ",v[1],v[2])
	else
	  --print("channel pop:   ",nil)
    end

end

return M


