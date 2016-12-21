---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

--Include sqlite
local RestManager = {}

	local mime = require("mime")
	local json = require("json")
	local crypto = require("crypto")
    local DBManager = require('src.resources.DBManager')
    local dbConfig = DBManager.getSettings()

    local site = "http://geekbucket.com.mx/prayer_ws/"
    --local site = "http://mytuki.com/api/"
	
	--------------------------------------------
    -- codifica la cadena para enviar por get
    --------------------------------------------
	function urlencode(str)
          if (str) then
              str = string.gsub (str, "\n", "\r\n")
              str = string.gsub (str, "([^%w ])",
              function ( c ) return string.format ("%%%02X", string.byte( c )) end)
              str = string.gsub (str, " ", "%%20")
          end
          return str    
    end

    function reloadConfig()
        dbConfig = DBManager.getSettings()
    end

	--------------------------------------------
    -- Envia al metodo
    --------------------------------------------
    function goToMethod(obj)
        if obj.name == "" then
        end
    end
	
	--------------------------------------------
    -- comprueba si existe conexion a internet
    --------------------------------------------
	function networkConnection()
		local netConn = require('socket').connect('www.google.com', 80)
		if netConn == nil then
			return false
		end
		netConn:close()
		return true
	end

	---------------------------------- Pantalla Card ----------------------------------
	
    -------------------------------------
    -- valida que la ciudad exista
    -------------------------------------
    RestManager.getAudios = function()
	
		reloadConfig()
	
		site = dbConfig.url
		local url = site.."api/getAudio/format/json"
		url = url.."/id_device/" .. dbConfig.idDevice
		print(url)
		
        local function callback(event)
            if ( event.isError ) then
				print("Error aa")
				--returnLocationProfile( false, event.error)
            else
                local data = json.decode(event.response)
				if data then
					if data.success then
						DBManager.updateAudios(data.items)
						returnAudioCard(data.items)
						--returnLocationProfile( true, data.message)
					else
						print("Error a")
						--returnLocationProfile( false, language.RMErrorSavingProfile )
					end
				else
					print("Error b")
					--returnLocationProfile( false, language.RMErrorSavingProfile )
				end
            end
            return true
        end
        -- Do request
		network.request( url, "GET", callback )
    end
	
    -- Carga de la imagen del servidor o de TemporaryDirectory
    function loadImage(obj)
        -- Next Image
        if obj.idx < #obj.items then
            -- Add to index
            obj.idx = obj.idx + 1
            -- Determinamos si la imagen existe
            if obj.items[obj.idx].image then
                local img = obj.items[obj.idx].image
                local path = system.pathForFile( img, system.TemporaryDirectory )
                local fhd = io.open( path )
                if fhd then
                    fhd:close()
                    loadImage(obj)
                else
                    local function imageListener( event )
                        if ( event.isError ) then
                        else
                            event.target:removeSelf()
                            event.target = nil
                            loadImage(obj)
                        end
                    end
                    -- Descargamos de la nube
                    display.loadRemoteImage( site..obj.path..img, "GET", imageListener, img, system.TemporaryDirectory ) 
                end
            else
                loadImage(obj)
            end
        else
            -- Dirigimos al metodo pertinente
            goToMethod(obj)
        end
    end

    -------------------------------------
    -- valida que la ciudad exista
    -------------------------------------
    RestManager.saveFav = function(id)
    
        reloadConfig()
    
        site = dbConfig.url
        local url = site.."api/saveFav"
        url = url.."/id_device/" .. urlencode(dbConfig.idDevice)
        url = url.."/id_day/" .. id
        print(url)
        
        local function callback(event)
            if ( event.isError ) then
                print("Error aa")
                --returnLocationProfile( false, event.error)
            else
                local data = json.decode(event.response)
                if data then
                    if data.success then
                        DBManager.updateAudios(data.items)
                        --returnAudioCard(data.items)
                        --returnLocationProfile( true, data.message)
                    else
                        print("Error a")
                        --returnLocationProfile( false, language.RMErrorSavingProfile )
                    end
                else
                    print("Error b")
                    --returnLocationProfile( false, language.RMErrorSavingProfile )
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
    end	
	
    -------------------------------------
    -- valida que la ciudad exista
    -------------------------------------
    RestManager.deleteFav = function(id)
    
        reloadConfig()
    
        site = dbConfig.url
        local url = site.."api/deleteFav"
        url = url.."/id_device/" .. urlencode(dbConfig.idDevice)
        url = url.."/id_day/" .. id
        print(url)
        
        local function callback(event)
            if ( event.isError ) then
                print("Error aa")
                --returnLocationProfile( false, event.error)
            else
                local data = json.decode(event.response)
                if data then
                    if data.success then
                        DBManager.updateAudios(data.items)
                        --returnAudioCard(data.items)
                        --returnLocationProfile( true, data.message)
                    else
                        print("Error a")
                        --returnLocationProfile( false, language.RMErrorSavingProfile )
                    end
                else
                    print("Error b")
                    --returnLocationProfile( false, language.RMErrorSavingProfile )
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
    end     

    RestManager.saveDowloaded = function(id)
    
        reloadConfig()
    
        site = dbConfig.url
        local url = site.."api/saveDowloaded"
        url = url.."/id_device/" .. urlencode(dbConfig.idDevice)
        url = url.."/id_day/" .. id
        print(url)
        
        local function callback(event)
            if ( event.isError ) then
                print("Error aa")
                --returnLocationProfile( false, event.error)
            else
                local data = json.decode(event.response)
                if data then
                    if data.success then
                        DBManager.updateAudios(data.items)
                        --returnAudioCard(data.items)
                        --returnLocationProfile( true, data.message)
                    else
                        print("Error a")
                        --returnLocationProfile( false, language.RMErrorSavingProfile )
                    end
                else
                    print("Error b")
                    --returnLocationProfile( false, language.RMErrorSavingProfile )
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
    end     
	
return RestManager