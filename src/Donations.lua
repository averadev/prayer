---------------------------------------------------------------------------------
-- Oraciones
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Tools')
local widget = require( "widget" )
local composer = require( "composer" )
local Globals = require( "src.resources.Globals" )
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local screen
local tools = Tools:new()
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    
    local bgScr = display.newRect( midW, h, intW, intH )
    bgScr.anchorY = 0
    bgScr:setFillColor( gradientGold )
    screen:insert(bgScr)

    -- Label Donations
    local labelDonations = display.newText({
        text = "Hacer una donación",
        x = midW,
        y = h+95, width = intW-50,
        font = fMonRegular,
        fontSize = 20, align = "center"
    })
    labelDonations:setFillColor( unpack(cWhite) )
    screen:insert( labelDonations )
    
    -- Background
    tools:buildHeader()
    screen:insert(tools)
    
    -- Scrollview
    scCalendar = widget.newScrollView(
    {
        top = h + 130,
		left = 0,
        width = intW,
        height = intH - (h + 70),
		horizontalScrollDisabled = true,
		backgroundColor = { unpack(cGrayL) }
    })

    -- website url
    local urlSite = "https://www.paypal.com/mx/home"
    local webView = native.newWebView( midW, 20, 440, intH - (h + 30) )
    webView.anchorY = 0
    local posY = 135 + webView.height
    scCalendar:setScrollHeight( webView.height + posY + 30 )
    webView:request( urlSite )
    scCalendar:insert( webView )

    screen:insert(scCalendar)
    
end	

-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then
    	
    end
end

-- Remove Listener
function scene:destroy( event )
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )


return scene
