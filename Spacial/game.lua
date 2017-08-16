local composer = require( "composer" )
local scene = composer.newScene()
local physics = require( "physics" )
system.activate( "multitouch" )
physics.start()
physics.setGravity(0,0)



-- VIRTUAL JOYSTICK CONTROLLER CODE
----------------------------------------------------------------------------------------
-- local controller = require("controller.joystick.setup_joystick")
-- controller:createController()
----------------------------------------------------------------------------------------
-- END VIRTUAL JOYSTICK CONTROLLER CODE

-- TOUCHSCREEN CONTROLLER CODE
----------------------------------------------------------------------------------------
-- local controller = require("controller.touchscreen.touch_controller")
-- controller:createController()
----------------------------------------------------------------------------------------
-- END TOUCHSCREEN CONTROLLER CODE

-- -----------------------------------------------------------------------------------
-- Gravity
-- -----------------------------------------------------------------------------------
local function collideWithField( self, event )
    local objectToPull = event.other

    if ( event.phase == "began" and objectToPull.touchJoint == nil ) then
        -- Create touch joint after short delay (10 milliseconds)
        timer.performWithDelay( 10,
            function()
                -- Create touch joint
                objectToPull.touchJoint = physics.newJoint( "touch", objectToPull, objectToPull.x, objectToPull.y )
                -- Set physical properties of touch joint
                objectToPull.touchJoint.frequency = fieldPower
                objectToPull.touchJoint.dampingRatio = 0.0
                -- Set touch joint "target" to center of field
                objectToPull.touchJoint:setTarget( self.x, self.y )
            end
        )
    elseif ( event.phase == "ended" and objectToPull.touchJoint ~= nil ) then
        objectToPull.touchJoint:removeSelf()
        objectToPull.touchJoint = nil
    end
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()  -- Temporarily pause the physics engine

	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )  -- Insert into the scene's view group

	mainGroup = display.newGroup()  -- Display group for the ship, planets, etc.
	sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )    -- Insert into the scene's view group

	-- Load the background
	background = display.newImageRect( backGroup, "spaceBackground.png", 1080, 1920)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

  -- Load controllers
  if(controllerType == "Joystick") then
    local controller = require("controller.joystick.setup_joystick")
    controller:createController()
    controller:setupController(uiGroup)
  elseif (controllerType == "Touchscreen") then
    local controller = require("controller.touchscreen.touch_controller")
    controller:createController()
    background:addEventListener("touch", moveShipListener)
    Runtime:addEventListener("enterFrame", handleEnterFrame)
  end

  -- Load the ship
  ship = display.newImageRect( mainGroup, "spaceShip.png", 17, 35)
  ship.x = display.contentCenterX
  ship.y = display.contentCenterY + 200
  physics.addBody(ship,  "dynamic", {radius=17, density = 10})
  ship.myName = "ship"

 -- Load planet
  planet = display.newImageRect( mainGroup, "planetImage.png", 65, 65)
  planet.x = display.contentCenterX
  planet.y = display.contentCenterY
  physics.addBody(planet, "static", {radius = 32})
  planet.myName = "planet"

  fieldPower = 0.2
  field = display.newCircle(mainGroup, planet.x, planet.y, 100)
  field.alpha = 0.2
  -- Add physical body (sensor) to field
  physics.addBody( field, "static", { isSensor=true, radius=fieldRadius } )
  field.collision = collideWithField
  field:addEventListener( "collision" )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
    if (controllerType == "Touchscreen") then
      Runtime:addEventListener( "enterFrame", handleEnterFrame )
    end
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		physics.pause()
		composer.removeScene( "game" )
    if (controllerType == "Touchscreen") then
      Runtime:removeEventListener( "enterFrame", handleEnterFrame )
    end
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
  -- controller = nil
end
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
return scene
