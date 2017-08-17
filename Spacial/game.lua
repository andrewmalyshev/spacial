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
  require("spaceobjects.planet")
  planet = Planet:new(display.contentCenterX, display.contentCenterY)

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
