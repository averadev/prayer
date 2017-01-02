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
require('src.resources.Globals')
local widget = require( "widget" )
local composer = require( "composer" )
local Sprites = require('src.resources.Sprites')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local screen, grpDays
local tools = Tools:new()
local scene = composer.newScene()
local groupLoading

-- Variables
local cards = {}
local control = {}
local isReady = true
local bgPrev, bgNext, imgPrev, imgNext
local tmrPlaying, jumpProgress

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-------------------------------------
-- Carga los audios 
------------------------------------
function returnAudioCard( items )

	for i = 1, #items, 1 do
		local item = items[i]
        local liked = false
        local descargado = false
        if (item.fav == 1) then
            liked = true
        end
        if (item.downloaded == 1) then
            descargado = true
        end
        print(item.audio)
		lstDays[i] = {
            id_day = item.id_day,
            day = item.weekday,
            noDate = item.day,
            month = item.month,
            date = item.day_date,
            title = item.day_shortdesc,
            subtitle = item.day_shortdesc,
            file = item.audio,
            fav = liked,
            downloaded = descargado,
            detail = item.day_longdesc
        }
	end
	
	createNavigationPlay()
	
end

function deleteFile(event)
   print('Eliminando '..event.target.id_day)
end


--- funcion para descargar el archivo
function dowloadFile(event)
    local params = {}
    params.progress = true

    network.download(
        "http://geekbucket.com.mx/prayer_ws/assets/audios/"..event.target.file,
        "GET",
        networkListener,
        params,
        event.target.file,
        system.TemporaryDirectory
    )
end

function networkListener( event )
    local dw = false
    if ( event.isError ) then
        print( "Network error - download failed: ", event.response )
    elseif ( event.phase == "began" ) then
        print( "Progress Phase: began" )
    elseif ( event.phase == "ended" ) then
        dw = true
        btndowload:setSequence("downloaded")
    end
    return dw
end

function cloudIcon(item)
    
    local sheet, loading
    sheet = graphics.newImageSheet(Sprites.downloaded.source, Sprites.downloaded.frames)
    btndowload = display.newSprite(sheet, Sprites.downloaded.sequences)

    btndowload.x = intW - 120
    btndowload.y = 58
    btndowload.anchorY = 1
    btndowload.id_day = item.id_day
    btndowload.posicion =  cards[idxC]
    
    if item.downloaded then
        btndowload:addEventListener( 'tap', deleteFav)
        cards[idxC]:insert(btndowload)
        btndowload:setSequence("downloaded")
    else
        btndowload:setSequence("cloud")
        cards[idxC]:insert(btndowload)
    end
    btndowload.isActive = item.downloaded
    btndowload.file = item.file
    btndowload:addEventListener( 'tap', saveDowloaded)
end
function saveDowloaded(event)
    if event.target.isActive then
        event.target.isActive = false
    else
        event.target.isActive = true
        id = event.target.id_day
        posicion = event.target.posicion
        dowloadFile(event)
        RestManager.saveDowloaded(id)
    end
end


function favIcon(item)
    local sheet, loading
    sheet = graphics.newImageSheet(Sprites.liked.source, Sprites.liked.frames)
    btndislike = display.newSprite(sheet, Sprites.liked.sequences)

    btndislike.x = intW - 45
    btndislike.y = 58
    btndislike.anchorY = 1
    btndislike.id_day = item.id_day
    btndislike.posicion =  cards[idxC]
    
    if item.fav then
        btndislike:addEventListener( 'tap', deleteFav)
        cards[idxC]:insert(btndislike)
        btndislike:setSequence("like")
    else
        btndislike:setSequence("dislike")
        cards[idxC]:insert(btndislike)
    end
    btndislike.isActive = item.fav
    btndislike:addEventListener( 'tap', saveFav)
end

function saveFav(event)
    if event.target.isActive then
        event.target.isActive = false
        event.target:setSequence("dislike")
        btndislike:setSequence("dislike")
        id = event.target.id_day
        posicion = event.target.posicion
        RestManager.deleteFav(id)
    else
        event.target.isActive = true
        event.target:setSequence("like")
        btndislike:setSequence("like")
        id = event.target.id_day
        posicion = event.target.posicion
        RestManager.saveFav(id)
    end
end
function deleteFav(event)
    btndislike:setSequence("dislike")
    btndislike:removeEventListener("tap", deleteFav)
    id = event.target.id_day
    posicion = event.target.posicion
    RestManager.deleteFav(id)
end
-------------------------------------
-- Mueve la navegacion
------------------------------------
function moveNav()
    bgPrev.alpha = 1
    imgPrev.alpha = 1
    bgNext.alpha = 1
    imgNext.alpha = 1
    if idxC == 1 then
        bgPrev.alpha = 0
        imgPrev.alpha = 0
        if #lstDays == 1 then
            bgNext.alpha = 0
            imgNext.alpha = 0
        end
    elseif idxC == #lstDays then
        bgNext.alpha = 0
        imgNext.alpha = 0
    end 
end

-------------------------------------
-- Anterior tarjeta
-- @param item objeto
------------------------------------
function prevCard()
    if isReady then
        isReady = false
        idxC = idxC - 1
        -- Create card
        if not(cards[idxC]) then
            getCard()
        end
        -- Move Elements
        moveNav()
        cards[idxC].x = -240
        local xDays = grpDays.x + 160
        transition.to( grpDays, { x = xDays, time = 600})
        transition.to( cards[idxC], { x = 240, time = 600})
        transition.to( cards[idxC+1], { x = 720, time = 600})
        timer.performWithDelay( 700, function() isReady = true end )
    end
end

-------------------------------------
-- Siguiente tarjeta
-- @param item objeto
------------------------------------
function nextCard()
    if isReady then
        isReady = false
        idxC = idxC + 1
        -- Create card
        if not(cards[idxC]) then
            getCard()
        end
        -- Move Elements
        moveNav()
        cards[idxC].x = 720
        local xDays = grpDays.x - 160
        transition.to( grpDays, { x = xDays, time = 600})
        transition.to( cards[idxC], { x = 240, time = 600})
        transition.to( cards[idxC-1], { x = -240, time = 600})
        timer.performWithDelay( 700, function() isReady = true end )
    end
end


function pauseAudio()
    timer.cancel(tmrPlaying)
    control[idxP].audio:pause()
    control[idxP].play.alpha = 1
    control[idxP].pause.alpha = 0
end


function prevAudio()
    if (cntTime - 5) < 0 then
        cntTime = 0
    else
        cntTime = cntTime - 5
    end
    control[idxP].audio:seek( cntTime )
    control[idxP].lblBarTCurrent.text = secondsToClock(cntTime)
    control[idxP].bgBarC.width = (jumpProgress*cntTime)
end

-------------------------------------
-- Obtiene tarjeta
------------------------------------
function nextAudio()
    if (cntTime + 5) > curTime then
        cntTime = curTime
    else
        cntTime = cntTime + 5
    end
    control[idxP].audio:seek( cntTime )
    control[idxP].lblBarTCurrent.text = secondsToClock(cntTime)
    control[idxP].bgBarC.width = (jumpProgress*cntTime)
end

function setEventosBotones()
    control[idxC].prev.alpha = 1
    control[idxC].next.alpha = 1
    control[idxC].prev:addEventListener( 'tap', prevAudio)
    control[idxC].next:addEventListener( 'tap', nextAudio)
end

function playAudio(event)
    setEventosBotones()

    if control[idxC].audio then
        control[idxP].audio:play()
        control[idxP].play.alpha = 0
        control[idxP].pause.alpha = 1
        tmrPlaying = timer.performWithDelay( 1000, lstPlaying, 0 ) 
    else
        -- Destroy prev audio
        if control[idxP] then
            if control[idxP].audio then
                timer.cancel(tmrPlaying)
                control[idxP].audio:removeSelf()
                control[idxP].audio = nil
                control[idxP].play.alpha = 1
                control[idxP].pause.alpha = 0
                control[idxP].loading.alpha = 0
                control[idxP].loading:setSequence("stop")
                control[idxP].grpProg.alpha = 0
                control[idxP].lblDetail.y = control[idxP].lblDetail.y - 70
                if tmrPlaying then
                    timer.cancel(tmrPlaying)
                end
            end
        end
        
        idxP = idxC
        tools:getIcon()
        control[idxP].play.alpha = 0
        control[idxP].lblBarTTotal.text = '00:00'
        control[idxP].lblBarTCurrent.text = '00:00'
        control[idxP].bgBarC.width = 1
        control[idxP].loading.alpha = 1
        control[idxP].loading:setSequence("play")
        control[idxP].loading:play()

        -- Move Elements
        local descY = control[idxP].lblDetail.y
        transition.to(  control[idxP].grpProg, { alpha = 1, time = 400 })
        transition.to(  control[idxP].lblDetail, { y = descY + 70, time = 400 })

         -- Listener on Ready
        local function videoListener( event )
            if event.phase == 'ready' then
                control[idxP].pause.alpha = 1
                control[idxP].loading.alpha = 0
                control[idxP].loading:setSequence("stop")

                cntTime = 0
                curTime = control[idxP].audio.totalTime
                jumpProgress = 300/ curTime
                control[idxP].lblBarTTotal.text = secondsToClock(curTime)
                tmrPlaying = timer.performWithDelay( 1000, lstPlaying, 0 ) 
                
            end
        end
        

        if event.target.downloaded then
            local path = system.pathForFile( event.target.file, system.TemporaryDirectory )
            local fhd = io.open( path )
            if fhd then
                fhd:close()
                local  file = event.target.file
                control[idxP].audio = native.newVideo( display.contentCenterX, display.contentCenterY, 50, 50 )
                control[idxP].audio:load(path, system.TemporaryDirectory )
                control[idxP].audio:addEventListener( "video", videoListener )
                control[idxP].audio:play()
            end
        else
            -- Load a remote audio
            control[idxP].audio = native.newVideo( display.contentCenterX, display.contentCenterY, 50, 50 )
            control[idxP].audio:load( "http://geekbucket.com.mx/prayer_ws/assets/audios/"..lstDays[idxC].file, media.RemoteSource )
            control[idxP].audio:addEventListener( "video", videoListener )
            control[idxP].audio:play()
        end
    end
    return true
end

-------------------------------------
-- Change seconds to clock format
-- @param event objeto evento
------------------------------------
function secondsToClock(seconds)
    local seconds = tonumber(seconds)

    if seconds <= 0 then
        return "00:00:00";
    elseif curTime < 3600 then
        mins = string.format("%02.f", math.floor(seconds/60));
        secs = string.format("%02.f", math.floor(seconds - mins *60));
        return mins..":"..secs
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        return hours..":"..mins..":"..secs
    end
end

-------------------------------------
-- Calling every second
-- @param event objeto evento
------------------------------------
function lstPlaying(event)
    cntTime = cntTime + 1
    control[idxP].lblBarTCurrent.text = secondsToClock(cntTime)
    control[idxP].bgBarC.width = (jumpProgress*cntTime)
    if curTime == cntTime then
        timer.cancel(tmrPlaying)
    end
end

-------------------------------------
-- Obtiene tarjeta
------------------------------------
function getCard()
    local item = lstDays[idxC]
    cards[idxC] = widget.newScrollView(
    {
        top = h + 130,
		left = 0,
        width = intW,
        height = intH - (h + 70),
		horizontalScrollDisabled = true,
		backgroundColor = { unpack(cGrayL) }
    })
    screen:insert(cards[idxC])
    
    -- Actions
    local bgAct = display.newRect( midW, 0, intW, 70 )
    bgAct.anchorY = 0
    bgAct:setFillColor( unpack(cPurpleH) )
    cards[idxC]:insert(bgAct)

    cloudIcon(item)
    favIcon(item)

    
    -- Desc Section
    local bgDesc = display.newRect( midW, 70, intW, 170 )
    bgDesc.anchorY = 0
    bgDesc:setFillColor( unpack(cPurple) )
    cards[idxC]:insert(bgDesc)
    
    local lblDescDate = display.newText({
        text = item.noDate..' de '..item.month,
        y = 110,
        x = midW, width = 400,
        font = fMonRegular, 
        fontSize = 26, align = "left"
    })
    lblDescDate:setFillColor( unpack(cWhite) )
    cards[idxC]:insert(lblDescDate)
    
    local lblDescTitle = display.newText({
        text = item.title,
        y = 135,
        x = midW, width = 400,
        font = fMonRegular, 
        fontSize = 28, align = "left"
    })
    lblDescTitle.anchorY = 0
    lblDescTitle:setFillColor( unpack(cWhite) )
    cards[idxC]:insert(lblDescTitle)
    
    local posY = 135 + lblDescTitle.height
    local lblDescSubTitle = display.newText({
        text = item.subtitle,
        y = posY,
        x = midW, width = 400,
        font = fMonRegular, 
        fontSize = 20, align = "left"
    })
    lblDescSubTitle.anchorY = 0
    lblDescSubTitle:setFillColor( unpack(cWhite) )
    cards[idxC]:insert(lblDescSubTitle)
    
    posY = posY + lblDescSubTitle.height + 20
    bgDesc.height = posY - 70
    
    -- Section Play
    control[idxC] = {}
    local bgPlay = display.newRect( midW, posY, intW, 100 )
    bgPlay.anchorY = 0
    bgPlay:setFillColor( unpack(cWhite) )
    cards[idxC]:insert(bgPlay)
    
    control[idxC].play = display.newImage("img/iconHPlay.png")
    control[idxC].play:translate(midW, posY + 50)
    control[idxC].play.downloaded = item.downloaded
    control[idxC].play.file = item.file
    control[idxC].play:addEventListener( 'tap', playAudio)
    cards[idxC]:insert( control[idxC].play )
    
    control[idxC].pause = display.newImage("img/iconHPause.png")
    control[idxC].pause:translate(midW, posY + 50)
    control[idxC].pause.alpha = 0
    control[idxC].pause:addEventListener( 'tap', pauseAudio)
    cards[idxC]:insert( control[idxC].pause )
    
    local sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
    control[idxC].loading = display.newSprite(sheet, Sprites.loading.sequences)
    control[idxC].loading.x = midW
    control[idxC].loading.y = posY + 50
    control[idxC].loading.alpha = 0
    cards[idxC]:insert(control[idxC].loading)
    
    control[idxC].prev = display.newImage("img/iconPDArrow.png")
    control[idxC].prev.alpha = .5
    control[idxC].prev:translate(midW - 110, posY + 50)
    cards[idxC]:insert( control[idxC].prev )
    
    control[idxC].next = display.newImage("img/iconPDArrow.png")
    control[idxC].next:translate(midW + 110, posY + 50)
    control[idxC].next.alpha = .5
    control[idxC].next.rotation = 180
    cards[idxC]:insert( control[idxC].next )
    
    -- Progress Bar
    posY = posY + 100
    control[idxC].grpProg = display.newGroup()
    control[idxC].grpProg.alpha = 0
    cards[idxC]:insert(control[idxC].grpProg)
    
    local bgBar = display.newRect( midW, posY, intW, 70 )
    bgBar.anchorY = 0
    bgBar:setFillColor( unpack(cPurpleH) )
    control[idxC].grpProg:insert(bgBar)
    
    control[idxC].lblBarTCurrent = display.newText({
        text = '00.00',
        y = posY + 35,
        x = midW-205, width = 100,
        font = fMonRegular, 
        fontSize = 16, align = "right"
    })
    control[idxC].lblBarTCurrent:setFillColor( unpack(cWhite) )
    control[idxC].grpProg:insert(control[idxC].lblBarTCurrent)
    
    control[idxC].lblBarTTotal = display.newText({
        text = '00.00',
        y = posY + 35,
        x = midW+205, width = 100,
        font = fMonRegular, 
        fontSize = 16, align = "left"
    })
    control[idxC].lblBarTTotal:setFillColor( unpack(cWhite) )
    control[idxC].grpProg:insert(control[idxC].lblBarTTotal)
    
    local bgBarT = display.newRect( midW, posY + 35, 300, 1 )
    bgBarT.anchorY = 0
    bgBarT:setFillColor( unpack(cWhite) )
    control[idxC].grpProg:insert(bgBarT)
    
    control[idxC].bgBarC = display.newRect( 90, posY + 35, 1, 1 )
    control[idxC].bgBarC.anchorX = 0
    control[idxC].bgBarC.anchorY = 0
    control[idxC].bgBarC:setFillColor( unpack(cPurple) )
    control[idxC].grpProg:insert(control[idxC].bgBarC)
    
    
    -- Section Detail
    control[idxC].lblDetail = display.newText({
        text = item.detail,
        y = posY + 20,
        x = midW, width = 420,
        font = fMonRegular, 
        fontSize = 16, align = "left"
    })
    control[idxC].lblDetail.anchorY = 0
    control[idxC].lblDetail:setFillColor( unpack(cPurple) )
    cards[idxC]:insert(control[idxC].lblDetail)
    
    -- Set new scroll position
    cards[idxC]:setScrollHeight(control[idxC].lblDetail.height + posY + 160)
end

function createNavigationPlay()
	
	 -- Navigation
    local bgScr = display.newRect( midW, h+70, intW, 80 )
    bgScr.anchorY = 0
    bgScr:setFillColor( unpack(cWhite) )
    screen:insert(bgScr)
    
    bgPrev = display.newRect(midW - 150, h+100, 150, 50 )
    bgPrev:setFillColor( unpack(cWhite) )
    bgPrev:addEventListener( 'tap', prevCard)
    screen:insert( bgPrev )
    bgNext = display.newRect(midW + 150, h+100, 150, 50 )
    bgNext:setFillColor( unpack(cWhite) )
    bgNext:addEventListener( 'tap', nextCard)
    screen:insert( bgNext )
    imgPrev = display.newImage("img/iconArrow.png")
    imgPrev:translate(midW - 85, h+100)
    screen:insert( imgPrev )
    imgNext = display.newImage("img/iconArrow.png")
    imgNext:translate(midW + 85, h+100)
    imgNext.rotation = 180
    screen:insert( imgNext )
	
	local date = os.date( "*t" )    -- Returns table of date & time values 
	local year = date.year
	local month = date.month
	local day = date.day
	if day < 10 then
		day = "0" ..day
	end
	if month < 10 then
		month = "0" ..month
	end
	
	local currentDate = year .. "-" .. month .. "-" .. day .. " 00:00:00"
	
	idxC = 1
	
	for i = 1, #lstDays, 1 do
		if lstDays[i].date  == currentDate then
			idxC = i
		end
		--if currentDate == lstDays[i].day_date
	end
	
    grpDays = display.newGroup()
    screen:insert(grpDays)
    
    for i = 1, #lstDays, 1 do 
        local lblDay = display.newText({
            text = lstDays[i].day,
            x = (i * 160) - 75, y = h+100,
            font = fMonRegular, width = 150,
            fontSize = 18, align = "center"
        })
        lblDay:setFillColor( unpack(cPurple) )
        grpDays:insert(lblDay)
    end
	
	grpDays.x = (idxC * -160) + 320
	moveNav()
	
	if not(cards[idxC]) then
		getCard()
	end
	cards[idxC].x = 240
	
end

--------------------------------------------
-- comprueba si existe conexion a internet
--------------------------------------------
function isNetworkConnection()
	local netConn = require('socket').connect('www.google.com', 80)
	if netConn == nil then
		return false
	end
	netConn:close()
	return true
end

function menssageNoLocalAudios( ... )
    local getAudios = DBManager.getAudiosDWL()
    if not getAudios then
     messageNoConnection()
    elseif #getAudios > 0 then
     returnAudioCard( getAudios )
    end
    --composer.gotoScene("src.Card" )
end

--------------------------------------------
-- Muestra un mensaje cuando no se encontro conexion a internet
--------------------------------------------
function messageNoConnection()
	
	tools:setLoading( false, groupLoading )
	
	if not groupLoading then
		groupLoading = display.newGroup()
		screen:insert( groupLoading )
	end
	
	groupLoading.y =  70 + h
	
	local lblNoConnection = display.newText({
        text = "La aplicacion necesita conexion a internet",
        y = 110,
        x = midW, width = intW-100,
        font = fMonRegular, 
        fontSize = 20, align = "center"
    })
    lblNoConnection:setFillColor(unpack(cBlack))
    groupLoading:insert(lblNoConnection)
	
	local btnNoConnection = display.newRoundedRect( midW, 250, intW - 50, 70, 5 )
    btnNoConnection:setFillColor( unpack(cPurple) )
    groupLoading:insert(btnNoConnection)
	btnNoConnection:addEventListener( 'tap', detectNetworkConnection )
	
	
	local lblRefresh = display.newText({
        text = "ACTUALIZAR",
        y = 250,
        x = midW, width = intW-100,
        font = fMonRegular, 
        fontSize = 20, align = "center"
    })
    lblRefresh:setFillColor( unpack(cWhite) )
    groupLoading:insert(lblRefresh)


    local btnNoConnection2 = display.newRoundedRect( midW, 350, intW - 50, 70, 5 )
    btnNoConnection2:setFillColor( unpack(cPurple) )
    btnNoConnection2:addEventListener('tap', menssageNoLocalAudios)
    groupLoading:insert(btnNoConnection2)

        local lblRefresh = display.newText({
        text = "CARGAR GUARDADOS",
        y = 350,
        x = midW, width = intW-100,
        font = fMonRegular, 
        fontSize = 20, align = "center"
    })
    lblRefresh:setFillColor( unpack(cWhite) )
    groupLoading:insert(lblRefresh)
	
end

function detectNetworkConnection( )

	tools:setLoading( true, groupLoading )
	
	if ( isNetworkConnection() ) then
		RestManager.getAudios()
        --messageNoConnection()
	else
        messageNoConnection()
		-- local getAudios = DBManager.getAudiosDWL()
		-- if not getAudios then
		-- 	messageNoConnection()
		-- elseif #getAudios > 0 then
		-- 	returnAudioCard( getAudios )
		-- end
	end
	
end


---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    local bgScr = display.newRect( midW, h, intW, intH )
    bgScr.anchorY = 0
    bgScr:setFillColor( unpack(cGrayL) )
    screen:insert(bgScr)
    
    -- Background
    tools:buildHeader()
    screen:insert(tools)
	
	groupLoading = display.newGroup()
	groupLoading.y = midH + ( 70 + h )
	screen:insert( groupLoading )

	detectNetworkConnection()
	
	--createNavigationPlay()
    
end	

-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then
		
        --[[if event.params then
            idxC = event.params.item
            grpDays.x = (idxC * -160) + 320
            moveNav()
            if not(cards[idxC]) then
                getCard()
            end
            cards[idxC].x = 240
        else
            cards[idxC].x = 240
        end]]
    end
end

-- Remove Listener
function scene:hide( event )
    --cards[idxC].x = 720
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )


return scene