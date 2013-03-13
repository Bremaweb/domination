-- protect around the domination blocks

-- override minetest.item_place_node
local old_item_place_node = minetest.item_place_node
function minetest.item_place_node(itemstack, placer, pointed_thing)
    local player = placer:get_player_name()	

	local ppos = minetest.get_pointed_thing_position(pointed_thing,false)
	local dominationBlock = minetest.env:find_node_near(ppos,4,{"group:domination_block"})
	if ( dominationBlock ~= nil ) then
		minetest.chat_send_player(player, "You cannot build that close to a domination block")
		return itemstack	
	else
		-- place the node
		local output = old_item_place_node(itemstack, placer, pointed_thing)
		return output
	end	
end

-- override minetest.node_dig
local old_node_dig = minetest.node_dig
function minetest.node_dig(pos, node, digger)
    local player = digger:get_player_name()	
	
	local dominationBlock = minetest.env:find_node_near(pos,4,{"group:domination_block"})
	if ( dominationBlock ~= nil ) then
		minetest.chat_send_player(player, "You cannot dig that close to a domination block")
		return	
	else
		-- place the node
		return old_node_dig(pos, node, digger)
	end
end