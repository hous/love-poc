--
--  Platformer Tutorial
--

local loader = require "AdvTiledLoader/Loader"
-- set the path to the Tiled map files
loader.path = "maps/"

local HC = require "HardonCollider"

local hero
local collider
local allSolidTiles

function love.load()
	
	-- load the level and bind to variable map
	map = loader.load("level.tmx")
	
	-- load HardonCollider, set callback to on_collide and size of 100
	collider = HC(100, on_collide)
	
	-- find all the tiles that we can collide with
	allSolidTiles = findSolidTiles(map)
	
	-- set up the hero object, set him to position 32, 32
	setupHero(32,32)
	
end

function love.update(dt)
	
	-- do all the input and movement
	
	handleInput(dt)
	updateHero(dt)
	
	-- update the collision detection
	
	collider:update(dt)
	
	
end

function love.draw()
	
	-- scale everything 2x
	love.graphics.scale(2,2)
		
	-- draw the level
	map:draw()
	
	-- draw the hero as a rectangle
	hero:draw("fill")
end

function on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
	
	-- seperate collision function for entities
	collideHeroWithTile(dt, shape_a, shape_b, mtv_x, mtv_y)
	
end

function collideHeroWithTile(dt, shape_a, shape_b, mtv_x, mtv_y)
	
	-- sort out which one our hero shape is
	local hero_shape, tileshape
	if shape_a == hero and shape_b.type == "tile" then
		hero_shape = shape_a
	elseif shape_b == her and shape_a.type == "tile" then
		hero_shape = shape_b
	else
		-- none of the two shapes is a tile, return to upper function
		return
	end
	
	-- why not in one function call? because we will need to differentiate between the axis later
	hero_shape:move(mtv_x, 0)
	hero_shape:move(0, mtv_y)
	
end

function setupHero(x,y)
	
	hero = collider:addRectangle(x,y,16,16)
	hero.speed = 50
--	hero.img = love.graphics.newImage("img/hero.png")

end

function handleInput(dt)
	
	if love.keyboard.isDown("left") then
		hero:move(-hero.speed*dt, 0)
	end
	if love.keyboard.isDown("right") then
		hero:move(hero.speed*dt, 0)		
	end
	if love.keyboard.isDown("up") then
		
	end
	
end

function updateHero(dt)
	
	-- apply a downward force to the hero (=gravity)
	hero:move(0,dt*50)
	
end

function findSolidTiles(map)
	
	local collidable_tiles = {}
	
	-- get the layer that the tiles are on by name
	local layer = map.tl["ground"]
	
	for tileX=1,map.width do
		for tileY=1,map.height do
			
			local tile
			
			if layer.tileData[tileY] then
				tile = map.tiles[layer.tileData[tileY][tileX]]
			end
			
			if tile and tile.properties.solid then
				local ctile = collider:addRectangle((tileX-1)*16,(tileY-1)*16,16,16)
				ctile.type = "tile"
				collider:addToGroup("tiles", ctile)
				collider:setPassive(ctile)
				table.insert(collidable_tiles, ctile)
			end
			
		end
	end
	
	return collidable_tiles
end