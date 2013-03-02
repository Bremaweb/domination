domination_config = {}

-- the number a team's domination meter must reach to win the game
domination_config.game_goal = 20

-- how much the team's domination meter should increase, each step, for each node captured
domination_config.capture_increment = .001

-- how many teams should be setup
domination_config.teams = 4

-- default spawn point when a person joins the server, people will be moved to this point when the log on, and when the game is over
domination_config.default_spawn = {x=912,y=79,z=986}

team_def = {}

team_def[1] = { name="Red", skin="domination_red_skin.png", spawn={x=805,y=9,z=1130}}
team_def[2] = { name="Blue", skin="domination_blue_skin.png", spawn={x=829,y=10,z=859}}
team_def[3] = { name="Green", skin="domination_green_skin.png", spawn={x=940,y=4,z=832}}
team_def[4] = { name="Orange", skin="domination_orange_skin.png", spawn={x=988,y=2,z=1143}}



