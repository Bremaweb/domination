domination_config = {}

-- the number a team's domination meter must reach to win the game
domination_config.game_goal = 20

-- how much the team's domination meter should increase for each 5 seconds they hold a node.
domination_config.capture_increment = .5

-- how many teams should be setup
domination_config.teams = 4

-- default spawn point when a person joins the server, people will be moved to this point when the log on, and when the game is over
domination_config.default_spawn = {x=912,y=79,z=986}

-- domination node protection size
domination_config.protect_size = 5

-- define the game area, this is used to find and reset the domination blocks
domination_config.area = { {x=795,y=-45,z=801} , {x=1011,y=45,z=1168} }

team_def = {}

team_def[1] = { name="Red", skin="domination_red_skin.png", spawn={x=805,y=9,z=1130}}
team_def[2] = { name="Blue", skin="domination_blue_skin.png", spawn={x=829,y=10,z=859}}
team_def[3] = { name="Green", skin="domination_green_skin.png", spawn={x=940,y=4,z=832}}
team_def[4] = { name="Orange", skin="domination_orange_skin.png", spawn={x=988,y=2,z=1143}}



