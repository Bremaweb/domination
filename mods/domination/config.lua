domination_config = {}

-- the number a team's domination meter must reach to win the game
domination_config.game_goal = 20

-- how much the team's domination meter should increase for each 5 seconds they hold a node.
domination_config.capture_increment = .5

-- how many teams should be setup
domination_config.teams = 4

-- default spawn point when a person joins the server, people will be moved to this point when the log on, and when the game is over
domination_config.default_spawn = {x=1027,y=110,z=1131}

-- domination node protection size
domination_config.protect_size = 5

-- define the game area, this is used to for the arena setup
-- the Y coordinate is excluded
domination_config.area = { {x=813,z=840}, {x=1195,z=1351} }

team_def = {}

team_def[1] = { name="Red", skin="domination_red_skin.png", spawn={x=834,y=5,z=866}}
team_def[2] = { name="Blue", skin="domination_blue_skin.png", spawn={x=1187,y=32,z=878}}
team_def[3] = { name="Green", skin="domination_green_skin.png", spawn={x=1103,y=16,z=1337}}
team_def[4] = { name="Orange", skin="domination_orange_skin.png", spawn={x=826,y=2,z=1273}}



