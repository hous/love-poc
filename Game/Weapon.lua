require "common"
require "Sprite"

--- Weapon class
--	represents a collidable game entity that can belong to a Player
--	should be a limited number of player sprites, but many weapon sprites, so need to abstract this from player
--	TODO set correct offset of image for resting and swinging
---
Weapon = Class{name = "weapon", inherits = Sprite, function(self, name, sourceFolder, width, height, player)
	x,y = player.shape:center()
	Sprite.construct(self, name, "weapon", sourceFolder, x, y, width, height)
	self.currentAnimation = "restingRight"
	self.speed = 1 --unused
	self.range = 1 --unused
	self.damage = 1 --unused
	self.owner = player
	self.owner.weapon = self
	x,y = self.owner.shape:center()
	self.shape = HC:addRectangle(x,y,math.floor(self.width),math.floor(self.height))
	HC:addToGroup(self.owner.name, self.shape)
	HC:setGhost(self.shape) --weapons start out inactive
	self.shape.parent = self
	self.shape.type = self.type
	self.offset = {}
	self.offset.x = 0
	self.offset.y = 0
	self.isSwinging = false --weapon is swinging and has not clashed with another weapon
	self.isRebounding = false --weapon has clashed with another weapon and is rebounding
	self.collisionResolved = false --Keep track of if a weapon/weapon collision has been resolved
end}

--- Swing
--	Swinging the weapon should create a collidable polygon in front of the player for a certain amount of time.
--	TODO sprites for swingRight and swingLeft
--	TODO use setGhost and setSolid in order to keep the sword on the player but not colliding?
--
function Weapon:swing()
	self.isSwinging = true
	self.collisionResolved = false
	Timer.add(.3, function()
		HC:setSolid(self.shape)
		if self.owner.lastDirection == "right" then
			self.offset.x = 20
			self.offset.y = -5
		else
			self.offset.x = -20
			self.offset.y = -5
		end
		Timer.add(.3, function()
			self.isSwinging = false
			HC:setGhost(self.shape)
			self.offset.x = 0
			self.offset.y = 0
		end)
	end)
end

function Weapon:defend()
	self.isDefending = true
	HC:setSolid(self.shape)
	if self.owner.lastDirection == "right" then
		self.offset.x = 20
		self.offset.y = -5
	else
		self.offset.x = -20
		self.offset.y = -5
	end
	Timer.add(.6, function()
		self.isDefending = false
		HC:setGhost(self.shape)
		self.offset.x = 0
		self.offset.y = 0
	end)
end

--Timer should depend on weapon collision type
--inRange should determine if player gets hurt when on the losing end of a weapon clash
function Weapon:clash(inRange)
	self.isRebounding = true
	HC:setGhost(self.shape)
	if self.owner.lastDirection == "right" then
		self.offset.x = 10
		self.offset.y = -5
	else
		self.offset.x = -10
		self.offset.y = -5
	end
	Timer.add(.6, function()
		self.isRebounding = false
		self.offset.x = 0
		self.offset.y = 0
	end)
	self.collisionResolved = true
end

function Weapon:drop()

end

function Weapon:update(dt)
	x,y = self.owner.shape:center()
	self.shape:moveTo(x,y)
	if(self.owner.lastDirection == "right") then
		self.currentAnimation = "restingRight"
		if self.isSwinging then
			self.currentAnimation = "right"
		elseif self.isDefending then
		elseif self.isRebounding then
		end
		self.shape:move(self.offset.x,self.offset.y)
	else
		self.currentAnimation = "restingLeft"
		if self.isSwinging then
			self.currentAnimation = "left"
		elseif self.isDefending then
		elseif self.isRebounding then
		end
		self.shape:move(self.offset.x,self.offset.y)
	end
	self.animations[self.currentAnimation]:update(dt)
end

function Weapon:draw()
	x,y = self.shape:center()
	--newColor = {0, 155, 155, 255}
	--love.graphics.setColor(newColor)
	--self.shape:draw("fill",16)
	self.animations[self.currentAnimation]:draw(x - self.width/2, y - self.height/2, 0, 1, 1)
end
