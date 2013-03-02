function get_coord_near(coords,variation)
  math.randomseed(os.time())
  local randx = math.random((variation.x*-1),variation.x)
  local randz = math.random((variation.z*-1),variation.z)
  local randy = math.random((variation.y*-1),variation.y)
  local xx = coords.x + randx
  local zz = coords.z + randz
  local yy = coords.y + randy
  
  return {x=xx,y=yy,z=zz}
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end