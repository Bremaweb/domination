===========================================================
Minetest Domination
===========================================================

This is a new type of game play for Minetest. Each team is trying to retain control of certain
nodes within the map. A player takes control of a node by punching the node. Then they must
defend it by whatever means. Every 5 seconds a team retains control of a node or multiple nodes
the faster they reach the domination goal for the map.

===========================================================
The Configuration
===========================================================

Edit config.lua to setup the game to your preferences:

domination_config.game_goal - this is how many points a team must reach to win the game, this can be any number
domination_config.capture_increment - This is how many points a team receives every 5 seconds for each node they have control of. So if this value is .5 and a team controls 3 nodes they will receive 1.5 points every 5 seconds.
domination_config.teams - This is a maximum of 4
domination_config.default_spawn - (e.g. {x=0,y=0,z=0} ) This is the position of the default spawn, when a player joins the server they will be moved to this position. It's best that this area be outside of the game area. This area should be a relatively flat area as players will be placed anywhere +/-6 blocks on the z and x axis from your defined spawn point.
domination_config.protect_size - This is how far around a domination node that is protected, this prevents people completely burying nodes
domination_config.area - This is a pair of coordinates that defines the arena. (e.g. { {x=795,y=-45,z=801} , {x=1011,y=45,z=1168} } )

===========================================================
Team Definitions
===========================================================
These should mostly be left alone except for the spawn points

The spawn is the area where the team will spawn when the game starts

team_def[1] = { name="Red", skin="domination_red_skin.png", spawn={x=805,y=9,z=1130}}


===============================================================
Running The Game
===============================================================
These are the commands for playing, starting, and stopping the game

/teams - lists the teams that are available
/join <team> - joins a team
/domination <start|stop> - starts or stops the game. When the game starts everybody's inventory is cleared, and they are moved to their team spawn points. When the game stops, inventory is cleared again and everybody is moved back to the main spawn point.

