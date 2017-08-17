Planet = {}
Planet.__index = Planet

local defaultSize = 65
local fieldPower = 0.2
local fieldDamping = 0.4
local fieldRadius = defaultSize * 2

function Planet:new(aX, aY)
  local newPlanet = {}
  setmetatable(newPlanet, newPlanet)

  newPlanet.visualPlanet = display.newImageRect(mainGroup, "planetImage.png", defaultSize, defaultSize)
  newPlanet.visualPlanet.x = aX
  newPlanet.visualPlanet.y = aY
  physics.addBody( newPlanet.visualPlanet, "static", {radius = defaultSize / 2})

  newPlanet.field = display.newCircle(mainGroup, aX, aY, fieldRadius)
  newPlanet.field.alpha = 0.2
  -- Add physical body (sensor) to field
  physics.addBody( newPlanet.field, "static", { isSensor=true, radius = fieldRadius} )
  newPlanet.field.collision = collideWithField
  newPlanet.field:addEventListener( "collision" )
  return newPlanet
end

function collideWithField( self, event )
    local objectToPull = event.other

    if ( event.phase == "began" and objectToPull.touchJoint == nil ) then
        -- Create touch joint after short delay (10 milliseconds)
        timer.performWithDelay( 10,
            function()
                -- Create touch joint
                objectToPull.touchJoint = physics.newJoint( "touch", objectToPull, objectToPull.x, objectToPull.y )
                -- Set physical properties of touch joint
                objectToPull.touchJoint.frequency = fieldPower
                objectToPull.touchJoint.dampingRatio = fieldDamping
                -- Set touch joint "target" to center of field
                objectToPull.touchJoint:setTarget( self.x, self.y )
            end
        )
    elseif ( event.phase == "ended" and objectToPull.touchJoint ~= nil ) then
        objectToPull.touchJoint:removeSelf()
        objectToPull.touchJoint = nil
    end
end
