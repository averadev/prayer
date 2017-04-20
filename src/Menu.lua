---------------------------------------------------------------------------------
-- Oraciones
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
local widget = require( "widget" )
local composer = require( "composer" )
local Globals = require( "src.resources.Globals" )

-- Verified if it simulator
-- local isSimulator = "simulator" == system.getInfo( "environment" )

-- if isSimulator then
--     native.showAlert( "Build for device", "This plugin is not supported on the Simulator, please build for an iOS/Android device or Xcode simulator", { "Aceptar" } )
-- end

-- Grupos y Contenedores
local screen
local scene = composer.newScene()

-- Variables

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

function gotoFacebook()
    system.openURL( "https://www.facebook.com/PadreEvaristoSadaLC/" )
end
function gotoTwitter()
    system.openURL( "https://twitter.com/EvaristoSada" )
end
function gotoWeb()
    system.openURL( "http://geekbucket.com.mx/en/" )
end
function gotoInstagram()
    system.openURL( "https://www.instagram.com/evaristosadalc/" )
end
function gotoYoutube()
    system.openURL( "https://www.youtube.com/user/evaristosadalc/" )
end

function dayPray(event)
    composer.gotoScene("src.Card", { time = 400, effect = "slideLeft", params = { item = 8 } } )
end
function favoriteDays(event)
    composer.removeScene("src.FavDays")
    composer.gotoScene("src.FavDays", { time = 400, effect = "slideLeft", params = { item = nil } } )
end
function HowPray( event )
    composer.removeScene("src.HowToPray")
    composer.gotoScene("src.HowToPray", { time = 400, effect = "slideLeft", params = { item = nil } } )
end
function donations(event)
    composer.removeScene("src.Donations")
    composer.gotoScene("src.Donations", { time = 400, effect = "slideLeft", params = { item = nil } } )
end
function configApp(event)
    composer.gotoScene("src.Configuracion", { time = 400, effect = "slideLeft", params = { item = 8 } } )
end
function recommendApp( event )
    local serviceName = "facebook"
    local isAvailable = native.canShowPopup( "social", serviceName )
 
    -- 
    if isAvailable then
        local listener = {}
        function listener:popup( event )
            print( "name(" .. event.name .. ") type(" .. event.type .. ") action(" .. tostring(event.action) .. ") limitReached(" .. tostring(event.limitReached) .. ")" )          
        end
 
        -- muestra el popup
        native.showPopup( "social",
        {
            service = serviceName,
            message = "Hola, te invito a que descargues la aplicación en tu teléfono o tablet y lee una cita biblica a diario.",
            listener = listener,
            image = 
            {
                { filename = "Icon.png", baseDir = system.ResourceDirectory }
            },
            url = 
            {
                "https://www.facebook.com/PadreEvaristoSadaLC/",
                "https://www.instagram.com/evaristosadalc/",
            }
        })
    else
        if isSimulator then
            native.showAlert( "Build for device", "This plugin is not supported", { "Aceptar" } )
        else
            native.showAlert( "No se puede enviar el mensaje ", "Por favor, configure su cuenta o compruebe la conexión a internet", { "OK" } )
        end
    end
end
function buyBook( event )
    system.openURL( "https://www.amazon.com.mx" )
end
function gotoAuthor( event )
    composer.removeScene("src.Author")
    composer.gotoScene( "src.Author", { time = 400, effect = "slideLeft", params = { item = nil } } )
end
function setTapListener(posicion, elemento)
    if posicion == 1 then
        elemento:addEventListener( 'tap', dayPray)
    end
    if posicion == 2 then
        elemento:addEventListener( 'tap', favoriteDays)
    end
    if posicion == 3 then
        elemento:addEventListener( 'tap', HowPray)
    end
    if posicion == 4 then
        elemento:addEventListener( 'tap', donations)
    end
    if posicion == 5 then
        elemento:addEventListener( 'tap', buyBook )
    end
    if posicion == 6 then 
        elemento:addEventListener( 'tap', recommendApp )
    end
    if posicion == 7 then 
        elemento:addEventListener( 'tap', gotoAuthor )
    end
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    screen.y = h
    local menuCf = h - 30
    
    local bgScr = display.newRect( midW, h, intW, 70 )
    bgScr.anchorY = 0
    bgScr:setFillColor( unpack(cBlack) )
    screen:insert(bgScr)

    -- Icon config tap action
    local iconConfig = display.newImage( "img/iconConfiguracion.png", midW - 170, menuCf + 30 )
    --iconConfig.anchorY = 0
    iconConfig:translate(menuCf-30, 40)
    iconConfig.screen = "Menu"
    iconConfig.animation = "slideRight"
    iconConfig:addEventListener( "tap", configApp )
    screen:insert( iconConfig )
    
    local lblTitle = display.newText({
        text = 'MENÚ',
        y = h+40,
        x = midW, width = 150,
        font = fMonRegular, 
        fontSize = 24, align = "center"
    })
    lblTitle:setFillColor( unpack(cWhite) )
    screen:insert(lblTitle)
    
    local bgReturn = display.newRect( 410, h+40, 120, 30 )
    bgReturn:setFillColor( unpack(cBlack) )
    bgReturn:addEventListener( 'tap', toPrevious)
    screen:insert(bgReturn)
    
    local lblRegresar = display.newText({
        text = 'REGRESAR',
        y = h+40,
        x = 460, width = 200,
        font = fMonRegular, 
        fontSize = 18, align = "right"
    })
    lblRegresar.anchorX = 1
    lblRegresar:setFillColor( unpack(cWhite) )
    screen:insert(lblRegresar)

    -- scContainerScrollMenu
    local scContainerScroll = widget.newScrollView({
        top = h + 80,
        left = 0,
        width = intW,
        height = 545 - (h + 10),
        horizontalScrollDisabled = true,
        backgroundColor = { unpack(cWhite) }
    })
    
    local menuY = h - 30
    local menuA = {
        {'iconOracionDelDia','DayPray','Oración del Día'},
        {'iconLikeds','favoriteDays','Favoritos'},
        {'iconComoOrar','HowPray','¿Comó Orar?'},
        {'iconDonaciones','Donation','Donaciones'},
        {'iconComprarLibro','buyBook','Comprar Libro'},
        {'iconCompartir','recommendApp','Recomendar Aplicación'},
        {'iconAutor','gotoAuthor','Autor: Padre Evaristo Sada, LC'}
    }
    
    for i = 1, #menuA, 1 do 
        local bgM1 = display.newRect( midW, menuY, 480, 80 )
        bgM1.anchorY = 0
        bgM1.alpha = .5
        bgM1:setFillColor( unpack(cPurple) )
        scContainerScroll:insert(bgM1)
        
        local bgM2 = display.newRect( midW, menuY + 1, 480, 78 )
        bgM2.anchorY = 0
        bgM2:setFillColor( unpack(cWhite) )
        scContainerScroll:insert(bgM2)
        
        local icon = display.newImage("img/"..menuA[i][1]..".png")
        icon:translate(90, menuY + 40)
        scContainerScroll:insert( icon )

        local lblMenu = display.newText({
            text = menuA[i][3],
            y = menuY + 40,
            x = 410, width = 280,
            font = fMonRegular, 
            fontSize = 18, align = "left"
        })
        lblMenu.anchorX = 1
        lblMenu:setFillColor( unpack(cBlack) )
        scContainerScroll:insert( lblMenu )
        screen:insert( scContainerScroll )
        
        setTapListener(i, bgM2)
        
        menuY = menuY + 70
    end
    
    -- Redes Sociales
    local lblSiguenos = display.newText({
        text = "Síguenos en:",
        y = intH - 83,
        x = midW, width = 200,
        font = fMonRegular, 
        fontSize = 18, align = "center"
    })
    lblSiguenos:setFillColor( unpack(cBlack) )
    screen:insert(lblSiguenos)
    
    local iconWeb = display.newImage("img/iconPagWeb.png")
    iconWeb:translate(midW - 140, intH - 35)
    iconWeb:addEventListener( 'tap', gotoWeb)
    screen:insert( iconWeb )
    
    local iconSFB = display.newImage("img/iconFacebook.png")
    iconSFB:translate(midW - 70, intH - 35)
    iconSFB:addEventListener( 'tap', gotoFacebook)
    screen:insert( iconSFB )
    
    local iconSTW = display.newImage("img/iconTwitter.png")
    iconSTW:translate(midW + 5, intH - 35)
    iconSTW:addEventListener( 'tap', gotoTwitter)
    screen:insert( iconSTW )

    local iconINSTAGRAM = display.newImage("img/iconInstagram.png")
    iconINSTAGRAM:translate( midW + 80, intH - 35 )
    iconINSTAGRAM:addEventListener( 'tap', gotoInstagram )
    screen:insert( iconINSTAGRAM )

    local iconYOUTUBE = display.newImage("img/iconYoutube.png")
    iconYOUTUBE:translate( midW + 150, intH - 35 )
    iconYOUTUBE:addEventListener( 'tap', gotoYoutube )
    screen:insert( iconYOUTUBE )
    
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