local http = require "socket.http"
local socket = require "socket"
local ltn12 = require("ltn12")

c = love.thread.getChannel("channel1")

----[[	
local t={}
local r,e,h= 
	http.request{ 
    	url = "http://www.baidu.com", 
    	sink = ltn12.sink.table(t), --内容保存到t
    	--sink = ltn12.sink.file(io.open("/Users/jeep/a.txt"))
    	port= 80,
    	timeout = 1,
    	useragent= "good",
    }
print("tst_thread ",e,r,c)
----]]
--c:push({"12345"})

----[[
c:supply({"12345"})
c:clear()
print("tst_thread has push")
----]]