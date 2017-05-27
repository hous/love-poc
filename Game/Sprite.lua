require "common"
require "lib/animation"
require "Entity"

--- Sprite class
-- 	@param {string} sourceFolder - path to the sprite's animation spritesheet gifs
-- 		they should be named as [animationType]_[frameWidth]_[frameHeight]_[numFrames].gif
-- 		see setUpAnimationsFromFilenames method below...
Sprite = Class{name = "sprite", inherits = Entity, function(self, name, entityType, sourceFolder, x, y, width, height)
	Entity.construct(self, name, entityType)
	self.sourceFolder = sourceFolder
	self.animations = {}
	self.currentAnimation = "restingRight"
	self.position = {}
	self.position.x = x
	self.position.y = y
	self.width = width
	self.height = height
	self:setUpAnimationsFromFilenames()
end}

--- setUpAnimationsFromFilenames
-- 	checks for spritesheet gifs in the sourcefolder and initializes the animations based on the filename
-- 	format - animationType_frameWidth_frameHeight_totalFrames.gif
-- 	e.g. resting_35_43_4.gif
-- 	There is a photoshop script to automate this
function Sprite:setUpAnimationsFromFilenames()
    if love.filesystem.exists(self.sourceFolder) then
        local filesTable = love.filesystem.getDirectoryItems(self.sourceFolder)
        for i,fileName in pairs(filesTable) do
            local imageFile = self.sourceFolder  .. fileName
            local animationName, frameWidth, frameHeight, totalFrames
            if love.filesystem.isFile(imageFile) then
                local imageParams = fileName:split("_")
                animationName = imageParams[1]
                frameWidth = imageParams[2]
                frameHeight = imageParams[3]
                totalFrames = string.gsub(imageParams[4],".png","")
                local source = love.image.newImageData(imageFile)
                local w, h = source:getWidth(), source:getHeight()
                source = love.graphics.newImage(source)
                self.animations[animationName] = newAnimation(source, frameWidth, frameHeight, FRAME_RATE, totalFrames)
            end
        end
    end
end

--- update the sprite's position and animation - routes params to updatePosition and updateAnimations methods
--	@param xDir enum(-1,0,1) x-direction that the sprite is travelling
--	@param yDir enum(-1,0,1) y-direction that the sprite is travelling
function Sprite:update(dt)
	self.animations[self.currentAnimation]:update(dt)
end

function Sprite:draw()
	self.animations[self.currentAnimation]:draw(self.position.x - self.width/2, self.position.y - self.height/2, 0, 1, 1)
end
