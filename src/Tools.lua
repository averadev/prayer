---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

local composer = require( "composer" )
local Globals = require( "src.Globals" )
require('src.Menu')


Tools = {}
function Tools:new()
    -- Variables
    local self = display.newGroup()
    local bgShadow, iconPlaying
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
        
        iconPlaying = display.newImage("img/iconPlaying.png")
        iconPlaying.alpha = 0
        iconPlaying:translate( intW - 40, 35)
        iconPlaying:addEventListener( 'tap', getPlaying)
        self:insert( iconPlaying )
        
    end
    
    -------------------------------------
    -- Creamos el top bar
    -- @param isWelcome boolean pantalla principal
    ------------------------------------ 
    function self:getIcon()
        iconPlaying.alpha = 1
    end
    
    -- Cambia pantalla
    function getPlaying(event)
        composer.gotoScene("src.Card", { time = 400, effect = "slideLeft", params = { item = idxP } } )
    end
    
    -- Cambia pantalla
    function toMenu(event)
        composer.gotoScene("src.Menu", { time = 400, effect = "slideLeft" } )
        return true
    end
    
    -- Cambia pantalla
    function toScreen(event)
        local t = event.target
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







