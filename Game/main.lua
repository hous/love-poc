require "common"
require "Game"
require "Sprite"
require "Player"
require "Weapon"
require "Room"
HardonCollider = require "lib/HardonCollider"
Timer = require "lib.hump.timer"

local allSolidTiles, dt, manager
 
function love.conf(t)
    t.author = "hous"
    t.console = true
end

function love.load()
	-- HardonCollider (Collision detection library)
	HC = HardonCollider(100, on_collide)
	love.graphics.setBackgroundColor(200,200,200,255)
	next_time = love.timer.getTime() * 1000
	player1 = Player("Player1", "bin/images/spritesheets/samus/", 100, 50, 35, 43)
	player1.weapon = Weapon("Player1 Weapon", "bin/images/spritesheets/sword/", 33, 33, player1)
	player2 = Player("Player2", "bin/images/spritesheets/samus/", 150, 50, 35, 43)
	player2.weapon = Weapon("Player2 Weapon", "bin/images/spritesheets/sword/", 33, 33, player2)
	HC:setActive(player1.collider)
	HC:setActive(player2.collider)
	winW, winH = love.graphics.getWidth(), love.graphics.getHeight()

	-- load the level and bind to variable map
	room = Room.Create("level.tmx")
	--room = Room.Create("wide.tmx")
	
	-- find all the tiles that we can collide with
	allSolidTiles = room:findSolidTiles(HC)
end

-- TODO move commands to Player class
function love.update(dt)
	game:handleInputs()
	-- Update collisions and position more frequently than framerate to get ahead of collision problems
	local step = .08
	while dt > step do
		-- Should these be here? Need fine-tuned collisions for gravity stuff, but not weapon collisions I don't think...
		-- player1:update(player1.direction.x, player1.direction.y, step)
		-- player2:update(player2.direction.x, player2.direction.y, step)
		HC:update(step)
		step = step + .08
	end
	player1:update(player1.direction.x, player1.direction.y, dt)
	player2:update(player2.direction.x, player2.direction.y, dt)
	player1.weapon:update(dt)
	player2.weapon:update(dt)
	HC:update(dt)
	Timer.update(dt)
	next_time = next_time + MIN_DT
end

function love.draw()
	room.map:draw()
	for i,v in pairs(game.entities) do
		v:draw()
	end
	local cur_time = love.timer.getTime() * 1000
	if next_time <= cur_time then
		next_time = cur_time
		return
	end
	love.timer.sleep(1000*(next_time - cur_time))
	love.graphics.print("FPS: " .. love.timer.getFPS(), 700, 10)
end

function love.keypressed(k)
	if k == 'escape' then
		love.event.quit() -- quit the game
	end
end

---
-- for each collidable entity, check to see if it is colliding and update appropriately
-- TODO: on_collide happens many times each frame, depending on framerate. Need to move the getHit, weaponClash, functionality out of this function, since they
-- 		should only happen once on update

function on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
	local tileShape, playerShape, playerWeaponShape, enemyShape, enemyWeaponShape, collisionType, inRange, entities = nil, nil, nil, nil, nil, nil, false, game.entities

	-- First loop through Player entities, checking for collisions
	for i,e in pairs(entities) do
		-- Only care about collisions with entities of type player
		if e.type == "player" then
			-- Check for player/tile collision
			if shape_a == e.shape and shape_a.type == "player" and shape_b.type == "tile" then
				playerShape = shape_a
				tileShape = shape_b
				collisionType = "playerTile"
			elseif shape_b == e.shape and shape_a.type == "tile" and shape_b.type == "player" then
				playerShape = shape_b
				tileShape = shape_a
				collisionType = "playerTile"
			-- Check for player/weapon collision
			elseif shape_a == e.shape and shape_a.type == "player" and shape_b.type == "weapon" then
				playerShape = shape_a
				playerWeaponShape = shape_b
				collisionType = "playerWeapon"
				inRange = true
			elseif shape_b == e.shape and shape_a.type == "weapon" and shape_b.type == "player" then
				playerShape = shape_b
				playerWeaponShape = shape_a
				collisionType = "playerWeapon"
				inRange = true
			-- Check for hot player on player action
			elseif shape_a == e.shape and shape_a.type == "player" and shape_b.type == "player" then
				playerShape = shape_a
				enemyShape = shape_b
				collisionType = "playerPlayer"
			end
		end
	end

	-- Then loop through Weapon entities, checking for collisions
	-- these collisions should supercede weapon/player collisions, which would occur when the players are very close
	for i,e in pairs(entities) do
		-- Only care about collisions with entities of type weapon
		if e.type == "weapon" then
			if shape_a == e.shape and shape_a.type == "weapon" and shape_b.type == "weapon" then
				playerWeaponShape = shape_a
				enemyWeaponShape = shape_b
				collisionType = "weaponWeapon"
			end
		end
	end
	
	-- if the collision is not one of the types defined above, get out
	if collisionType == nil then 
		return
	end
	
	-- Player / Tile collision
	if collisionType == "playerTile" then
		local playerX, playerY = playerShape:center()
		local tileX, tileY = tileShape:center()
		if math.abs(playerY - tileY) > math.abs(playerX - tileX) then
			if playerY < tileY then
				playerShape.onGround = true
			else
				playerShape.bumpedHead = true
			end
			playerShape:move(0, mtv_y)
		else
			playerShape:move(mtv_x, 0)
		end
	-- Player / Enemy collision, currently players can push each other. Not sure if this is ideal.
	elseif collisionType == "playerPlayer" then
		local playerX, playerY = playerShape:center()
		local enemyX, enemyY = enemyShape:center()
		playerShape:move(mtv_x/2, 0)
		enemyShape:move(-mtv_x/2,0)
	-- Player / Weapon collision
	elseif collisionType == "playerWeapon" then
		local playerX, playerY = playerShape:center()
		local weaponX, weaponY = playerWeaponShape:center()
		if not playerShape.parent.weapon.isDefending and not playerWeaponShape.parent.isDefending then
			playerShape.parent.isHit = true
			playerShape.parent.hitByWeapon = playerWeaponShape.parent
		end
	-- Weapon / Weapon collision - if players are in range, damage can be done - pass inRange to player:weaponClash
	elseif collisionType == "weaponWeapon" then
		local playerWeaponX, playerWeaponY = playerWeaponShape:center()
		local enemyWeaponX, enemyWeaponY = enemyWeaponShape:center()
		playerShape = playerWeaponShape.parent.owner.shape
		enemyShape = enemyWeaponShape.parent.owner.shape
--		playerShape:move(-mtv_x,0)
		playerShape.parent.weaponIsClashing = true
		playerShape.parent.clashingWithWeapon = enemyWeaponShape.parent
	end
end
