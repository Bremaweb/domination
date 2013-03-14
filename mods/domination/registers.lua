
minetest.register_privilege("domination", {
	description = "Domination game administrator",
	give_to_single_player = false
})

minetest.register_node("domination:domination_block",{
	tiles={"domination_block.png"},
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
	
	on_punch = domination.punch_block,
})

minetest.register_node("domination:border",{
  tiles={"domination_border.png"},
  buildable_to=false,
  can_dig = function(pos,player)
    return false
  end
})


minetest.register_globalstep(domination.step)

minetest.register_on_joinplayer(domination.player_join)

minetest.register_on_respawnplayer(domination.player_respawn)

minetest.register_on_dieplayer(domination.player_die)

minetest.register_on_leaveplayer(domination.player_leave)

minetest.register_on_shutdown(domination.stop_game)