minetest.register_chatcommand("teams", {
	privs = {},
  params = "",
  description = "List available teams and number of players",
  func = function(name, param)
    minetest.log("action","teams")
		for t in pairs(domination.teams) do
		    tp = ""
		    for pn in pairs(domination.teams[t].players) do
		      tp = domination.teams[t].players[pn].."  "
		    end
		    minetest.log("action",tostring(t))
		    minetest.chat_send_player(name,domination.teams[t].name..": "..tp)
		end
	  end	
    
})

minetest.register_chatcommand("join", {
	privs = {},
  params = "/join <team name>",
  description = "Joins a player to the team given",
  func = function(name, param)
    if  ( param == "" ) then
	minetest.chat_send_player(name,"Please enter a enter a team to join. Use /teams to view available teams, or /join auto to be auto assigned to a team")
	return
    end
    param = string.lower(param)
    if ( domination.teams[param] ~= nil ) then
		if ( domination.join_team(name,param) ~= nil ) then
			minetest.chat_send_player(name,"You joined "..param)
		else
			minetest.chat_send_player(name,"There was an error joining "..param)
		end
    else
      minetest.chat_send_player(name,"Team "..param.." does not exist")
    end
    
  end
})

minetest.register_chatcommand("domination",{
	privs = { domination=true },
	params = "/domination (start|stop)",
	func = function (name, param)
		if ( param == "" ) then
			minetest.chat_send_player(name,"Proper syntax is /domination start|stop")
			return nil
		end
		
		if ( param == "start" ) then
			-- start the game
			domination.start_game()
			return
		end
		
		
		if ( param == "stop" ) then
			-- stop the game
			domination.stop_game()
			return
		end	
		
	end
})
