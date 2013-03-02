dofile( minetest.get_modpath("domination").."/classes/team.class.lua" )

domination = {}

domination.teams = {}
domination.game_running = false
function domination.step (dtime)
  -- this function will do a lot of the heavy lifting when the game is running
  if ( domination.game_running == true ) then
      
  end
end

function domination.register_team (team_name,team_skin)
  minetest.log("action","Registering team "..team_name)
  domination.teams[team_name] = team:create()
  domination.teams[team_name].name=team_name
  domination.teams[team_name].skin=team_skin
  domination.teams[team_name].players = {}
end

function domination.join_team (name, team)
  if ( domination.game_running == false ) then
    -- see if they have already joined a team
    for t in pairs(domination.teams) do
      for i,p in ipairs(t.players) do
	if p == name then
	  table.remove(t.players,i)
	end
      end      
    end
    
    -- now add them to the team
    table.insert(domination.teams[team].players,name)
  else
    mintest.chat_send_player(name,"Sorry you are unable to change teams while to game it running")
    return nil
  end
  
end


dofile( minetest.get_modpath("domination").."/config.lua" )
dofile( minetest.get_modpath("domination").."/chat_commands.lua" )

minetest.log("action","Setting up "..tostring(domination_config.teams).." teams")
for i=1,domination_config.teams do
  domination.register_team(team_def[i].name,team_def[i].skin)
end


minetest.register_globalstep(domination.step)



