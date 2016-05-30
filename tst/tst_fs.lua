local M={}
function M.load()
 	print("savedir:	",love.filesystem.getSaveDirectory())
 	print("userdir:  ",love.filesystem.getUserDirectory())
 	print("srcbasedir:  ",love.filesystem.getSourceBaseDirectory())
 	print("requirepath: ",love.filesystem.getRequirePath())
 	print("identity: ",love.filesystem.getIdentity())
 	print("setidentity: ",love.filesystem.setIdentity("lg"))
 	print("creatdir:lg/a  ",love.filesystem.createDirectory("a"))
 	print("setidentity: ",love.filesystem.setIdentity("ag"))
 	print("creatdir:ag/b  ",love.filesystem.createDirectory("b"))
 	--could not setSource
 	--print("setsrcpath:  ",love.filesystem.setSource("lg"))
 	--aa.zip 使用zip指令压缩 非tar 导致mount失败
 	print("mount aa.zip  ",love.filesystem.mount("aa.zip","aa"))
 	--热更新基本
 	print("setrequirepath: ",love.filesystem.setRequirePath("aa/?.lua;?.lua;?/init.lua"))
 	print("requirepath: ",love.filesystem.getRequirePath())
 	require "ak"
 	print("aurl",AURL)
 
end

function M.draw()
end

function M.update(dt)

end

return M


