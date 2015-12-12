require "common"
require "Game"

--- Entity class
--	represents any collidable game entity
Entity = Class{function(self, name, entityType)
	self.name = name
	self.type = entityType
	print("Registering",self,"named: ",name," of type:", entityType)
	game:register(self, name)
end}
