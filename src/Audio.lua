---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

local widget = require( "widget" )
local composer = require( "composer" )
local Globals = require( "src.resources.Globals" )
local Sprites = require('src.resources.Sprites')
require('src.Menu')


Audio = {}
function Audio:new()
    -- Variables
    local self = display.newGroup()
    self.y = h
    
    
    -------------------------------------
    -- Creamos seccion Audio
    -- @param item objeto audio
    ------------------------------------ 
    function self:build(item)
        
        local sc = widget.newScrollView(
        {
            top = 130,
            left = 0,
            width = intW,
            height = intH - (h + 70),
            horizontalScrollDisabled = true,
            backgroundColor = { unpack(cGrayL) }
        })
        self:insert(sc)

        -- Actions
        local bgAct = display.newRect( midW, 0, intW, 70 )
        bgAct.anchorY = 0
        bgAct:setFillColor( unpack(cPurpleH) )
        sc:insert(bgAct)
        
        function doDown(event)
            if event.target.isActive then
                event.target.isActive = false
                event.target:setSequence("false")
            else
                event.target.isActive = true
                event.target:setSequence("true")
            end
        end
        
        function doFav(event)
            if event.target.isActive then
                event.target.isActive = false
                event.target:setSequence("false")
            else
                event.target.isActive = true
                event.target:setSequence("true")
            end
        end
        
        local lblDetail
        local grpBar
        function showBar(event)
            transition.to( lblDetail, { y = lblDetail.y + 70, time = 500 })
            transition.to( grpBar, { alpha = 1, time = 500 })
        end
        
        local sheetD = graphics.newImageSheet(Sprites.down.source, Sprites.down.frames)
        local iconDown = display.newSprite(sheetD, Sprites.down.sequences)
        iconDown.x = intW - 120
        iconDown.y = 35
        iconDown.isActive = false
        iconDown:addEventListener( 'tap', doDown)
        sc:insert(iconDown)
        
        local sheetF = graphics.newImageSheet(Sprites.fav.source, Sprites.fav.frames)
        local iconFav = display.newSprite(sheetF, Sprites.fav.sequences)
        iconFav.x = intW - 45
        iconFav.y = 35
        iconFav.isActive = false
        iconFav:addEventListener( 'tap', doFav)
        sc:insert(iconFav)

        if item.down then
            iconDown.isActive = true
            iconDown:setSequence("true")
        end
        if item.fav then
            iconFav.isActive = true
            iconFav:setSequence("true")
        end

        -- Desc Section
        local bgDesc = display.newRect( midW, 70, intW, 170 )
        bgDesc.anchorY = 0
        bgDesc:setFillColor( unpack(cPurple) )
        sc:insert(bgDesc)

        local lblDescDate = display.newText({
            text = item.noDate..' de '..item.month,
            y = 105,
            x = midW, width = 400,
            font = fMonRegular, 
            fontSize = 26, align = "left"
        })
        lblDescDate:setFillColor( unpack(cWhite) )
        sc:insert(lblDescDate)

        local lblDescTitle = display.newText({
            text = item.title,
            y = 130,
            x = midW, width = 400,
            font = fMonRegular, 
            fontSize = 26, align = "left"
        })
        lblDescTitle.anchorY = 0
        lblDescTitle:setFillColor( unpack(cWhite) )
        sc:insert(lblDescTitle)
        
        local posY = 130 + lblDescTitle.height

        local lblDescSubTitle = display.newText({
            text = item.subtitle,
            y = posY,
            x = midW, width = 400,
            font = fMonRegular, 
            fontSize = 18, align = "left"
        })
        lblDescSubTitle.anchorY = 0
        lblDescSubTitle:setFillColor( unpack(cWhite) )
        sc:insert(lblDescSubTitle)
        
        posY = posY + lblDescSubTitle.height + 20
        bgDesc.height = posY - 20
        
        -- Section Play
        local bgPlay = display.newRect( midW, posY, intW, 100 )
        bgPlay.anchorY = 0
        bgPlay:setFillColor( unpack(cWhite) )
        sc:insert(bgPlay)

        local iconHPlay = display.newImage("img/iconHPlay.png")
        iconHPlay:translate(midW, posY + 50)
        iconHPlay:addEventListener( 'tap', showBar)
        sc:insert( iconHPlay )

        local iconPArrowL = display.newImage("img/iconPDArrow.png")
        iconPArrowL:translate(midW - 110, posY + 50)
        sc:insert( iconPArrowL )

        local iconPArrowR = display.newImage("img/iconPDArrow.png")
        iconPArrowR:translate(midW + 110, posY + 50)
        iconPArrowR.rotation = 180
        sc:insert( iconPArrowR )
        
        -- Progress Bar
        grpBar = display.newGroup()
        grpBar.alpha = 0
        sc:insert(grpBar)
        local bgBar = display.newRect( midW, posY+100, intW, 70 )
        bgBar.anchorY = 0
        bgBar:setFillColor( unpack(cPurpleH) )
        grpBar:insert(bgBar)

        local lblBarTCurrent = display.newText({
            text = '00.00',
            y = posY+140,
            x = midW-165, width = 100,
            font = fMonRegular, 
            fontSize = 18, align = "left"
        })
        lblBarTCurrent:setFillColor( unpack(cWhite) )
        grpBar:insert(lblBarTCurrent)

        local lblBarTTotal = display.newText({
            text = '45.00',
            y = posY+140,
            x = midW+165, width = 100,
            font = fMonRegular, 
            fontSize = 18, align = "right"
        })
        lblBarTTotal:setFillColor( unpack(cWhite) )
        grpBar:insert(lblBarTTotal)

        local bgBarT = display.newRect( midW, posY+140, 300, 1 )
        bgBarT.anchorY = 0
        bgBarT:setFillColor( unpack(cWhite) )
        grpBar:insert(bgBarT)

        local bgBarC = display.newRect( 90, posY+140, 120, 1 )
        bgBarC.anchorX = 0
        bgBarC.anchorY = 0
        bgBarC:setFillColor( unpack(cPurple) )
        grpBar:insert(bgBarC)
        
        -- Section Detail
        posY = posY + 100
        lblDetail = display.newText({
            text = item.detail,
            y = posY + 20,
            x = midW, width = 420,
            font = fMonRegular, 
            fontSize = 14, align = "left"
        })
        lblDetail.anchorY = 0
        lblDetail:setFillColor( unpack(cPurple) )
        sc:insert(lblDetail)
        
    end
    
    return self
end







