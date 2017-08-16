local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
	local sceneGroup = self.view

	local background = display.newImageRect( sceneGroup, "spaceBackground.png", 1080, 1920 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY


	local statusText = display.newText( "Interact with a Widget...\n", 0, 385, 190, 0, native.systemFont, 14 )
	statusText:setFillColor( 1,1 )
	statusText.anchorX = 0
	statusText.x = 100
	sceneGroup:insert( statusText )


	local function radioSwitchListener( event )
		statusText.text = event.target.id .. "\nswitch.isOn = " .. tostring( event.target.isOn )
	end

	local radioButton1 = widget.newSwitch {
	    left = 25,
	    top = 180,
	    style = "radio",
	    id = "Radio Switch 1",
	    initialSwitchState = true,
	    onPress = radioSwitchListener,
	}
	local radioButtonText = display.newText( "Joystick", 120, 200, native.systemFont, 16 )
	radioButtonText:setFillColor( 1,1 )
	sceneGroup:insert( radioButtonText )
	sceneGroup:insert( radioButton1 )
	radioButton1.x = 70
	radioButton1.y = 200

	local radioButton2 = widget.newSwitch {
	    left = 55,
	    top = 180,
	    style = "radio",
	    id = "Radio Switch 2",
	    onPress = radioSwitchListener,
	}
	local radioButtonText = display.newText( "Touchscreen", 140, 250, native.systemFont, 16 )
	radioButtonText:setFillColor( 1,1 )
	sceneGroup:insert( radioButtonText )
	sceneGroup:insert( radioButton2 )
	radioButton2.x = 70
	radioButton2.y = 250

end

-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
	end
end


-- hide()
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
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
