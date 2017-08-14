-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
local physics = require( "physics" )
local needToMove = false
-- Set Variables
 _W = display.contentWidth; -- Get the width of the screen
 _H = display.contentHeight; -- Get the height of the screen
 _MAX_FORCE = 0.0009
 _FORCE_FACTOR = 0.0001
-- motionx = 0; -- Variable used to move character along x axis
--speed = 2; -- Set moving speed

physics.start()
physics.setGravity(0,0)

local force = 0;
local function moveShip( event )
    force = force + _FORCE_FACTOR
    if force >= _MAX_FORCE then
      force = _MAX_FORCE
    end

    ship:rotate(side * 2)

    local rotation = math.rad(ship.rotation)
    local xPart = math.sin(rotation)
    local yPart = math.cos(rotation)
    print( "x: " .. xPart .. " y: " .. yPart )
    ship:applyLinearImpulse( force * xPart, -force * yPart, ship.x, ship.y )
    --print(ship.y)
end

local function handleEnterFrame( event )
    if ( needToMove == true ) then
        moveShip( event )
    end
end

local function moveShipListener(event)
    local ship = event.target
    local phase = event.phase

    if (event.x >= _W/2) then
      side = 1
    else
      side = -1
    end

    if ( "began" == phase ) then
        needToMove = true
    elseif ( "ended" == phase or "cancelled" == phase ) then
        needToMove = false
    end
    return true
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

  -- Load the ship
  ship = display.newImageRect( mainGroup, "spaceShip.png", 17, 35)
  ship.x = display.contentCenterX
  ship.y = display.contentCenterY + 200
  physics.addBody(ship, "dynamic", {radius=17})
  ship.myName = "ship"

 -- Load planet
  planet = display.newImageRect( mainGroup, "planetImage.png", 65, 65)
  planet.x = display.contentCenterX
  planet.y = display.contentCenterY
  physics.addBody(planet, "static", {radius = 35})
  planet.myName = "planet"

  background:addEventListener("touch", moveShipListener)
  Runtime:addEventListener("enterFrame", handleEnterFrame)
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
    Runtime:addEventListener( "enterFrame", handleEnterFrame )
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
    Runtime:removeEventListener( "enterFrame", handleEnterFrame )
		composer.removeScene( "game" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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
