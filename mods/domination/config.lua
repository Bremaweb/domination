domination_config = {}

-- the number a team's domination meter must reach to win the game
domination_config.game_goal = 100

-- how much the team's domination meter should increase, each step, for each node captured
domination_config.capture_increment = .001 

-- how many teams should be setup
domination_config.teams = 4


team_def = {}

team_def[1] = { name = "Red", skin="domination_red_skin.png"}
team_def[2] = { name = "Blue", skin="domination_blue_skin.png"}
team_def[3] = { name = "Green", skin="domination_green_skin.png"}
team_def[4] = { name = "Orange", skin="domination_orange_skin.png"}



