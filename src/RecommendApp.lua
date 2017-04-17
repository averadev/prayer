-- Includes
require( "src.Tools" )
local widget = require( "widget" )
local composer = require( "composer" )
local Globals = require( "src.resources.Globals" )
local DBManager = require( "src.resources.DBManager" )
local RestManager = require( "src.resources.RestManager" )

-- Verified if it simulator
local isSimulator = "simulator" == system.getInfo( "environment" )

if isSimulator then
	native.showAlert( "Build for device", "This plugin is not supported on the Simulator, please build for an iOS/Android device or Xcode simulator", { "OK" } )
end

-- Variables Local
local screen
local tools = Tools:new()
local scene = composer.newScene()
local posY = 0

-- function shareApplication action
function shareApplication( event )
    local serviceName = "facebook"
    local isAvailable = native.canShowPopup( "social", serviceName )
 
    -- If it is possible to show the popup
    if isAvailable then
        local listener = {}
        function listener:popup( event )
            print( "name(" .. event.name .. ") type(" .. event.type .. ") action(" .. tostring(event.action) .. ") limitReached(" .. tostring(event.limitReached) .. ")" )			
        end
 
        -- Show the popup
        native.showPopup( "social",
        {
            service = serviceName,
            message = "Empieza ahora y comparte con todos tus amigos.",
            listener = listener,
            image = 
            {
                { filename = "Icon.png", baseDir = system.ResourceDirectory },
            },
            url = 
            { 
                "https://www.google.com.mx",
            }
        })
    else
        if isSimulator then
        	native.showAlert( "Build for device", "This plugin is not supported", { "OK" } )
        else
        	native.showAlert( "Cannot send message ", { "OK" } )
        end
    end
end

--
function scene:create( event )
	screen = self.view

	local bgSrc = display.newRect( midW, h, intW, intH )
	bgSrc.anchorY = 0
	bgSrc:setFillColor( unpack( cGrayL ) )
	screen:insert( bgSrc )

	-- Background
	tools:buildHeader()
	screen:insert( tools )

	scContainerScroll = widget.newScrollView( {
		top = h + 130,
		left = 0,
		width = intW,
		height = intH - (h + 70),
		horizontalScrollDisabled = true,
		backgroundColor = { unpack(cGrayL) }
	})

	-- Button Back
	local labelBack = display.newText({
		text = "REGRESAR",
		y = h+40,
		x = 460, width = 200,
		font = fMonRegular,
		fontSize = 18, align = "right"
	})
	labelBack.anchorX = 1
	labelBack:setFillColor( unpack(cWhite) )
	labelBack:addEventListener( "tap", toPreviousRight )
	screen:insert( labelBack )

	local bgSrc = display.newRect( midW, h, intW, 400 )
	bgSrc.anchorY = 0
	bgSrc:setFillColor( unpack(cPurple) )

	-- Label Name Author
	local labelNameAuthor = display.newText({
		text = "Recomendar Aplicación",
		x = midW,
		y = h+25, width = intW-50,
		font = fMonRegular,
		fontSize = 20, align = "center"
	})

	--
	local bgShare = display.newRect( midW, h, intW, 200  )
	bgShare.anchorY = 0
	bgShare:addEventListener( 'tap', shareApplication)
	--screen:insert(bgShare)

	labelNameAuthor:setFillColor( unpack(cWhite) )
	scContainerScroll:insert( bgSrc )
	scContainerScroll:insert( labelNameAuthor )
	scContainerScroll:insert( bgShare )
	screen:insert( scContainerScroll )
end

function scene:show( event )
	if event.phase == "will" then 
	end
end

-- Remove Listener Event
function scene:destroy( event )
	--
end

-- Listener Event
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )

-- Return variable scene
return scene