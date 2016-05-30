local csv = require "lib.csv"
local M={}
function M.load()
	local f = csv.open("assets/ConfigShop.csv")
	for fields in f:lines() do
	  local str=""
	  for i, v in ipairs(fields) do 
	  	str = str .. '#' .. v 
	  end
	  print(str)
	end
end

function M.draw()
end

function M.update(dt)

end

return M


