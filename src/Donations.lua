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
local screen, webView
local tools = Tools:new()
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    
    -- Background
    local bgScr = display.newRect( midW, 70, intW, h+60 )
    bgScr.anchorY = 0
    bgScr:setFillColor( unpack(cGold) )
    screen:insert(bgScr)

    -- Label Donations
    local labelDonations = display.newText({
        text = "Agradecemos tu donación",
        x = midW,
        y = h+95, width = intW-50,
        font = fMonRegular,
        fontSize = 20, align = "center"
    })
    labelDonations:setFillColor( unpack(cWhite) )
    local posY = 135 + labelDonations.height
    screen:insert( labelDonations )
    
    -- Background
    tools:buildHeader()
    screen:insert(tools)
    
    -- Scrollview
    local bgWb = display.newRect( midW, h + 280, intW, intH - (h + 30) )
    bgWb.anchorY = 0
    bgWb:setFillColor( unpack(cWhite) )
    screen:insert(bgWb)

    
end	

-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then
        -- website url
    	webView = native.newWebView( midW, h + 135, intW, intH - (h + 70) )
        webView.anchorY = 0
        local posY = 135 + webView.height
        webView:request( "donations.html", system.ResourceDirectory )
        screen:insert( webView )
    end
end

-- Remove Listener
function scene:hide( event )
    if webView then
        webView:removeSelf()
        webView = nil
    end
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )


return scene
