team = {}
team_mt = { __index = team }

team.domination = 0
team.increment = 0
team.name = ""
team.skin = ""
team.players = {}

function team:capturePoint()
  self.iterator = self.iterator + domination_config.capture_increment
end

function team:create()
    local new_inst = {}    -- the new instance
    setmetatable( new_inst, team_mt ) -- all instances share the same metatable
    return new_inst
end
