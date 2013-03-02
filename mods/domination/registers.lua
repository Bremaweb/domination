
minetest.register_privilege("domination", {
	description = "Domination game administrator",
	give_to_single_player = false
})

minetest.register_node("domination:domination_block",{
	tiles={"domination_block.png"},
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
	
	on_punch = domination.punch_block,
})




minetest.register_globalstep(domination.step)