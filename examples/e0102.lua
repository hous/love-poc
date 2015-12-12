-- Example: Physics
-- Grabbity by Xcmd
-- Updated by Dresenpai
math.randomseed( os.time() )

function love.load()
   myWorld = love.physics.newWorld(-800, -600, 800, 600) -- updated Arguments for new variant of newWorld in 0.7.0
   myWorld:setGravity(0, 15)
   myWorld:setCallbacks( acol, pcol, rcol, rtcol )

   myBallBody = love.physics.newBody( myWorld, 300, 400 )
   myBallShape = love.physics.newCircleShape( myBallBody, 0, 0, 16 )
   myBallBody:setMass(0,0,1,0)
   myBallShape:setData("ball")

   myWinBody = love.physics.newBody( myWorld, math.floor(math.random(0, 800)), math.floor(math.random(0, 600))  )
   myWinShape = love.physics.newRectangleShape( myWinBody, 0, 0, 16, 16, 0 )
   myWinShape:setData("win")

   text = ""
end

function love.update( dt )
   myWorld:update( dt )
end

function love.draw()
   love.graphics.circle("line", myBallBody:getX(), myBallBody:getY(), myBallShape:getRadius())
   love.graphics.polygon("fill", myWinShape:getPoints())
   love.graphics.print( text, 5, 15 )
end

function love.keypressed( key )
   if key == "up" then
      myWorld:setGravity(0, -15)
   elseif key == "down" then
      myWorld:setGravity(0, 15)
   elseif key == "left" then
      myWorld:setGravity(-15, 0)
   elseif key == "right" then
      myWorld:setGravity(15, 0)
   end

   if key == "r" then
      love.load()
   end
end

function acol( a, b, c )
   coll( a, b, c, "Add" )
end

function pcol( a, b, c )
   coll( a, b, c, "Persistent" )
end

function rcol( a, b, c )
   coll( a, b, c, "Remove" )
end

function rtcol( a, b, c )
   coll( a, b, c, "Result" )
end

function coll( a, b, c, ctype )
   local f, r = c:getFriction(), c:getRestitution()
   local s = c:getSeparation()
   local px, py = c:getPosition()
   local vx, vy = c:getVelocity()
   local nx, ny = c:getNormal()

   text = ctype .. " Collision:\n"
   text = text .. "Shapes: " .. a .. " and " .. b .. "\n"
   text = text .. "Position: " .. px .. "," .. py .. "\n"
   text = text .. "Velocity: " .. vx .. "," .. vy .. "\n"
   text = text .. "Normal: " .. nx .. "," .. ny .. "\n"
   text = text .. "Friction: " .. f .. "\n"
   text = text .. "Restitution: " .. r .. "\n"
   text = text .. "Separation: " .. s .. "\n"
end

