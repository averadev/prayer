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

    -- Label Description Donations
    local labelDescDonations = display.newText({
        text = "Lorem ipsum dolor sit amet, sint nostrud splendide in eam, laudem conclusionemque cu sea. Qui dolor posidonium et. Primis iuvaret nominati eos te, duo at nostro prompta consequuntur. Duis dolores ex quo.\n\nEu nisl mollis eripuit vim. Eum eu corrumpit intellegat. Nam dicat concludaturque ex, sea at affert congue. Te sit lorem dicat etiam, exerci nostro albucius sea ei. Te melius mentitum suscipiantur sed. Hinc assueverit ad usu.\n\nQuis ignota epicuri ei vim, te abhorreant constituam qui.\n\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        x = midW, width = 420,
        y = 20,
        font = fMonRegular,
        fontSize = 16, align = "left"
    })
    labelDescDonations.anchorY = 0
    local posY = 135 + labelDescDonations.height
    scCalendar:setScrollHeight( labelDescDonations.height + posY + 100 )

    labelDescDonations:setFillColor( unpack( cBlack ) )
    scCalendar:insert( labelDescDonations )

    screen:insert(scCalendar)
    local webView = native.newWebView( display.contentCenterX, display.contentCenterY, 480, 680 )
	webView:request( "https://www.paypal.com/" )
    
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
