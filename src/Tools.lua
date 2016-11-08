---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

local widget = require( "widget" )
local composer = require( "composer" )
local Globals = require( "src.Globals" )
local Sprites = require('src.Sprites')
require('src.Menu')


Tools = {}
function Tools:new()
    -- Variables
    local self = display.newGroup()
    local bgShadow
    self.y = h
    
    -------------------------------------
    -- Creamos el top bar
    -- @param isWelcome boolean pantalla principal
    ------------------------------------ 
    function self:buildHeader(isWelcome)
        
        bgShadow = display.newRect( 0, 0, display.contentWidth, display.contentHeight - h )
        bgShadow.alpha = 0
        bgShadow.anchorX = 0
        bgShadow.anchorY = 0
        bgShadow:setFillColor( 0 )
        self:insert(bgShadow)
        
        local toolbar = display.newRect( 0, 0, display.contentWidth, 70 )
        toolbar.anchorX = 0
        toolbar.anchorY = 0
        toolbar.alpha = .9
        toolbar:setFillColor( unpack(cPurple) )
        self:insert(toolbar)

        local iconMenu = display.newImage("img/iconMenu.png")
        iconMenu:translate(40, 35)
        iconMenu.screen = "Menu"
        iconMenu.animation = 'slideRight'
        iconMenu:addEventListener( 'tap', toScreen)
        self:insert( iconMenu )

        if composer.getSceneName( "current" ) == "src.Card" then
            local iconMenuCal = display.newImage("img/iconMenuCal.png")
            iconMenuCal:translate(110, 35)
            iconMenuCal.screen = "Calendar"
            iconMenuCal.animation = 'slideRight'
            iconMenuCal:addEventListener( 'tap', toScreen)
            self:insert( iconMenuCal )
        end 
        
    end
    
    -- Cambia pantalla
    function toMenu(event)
        composer.gotoScene("src.Menu", { time = 400, effect = "slideLeft" } )
        return true
    end
    
    -- Cambia pantalla
    function toScreen(event)
        local t = event.target
        if t.screen == "Card" then 
            composer.removeScene( "src."..t.screen ) 
        end
        composer.gotoScene("src."..t.screen, { time = 400, effect = t.animation, params = { item = t.item } } )
        return true
    end
    
    -- Cambia pantalla
    function toPrevious(event)
        local t = event.target
        composer.gotoScene(composer.getSceneName( "previous" ), { time = 400, effect = 'slideLeft' } )
        return true
    end
    
    return self
end







