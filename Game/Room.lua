require "common"

-- Advanced Tiled Loader (map/level loading library)
TILED_LOADER_PATH = "lib/AdvTiledLoader/"
local loader = require "lib/AdvTiledLoader/Loader"
loader.path = "maps/"


Room = {}
Room.__index = Room

--[[
 - Generate a new room based on a Tiled file "filename.tmx"
 -]]
function Room.Create(mapFile)
    local table = {
        ["map"] = loader.load(mapFile)
    }
    setmetatable( table, Room )
    return table
end

function Room:findSolidTiles(collider)
    local collidable_tiles = {}

    local layer = self.map.tl["ground"]

    for tileX=1,self.map.width do
        for tileY=1,self.map.height do

            local tile
            if layer.tileData[tileY] then
                tile = self.map.tiles[layer.tileData[tileY][tileX]]
            end

            if tile and (tile.properties.solid or tile.tileset.tileProperties.solid) then
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
