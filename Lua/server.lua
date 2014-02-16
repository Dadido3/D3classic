function Server(Message)
	System_Message_Network_Send_2_All(-1, "&0Server: &c"..Message)
	print("Server Message: "..Message)
end