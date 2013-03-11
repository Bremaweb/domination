domination_arena = {}

function domination_arena.build_walls()
	-- this takes the defined area and builds a wall around it
	-- the worldedit set function   worldedit.set(pos1, pos2, "mod:node")
	
	-- wall along the Z axis
	local p = {}
	-- first wall
	p[1] = { x=domination_config.area[1].x, y=-10, z=domination_config.area[1].z }
	p[2] = { x=domination_config.area[1].x, y=45, z=domination_config.area[2].z }
	-- second wall
	p[3] = { x=domination_config.area[1].x, y=-10, z=domination_config.area[1].z }
	p[4] = { x=domination_config.area[2].x, y=45, z=domination_config.area[1].z }
	-- third wall
	p[5] = { x=domination_config.area[2].x, y=-10, z=domination_config.area[1].z }
	p[6] = { x=domination_config.area[2].x, y=45, z=domination_config.area[2].z }
	-- fourth wall
	p[7] = { x=domination_config.area[1].x, y=-10, z=domination_config.area[2].z }
	p[8] = { x=domination_config.area[2].x, y=45, z=domination_config.area[2].z }
	
	local n = 0
	
	for i=1,8,2 do
		
			local p1 = p[i]
			i=i+1
			local p2 = p[i]		
			minetest.chat_send_all("Creating wall "..minetest.pos_to_string(p1).." to "..minetest.pos_to_string(p2))
			domination_arena.set(p1,p2,"domination:border")						
			
	end	
end


domination_arena.set = function(pos1, pos2, nodename)	
	local env = minetest.env

	local node = {name=nodename}
	local pos = {x=pos1.x, y=0, z=0}
	while pos.x <= pos2.x do
		pos.y = pos1.y
		while pos.y <= pos2.y do
			pos.z = pos1.z
			while pos.z <= pos2.z do
				env:add_node(pos, node)
				pos.z = pos.z + 1
			end
			pos.y = pos.y + 1
		end
		pos.x = pos.x + 1
	end	
end
