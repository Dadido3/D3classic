-- ########################################################################################
-- ##                     Script to make crosstalk between servers                       ##
-- ##                                                                                    ##
-- ##                                AT : Archives Talk                                  ##
-- ########################################################################################

local AT_Adress = "google.de"
local AT_Port = 1000

-- #######################################

--if AT_Socket == nil then
--	AT_Socket = require("socket")
--	AT_Client = AT_Socket.connect(AT_Adress, AT_Port)
--end

--System_Message_Network_Send_2_All(-1, "Adr:"..AT_Adress.." Port:"..tostring(AT_Port))

function Event_Timer_Archives_Talk(Map_ID)
	-- wait for a connection from any client
	--local client = AT_Server:accept()
	-- make sure we don't block waiting for this client's line
	--client:settimeout(10)
	-- receive the line
	--local line, err = client:receive()
	-- if there was no error, send it back to the client
	--if not err then client:send(line .. "\n") end
	-- done with client, close the object
	--client:close()
end
