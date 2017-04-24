---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

local composer = require( "composer" )
local Sprites = require('src.resources.Sprites')
local Globals = require( "src.resources.Globals" )
require('src.Menu')


Tools = {}
function Tools:new()
    -- Variables
    local self = display.newGroup()
	local grpLoading
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
        
        local isIOS = "ios" == system.getInfo( "platform" )

        if isIOS then
            local toolbar = display.newRect( 0, 0, h+0.9, display.contentWidth, 70 )
            toolbar.anchorX = 0
            toolbar.anchorY = 0
            toolbar.alpha = 1
            toolbar:setFillColor( unpack(cBlack) )
            self:insert(toolbar)
        else
            local toolbar = display.newRect( 0, 0, display.contentWidth, 70 )
            toolbar.anchorX = 0
            toolbar.anchorY = 0
            toolbar.alpha = 1
            toolbar:setFillColor( unpack(cBlack) )
            self:insert(toolbar)
        end

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

        -- current How To Pray
        if composer.getSceneName( "current" ) == "src.HowToPray" then
            local iconMenuCal = display.newImage("img/iconMenuCal.png")
            iconMenuCal:translate(110, 35)
            iconMenuCal.screen = "Calendar"
            iconMenuCal.animation = 'slideRight'
            iconMenuCal:addEventListener( "tap", toScreen)
            self:insert( iconMenuCal )
        end

        -- current Donations
        if composer.getSceneName( "current" ) == "src.Donations" then
            local iconMenuCal = display.newImage("img/iconMenuCal.png")
            iconMenuCal:translate( 110, 35 )
            iconMenuCal.screen = "Calendar"
            iconMenuCal.animation = "slideRight"
            iconMenuCal:addEventListener( "tap", toScreen )
            self:insert( iconMenuCal )
        end

        -- current Buy Book
        if composer.getSceneName( "current" ) == "src.BuyBook" then
            local iconMenuCal = display.newImage("img/iconMenuCal.png")
            iconMenuCal:translate( 110, 35)
            iconMenuCal.screen = "Calendar"
            iconMenuCal.animation = "slideRight"
            iconMenuCal:addEventListener( "tap", toScreen )
            self:insert( iconMenuCal )
        end

        -- current Author
        if composer.getSceneName( "current" ) == "src.Author" then
            local iconMenuCal = display.newImage("img/iconMenuCal.png")
            iconMenuCal:translate( 110, 35 )
            iconMenuCal.screen = "Calendar"
            iconMenuCal.animation = "slideRight"
            iconMenuCal:addEventListener( "tap", toScreen )
            self:insert( iconMenuCal )
        end
        
        iconPlaying = display.newImage("img/iconPlaying.png")
        iconPlaying.alpha = 0
        iconPlaying:translate( intW - 40, 35)
        iconPlaying:addEventListener( 'tap', getPlaying)
        self:insert( iconPlaying )
        
    end
    
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

    function toPreviousRight(event)
        local t = event.target
        composer.gotoScene(composer.getSceneName( "previous" ), { time = 400, effect = 'slideRight' } )
        return true
    end
    
	 -------------------------------------
    -- Creamos el cargando ( loading )
    -- @param isWelcome boolean pantalla principal
    ------------------------------------ 
	function self:setLoading( isLoading, parent )
        if isLoading then
            if grpLoading then
                grpLoading:removeSelf()
                grpLoading = nil
            end
            grpLoading = display.newGroup()
            parent:insert(grpLoading)
            
            local bg = display.newRect( midW, (parent.height / 2), intW, intH )
            bg:setFillColor( .95 )
            bg.alpha = .3
            grpLoading:insert(bg)
			bg:addEventListener( 'tap', noAction )
            
            local sheet, loading
          
			sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
            loading = display.newSprite(sheet, Sprites.loading.sequences)
           
            loading.x = display.contentWidth / 2
            loading.y = -75
			loading.anchorY = 1
            grpLoading:insert(loading)
            loading:setSequence("play")
            loading:play()
        else
            if grpLoading then
                grpLoading:removeSelf()
                grpLoading = nil
            end
        end
    end
	
	function noAction( )
		return true
	end
	
    return self
end







