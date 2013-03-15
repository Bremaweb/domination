dofile( minetest.get_modpath("domination").."/classes/team.class.lua" )
dofile( minetest.get_modpath("domination").."/functions.lua" )
domination = {}

domination.teams = {}

domination.player_team_index = {}
domination.found_nodes = {}
domination.game_running = false
domination.next_check = 0
domination.next_iteration = 0

function domination.step (dtime)
  -- this function will do a lot of the heavy lifting when the game is running
  if ( domination.game_running == true ) then
	  if ( os.time() > domination.next_iteration ) then
		for t in pairs(domination.teams) do
			domination.teams[t]:increment_domination()
		end
		domination.next_iteration = os.time() + 5
	  end
	  --[[
	  if ( os.time() > domination.next_check ) then
		minetest.chat_send_all("-----------------")
		for t in pairs(domination.teams) do
		    local dp = round( ( ( domination.teams[t].domination / domination_config.game_goal ) * 100 ), 2 )
		  
			minetest.chat_send_all(domination.teams[t].name..": "..tostring(dp).."%")
		end
		domination.next_check = os.time() + 15
	  end
	  ]]	  
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
	groups = { domination_block=1 },
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
  
    -- see if they have already joined a team
    local t = domination.get_player_team(minetest.env:get_player_by_name(name))
    
    if ( domination.game_running == true and t ~= nil ) then
      minetest.chat_send_player(name,"You can't change teams in the middle of a game")
      return
    end
    
    if ( t ~= nil ) then
      for i,p in ipairs(domination.teams[t].players) do
	if p == name then
	  table.remove(domination.teams[t].players,i)
	end
      end      
    end
    
    -- now add them to the team
    table.insert(domination.teams[string.lower(p_team)].players,name)
	
	-- set the appropriate skin
	local p = minetest.env:get_player_by_name(name)
	p:set_properties({
		visual="mesh",
		-- don't set the texture here because it looks funny after installing the 3d armor mod
		--textures={domination.teams[string.lower(p_team)].skin},
		visual_size={x=1,y=1}		
	})
	domination.player_team_index[p] = string.lower(p_team)

	-- updating the armor will update the character texture
	armor_api:set_player_armor(p)

    if ( domination.game_running == true ) then
      -- spawn them in the game
      local player = minetest.env:get_player_by_name(name)
      local pos = get_coord_near(domination.teams[string.lower(p_team)].spawn,{x=5,y=0,z=5})
      player:moveto(pos)
    end

    minetest.chat_send_all(name.." has joined "..p_team.." team")
    
return true

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
	return nil
end

function domination.punch_block(pos, node, puncher)

	if ( domination.game_running == false ) then
		return nil
	end

	local t = domination.get_player_team(puncher)
	minetest.log("action","capture "..node.name.." by team "..t)
	if ( node.name ~= "domination:domination_block_"..t ) then
		domination.teams[t]:capture_node()
		
		local near = get_coord_near(pos,{x=20,y=10,z=20})
		
		minetest.chat_send_all(domination.teams[t].name.." captured a node near "..minetest.pos_to_string(near))
		
		-- remove the node from the current team
		for i=1,domination_config.teams do
		  if ( node.name == "domination:domination_block_"..string.lower(team_def[i].name) ) then
		    domination.teams[string.lower(team_def[i].name)]:lose_node()
		  end
		end
		
		
		minetest.env:set_node(pos,{name="domination:domination_block_"..t})
		minetest.sound_play("domination_alert",{pos=pos,max_hear_distance=55,gain=15})
	end
	table.insert(domination.found_nodes,pos)
end

function domination.start_game()
	minetest.chat_send_all("Game preparing to start!")
	
	-- move players to the appropriate positions
	for t in pairs(domination.teams) do
		domination.teams[t].domination=0
		domination.teams[t].increment=0
		for i,p in ipairs(domination.teams[t].players) do
			local pos = get_coord_near(domination.teams[t].spawn,{x=5,y=0,z=5})
			
			minetest.log("action","Move player "..tostring(p))
			
			local pl = minetest.env:get_player_by_name(p)
			pl:set_hp(20)
			pl:moveto(pos)
		end
	end
	
	domination.game_running = true
	minetest.sound_play("domination_go")
end

function domination.stop_game()
-- move all players back to the spawn area	
  minetest.chat_send_all("Game is stopping")
  for _,player in ipairs(minetest.get_connected_players()) do
    local pos = get_coord_near(domination_config.default_spawn,{x=4,y=0,z=4})
    player:moveto(pos)
    
    -- remove any inventory they may have
    domination.strip_inventory(player,false)
  end
  
  -- reset the domination blocks
  for _,p in ipairs(domination.found_nodes) do
    minetest.env:set_node(p,{name="domination:domination_block"})
  end
  --[[ find all domination team blocks in the world and reset them to the unclaimed block
	minetest.log("action","Game Area "..minetest.pos_to_string(domination_config.area[1]).." - "..minetest.pos_to_string(domination_config.area[2]))
	local dnodes = minetest.env:find_nodes_in_area(domination_config.area[1],domination_config.area[2],{"domination:domination_block_red","domination:domination_block_green","domination:domination_block_blue","domination:domination_block_orange"})
	for _,npos in ipairs(dnodes) do
	  minetest.log("action","resetting block "..tostring(npos))
	  minetest.env:remove_node(npos)
	  minetest.env:add_node(npos,{name="domination_block"})
	end]]
	
-- flag the game not running  
  domination.game_running = false
end


function domination.player_join(player)
  -- move the player to the default spawn point
  pteam = domination.get_player_team(player)
  if ( domination.game_running == false or pteam == nil ) then
	  local pos = get_coord_near(domination_config.default_spawn,{x=4,y=0,z=4})
	  player:moveto(pos)
	  
	  -- strip any inventory they may have
	  domination.strip_inventory(player,false)
	  minetest.chat_send_player(player:get_player_name(),"Welcome! Use /teams to see available teams, /join to join a team. Use /help to see other commands available")
  	return  	
  end
  
  if ( pteam ~= nil ) then
  	local pos = get_coord_near(domination.teams[string.lower(pteam)].spawn,{x=4,y=0,z=4})
  	player:moveto(pos)
  	minetest.chat_send_all(player:get_player_name().." has joined ("..pteam..")")
  end
end


function domination.player_leave(player)
  local t = domination.get_player_team(player)  
  minetest.chat_send_all(player:get_player_name().." left the game ("..tostring(t)..")")
end

function domination.player_respawn(player)
	if domination.game_running == true then
		local t = domination.get_player_team(player)
		local pos = get_coord_near(domination.teams[t].spawn,{x=4,y=0,z=4})
		player:moveto(pos)
	else
		local pos = get_coord_near(domination_config.default_spawn,{x=4,y=0,z=4})
		player:moveto(pos)
	end
	return true
end

function domination.player_die(player)	
	domination.strip_inventory(player,true)
	return true
end

function domination.team_chat(name,message)  
      local pteam = domination.get_player_team(minetest.env:get_player_by_name(name))
      if ( pteam ~= nil ) then
	      for i,p in ipairs(domination.teams[pteam].players) do
		      minetest.chat_send_player(p,name.."("..pteam..") : "..message)
	      end
      end
end

function domination.strip_inventory(player,drop)
-- from PilzAdam's bones mod
	local name = player:get_player_name()
	local pos = player:getpos()
	local player_inv = player:get_inventory()

	if ( player_inv == nil ) then
		return
	end

		for _,v in ipairs({"main","craft"}) do
			for i=1,player_inv:get_size(v) do
			if ( drop == true ) then
				local stack = player_inv:get_stack(v,i)
				domination.drop_item(stack,pos)
				--minetest.item_drop(stack,player,pos)
			end
			player_inv:set_stack(v, i, nil)
			end		
		end

		--[[Clear the main inventory
		for i=1,player_inv:get_size("main") do
			if ( drop == true ) then
				local stack = player_inv:get_stack("main",i)
				domination.drop_item(stack,player,pos)
				--minetest.item_drop(stack,player,pos)
			end
			player_inv:set_stack("main", i, nil)
		end
		
		-- clear the craft grid
		for i=1,player_inv:get_size("craft") do
			if ( drop == true ) then
				local stack = player_inv:get_stack("craft",i)
				domination.drop_item(stack,player,pos)
				--minetest.item_drop(stack,player,pos)
			end
			player_inv:set_stack("craft", i, nil)
		end
		]]
		
	-- clear the armor slots
	local armor_inv = minetest.get_inventory({type="detached", name=name.."_outfit"})
	for _,v in ipairs({"head", "torso", "legs", "shield"}) do
		if ( drop == true ) then
			local stack = armor_inv:get_stack("armor_"..v,1)
			domination.drop_item(stack,pos)
			--minetest.item_drop(stack,player,pos)
		end
		armor_inv:set_stack("armor_"..v, 1, nil)
	end	
end

function domination.drop_item(itemstack,pos)

local name = itemstack:get_name()
local count = itemstack:get_count()

	for i=1,count,5 do
		npos = get_coord_near(pos,{x=3,y=0,z=3})
		npos.y = npos.y + 2 
		local obj = minetest.env:add_item(npos, name)
				
		if obj ~= nil then
			obj:get_luaentity().collect = true
			obj:setvelocity({x=math.random(0,6)-3, y=1, z=math.random(0,6)-3})
		end	
				
	end	
end

dofile( minetest.get_modpath("domination").."/config.lua" )
dofile( minetest.get_modpath("domination").."/arena_setup.lua" )
dofile( minetest.get_modpath("domination").."/chat_commands.lua" )
dofile( minetest.get_modpath("domination").."/registers.lua" )
dofile( minetest.get_modpath("domination").."/protection.lua" )

minetest.log("action","Setting up "..tostring(domination_config.teams).." teams")
for i=1,domination_config.teams do
  domination.register_team(team_def[i].name,team_def[i].skin,team_def[i].spawn)
end



