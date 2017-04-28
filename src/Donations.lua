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
    
    local bgScr = display.newRect( midW, 70, intW, intH )
    bgScr.anchorY = 0
    bgScr:setFillColor( gradientGold )
    screen:insert(bgScr)

    -- Label Donations
    local labelDonations = display.newText({
        text = "¡Quiero Donar!\n\n¡Hola Amigo! te agradezco el interés en poder ayudar, que día con día se esfuerza para ser mejor especialmente para tí, agradecemos enormemente el que nos puedas ayudar, ¡Mil Gracias!",
        x = midW,
        y = 200, width = 400,
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
    	webView = native.newWebView( midW, h + 320, intW, intH - (h + 70) )
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
