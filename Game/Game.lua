require "common"

--- Game singleton class
--	Used to register all game entities
--	TODO make it actually a singleton or static class
Game = Class{name = "game", function(self)
	self.entities = {}
end}

-- Register a new entity, usually collidable
function Game:register(entity, name)
	if self.entities[name] then
		print("ERROR, unable to register - entity already exists with name", name)
	else
		self.entities[name] = entity
	end
end

-- Handle user inputs
function Game:handleInputs()
	player1 = self.entities["Player1"]
	player2 = self.entities["Player2"]

	if love.keyboard.isDown("d") then
		player1.lastDirection = "right"
		player1.direction.x = 1
	elseif love.keyboard.isDown("a") then
		player1.lastDirection = "left"
		player1.direction.x = -1
	else
		player1.direction.x = 0
	end

	if love.keyboard.isDown("w") then
		player1.direction.y = 1
	elseif love.keyboard.isDown("s") then
		player1.direction.y = -1
	else
		player1.direction.y = 0
	end

	if love.keyboard.isDown(" ") then
		player1.isJumping = true
	end

	if love.keyboard.isDown("lshift") then
		player1.isSprinting = true
	end

	if love.keyboard.isDown("lctrl") then
		if not player1.weapon.isSwinging and not player1.weapon.isDefending and not player1.weapon.isRebounding then
			player1:swingWeapon()
		end
	end
	
	if love.keyboard.isDown("f") then
		if not player1.weapon.isSwinging and not player1.weapon.isDefending and not player1.weapon.isRebounding then
			player1:defend()
		end
	end

	
	if love.keyboard.isDown("right") then
		player2.lastDirection = "right"
		player2.direction.x = 1
	elseif love.keyboard.isDown("left") then
		player2.lastDirection = "left"
		player2.direction.x = -1
	else
		player2.direction.x = 0
	end

	if love.keyboard.isDown("up") then
		player2.direction.y = 1
	elseif love.keyboard.isDown("down") then
		player2.direction.y = -1
	else
		player2.direction.y = 0
	end

	if love.keyboard.isDown("rctrl") then
		player2.isJumping = true
	end

	if love.keyboard.isDown("rshift") then
		player2.isSprinting = true
	end

	if love.keyboard.isDown("kp0") then
		if not player2.weapon.isSwinging and not player2.weapon.isDefending and not player2.weapon.isRebounding then
			player2.weapon:swing()
		end
	end

	if love.keyboard.isDown("kp1") then
		if not player2.weapon.isSwinging and not player2.weapon.isDefending and not player2.weapon.isRebounding then
			player2.weapon:defend()
		end
	end
	
	if love.keyboard.isDown("r") then
		local rand = math.floor(math.random(40, 600))
		player1.shape:moveTo(rand, 50)
		player1.shape.speed.x, player1.shape.speed.y = 0, 0
		player2.shape:moveTo(rand - 50, 50)
		player2.shape.speed.x, player2.shape.speed.y = 0, 0
	end
end

game = Game()