-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local function gotoGame()
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

local function gotoSettings()
	composer.gotoScene( "settings", { time=800, effect="crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
	local sceneGroup = self.view

	local background = display.newImageRect( sceneGroup, "spaceBackground.png", 1080, 1920 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local startButton = display.newImageRect( sceneGroup, "startButton.png", 200, 50 )
	startButton.x = display.contentCenterX
	startButton.y = display.contentCenterY
	startButton:addEventListener( "tap", gotoGame )

	local settingsButton = display.newImageRect( sceneGroup, "settingsButton.png", 40, 40 )
	settingsButton.x = 280
	settingsButton.y = 0
	settingsButton:addEventListener( "tap", gotoSettings )
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
