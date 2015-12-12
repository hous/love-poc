require "common"
require "Sprite"
require "Entity"

--- Sprite class
-- 	@param {string} sourceFolder - path to the sprite's animation spritesheet gifs
-- 		they should be named as [animationType]_[frameWidth]_[frameHeight]_[numFrames].gif
-- 		see setUpAnimationsFromFilenames method below...
Player = Class{name = "player", inherits = Sprite, function(self, name, sourceFolder, x, y, width, height)
	Sprite.construct(self, name, "player", sourceFolder, x, y, width, height)
	self.lastDirection = "right"
	self.direction = {}
	self.direction.x = 1
	self.direction.y = 1
	self.shape = HC:addRectangle(x,y,math.floor(0.65*width),math.floor(0.95*height))
	HC:addToGroup(self.name, self.shape)
	self.shape.parent = self
	self.shape.type = self.type
	self.shape.speed = {}
	self.shape.speed.x = 0
	self.shape.speed.y = 0
	self.shape.walkSpeed = 100
	self.shape.fallSpeed = 200
	self.shape.width = width
	self.shape.height = height
	self.shape.x = x
	self.shape.y = y
	self.shape.onGround = false
	self.shape.bumpedHead = false
	self.shape.isJumping = false
	self.weaponIsClashing = false
	self.isHit = false
	self.hitByWeapon = nil
	self.clashingWithWeapon = nil
end}

--- update the sprite's position and animation - routes params to updatePosition and updateAnimations methods
--	@param xDir enum(-1,0,1) x-direction that the sprite is travelling
--	@param yDir enum(-1,0,1) y-direction that the sprite is travelling
--	@param dt the time delta
function Player:update(xDir, yDir, dt)
	local v, walkV = self.shape.speed, self.shape.walkSpeed
	if xDir == 1 then
		self.currentAnimation = "right"
		if self.isSprinting then
			v.x = 1.5*walkV
		else
			v.x = walkV
		end
	elseif xDir == -1 then
		self.currentAnimation = "left"
		if self.isSprinting then
			v.x = -1.5*walkV
		else
			v.x = -walkV
		end
	elseif xDir == 0 then
		v.x = 0
		if self.lastDirection == "left" then
			self.currentAnimation = "restingLeft"
		else
			self.currentAnimation = "restingRight"
		end
	end
	if self.shape.onGround then
		if self.isJumping then
			v.y = 100
		else
			v.y = 0
		end
	else
		if self.bumpedHead then
			v.y = 0
		end
		v.y = v.y - 10
	end

	--This is not cutting it. getHit should only be called after a set amount of time determined by the weapon clash type
	--Should be a timer involved somewhere
	if self.isHit then
		if not self.isDefending and not self.weaponIsClashing then
			self:getHit(self.hitByWeapon)
		end
	end
	if self.weaponIsClashing then
		self:weaponClash(self.clashingWithWeapon, inRange)
	end

	self.animations[self.currentAnimation]:update(dt)
	self.shape:move(dt*v.x,0)
	self.shape:move(0,math.floor(-dt*v.y))
	self.shape.onGround = false
	self.shape.bumpedHead = false
	self.isJumping = false
	self.isSprinting = false
	self.weaponIsClashing = false
	self.isHit = false
	self.hitByWeapon = nil
	self.clashingWithWeapon = nil
end

function Player:swingWeapon()
	if self.weapon then
		self.weapon:swing()
	end
end

function Player:defend()
	if self.weapon then
		self.weapon:defend()
	end
end

--- getHit
--	Getting hit passes a reference to the weapon that hit the player.
--	Can test the swing type of the weapon and defense type of the player to determine damage.
function Player:getHit(weapon)
	print(self.name, "Got hit by ", weapon.name)
end

function Player:weaponClash(weapon, inRange)
	print(self.name, "Weapons clashing with ", weapon.name)
	if inRange then print("in range") end
	self.weapon:clash(inRange)
	weapon:clash()
end

--- Draw the player's sprite (and collision box?)
function Player:draw()
	x,y = self.shape:center()
	--newColor = {128, 155, 155, 255}
	--love.graphics.setColor(newColor)
	--self.shape:draw("fill",16)
	self.animations[self.currentAnimation]:draw(x - self.width/2, y - self.height/2, 0, 1, 1)
end
