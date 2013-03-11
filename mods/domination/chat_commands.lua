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


minetest.register_chatcommand("game_stat",{
    params = "",
	func = function (name, param)
		if ( os.time() > domination.next_check ) then
		minetest.chat_send_player(name,"-----------------")
		for t in pairs(domination.teams) do
		    local dp = round( ( ( domination.teams[t].domination / domination_config.game_goal ) * 100 ), 2 )
		  
			minetest.chat_send_player(name,domination.teams[t].name..": "..tostring(domination.teams[t].domination).."%")
		end
		domination.next_check = os.time() + 15
	  end	 
	end
})

minetest.register_chatcommand("create_arena",{
	params = "",
	privs = {domination=true},
	func = function ( name, param )
		minetest.chat_send_player(name,"Creating arena, this may take a while...")
		domination_arena.build_walls()	
		minetest.chat_send_player(name,"Arena has been created!")
	end
})

minetest.register_chatcommand("tc",{
	params = "/tc <message>",
	description = "Sends a chat only to your team members",
	privs = {shout=true},
	func = function (name, param)
		local pteam = domination.get_player_team(minetest.env:get_player_by_name(name))
		if ( pteam ~= nil ) then
			for i,p in ipairs(domination.teams[pteam].players) do
				minetest.chat_send_player(p,pteam..": "..param)
			end
		end
	end
})
