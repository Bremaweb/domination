dofile( minetest.get_modpath("domination").."/classes/team.class.lua" )

domination = {}

domination.teams = {}
domination.game_running = false
domination.next_check = 0
function domination.step (dtime)
  -- this function will do a lot of the heavy lifting when the game is running
  if ( domination.game_running == true ) then
      for t in pairs(domination.teams) do
		domination.teams[t]:increment_domination()
	  end
	  
	  if ( os.time() > domination.next_check ) then
		minetest.chat_send_all("")
		minetest.chat_send_all("")
		minetest.chat_send_all("")
		minetest.chat_send_all("-----------------")
		for t in pairs(domination.teams) do
			minetest.chat_send_all(domination.teams[t].name..": "..tostring(domination.teams[t].domination))
		end
		domination.next_check = os.time() + 30
	  end	  
  end
end

function domination.register_team (team_name,team_skin,team_spawn)
  minetest.log("action","Registering team "..team_name)
  local team_id = string.lower(team_name)
  domination.teams[team_id] = team:create()
  domination.teams[team_id].name=team_name
  domination.teams[team_id].skin=team_skin
  domination.teams[team_id].spawn=team_spawn
  domination.teams[team_id].players = {}
  
  -- setup the team block
  minetest.register_node("domination:domination_block_"..team_id,{
	tiles={"domination_block_"..team_id..".png"},
	light_source=6,
	buildable_to=false,
	
	-- cannot be dug by anybody
	can_dig = function(pos,player)
		if ( domination.game_running == true ) then
			return false
		else
			return true
		end
	end,
	
	on_punch = domination.punch_block
})
  
  
end

function domination.join_team (name, p_team)
  if ( domination.game_running == false ) then
    -- see if they have already joined a team
    for t in pairs(domination.teams) do
      for i,p in ipairs(domination.teams[t].players) do
	if p == name then
	  table.remove(domination.teams[t].players,i)
	end
      end      
    end
    
    -- now add them to the team
    table.insert(domination.teams[string.lower(p_team)].players,name)
	
	-- set the appropriate skin
	p = minetest.env:get_player_by_name(name)
	p:set_properties({
		visual="mesh",
		textures={domination.teams[string.lower(p_team)].skin},
		visual_size={x=1,y=1}		
	})
	
	return true
  else
    mintest.chat_send_player(name,"Sorry you are unable to change teams while to game it running")
    return nil
  end
  
end

function domination.get_player_team(player)
	local name = player:get_player_name()
	for t in pairs(domination.teams) do
		for i,p in ipairs(domination.teams[t].players) do
			if p == name then
				return t
			end
		end
	end
end

function domination.punch_block(pos, node, puncher)

	if ( domination.game_running == false ) then
		return nil
	end

	local t = domination.get_player_team(puncher)
	minetest.log("action","capture "..node.name.." by team "..t)
	if ( node.name ~= "domination:domination_block_"..t ) then
		domination.teams[t]:capture_node()
		
		-- TODO
		-- find the current team that has this node and remove it from their list
		-- TODO
		
		minetest.env:set_node(pos,{name="domination:domination_block_"..t})
		minetest.sound_play("domination_alert",{pos=pos,max_hear_distance=50,gain=10})
	end
	
end

function domination.start_game()
	-- move players to the appropriate positions
	
	for t in pairs(domination.teams) do		
		for i,p in ipairs(domination.teams[t].players) do
			local randx = math.random(-12,12)
			local randz = math.random(-12,12)
			local x = domination.teams[t].spawn.x + randx
			local z = domination.teams[t].spawn.z + randz
			local y = domination.teams[t].spawn.y
			
			minetest.log("action","Move player "..tostring(p))
			
			local pl = minetest.env:get_player_by_name(p)
			pl:moveto({x=x,y=y,z=z})
		end
	end
	
	domination.game_running = true
	minetest.sound_play("domination_go")
end

dofile( minetest.get_modpath("domination").."/config.lua" )
dofile( minetest.get_modpath("domination").."/chat_commands.lua" )
dofile( minetest.get_modpath("domination").."/registers.lua" )

minetest.log("action","Setting up "..tostring(domination_config.teams).." teams")
for i=1,domination_config.teams do
  domination.register_team(team_def[i].name,team_def[i].skin,team_def[i].spawn)
end



