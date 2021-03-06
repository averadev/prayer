---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

--Include sqlite
local dbManager = {}

	require "sqlite3"
	local path, db

	-- Open rackem.db.  If the file doesn't exist it will be created
	local function openConnection( )
	    path = system.pathForFile("player.db", system.DocumentsDirectory)
	    db = sqlite3.open( path )     
	end

	local function closeConnection( )
		if db and db:isopen() then
			db:close()
		end     
	end

    -- Verificamos campo en tabla
    local function updateTable(table, field, typeF)
	    local oldVersion = true
        for row in db:nrows("PRAGMA table_info("..table..");") do
            if row.name == field then
                oldVersion = false
            end
        end

        if oldVersion then
            local query = "ALTER TABLE "..table.." ADD COLUMN "..field.." "..typeF..";"
            db:exec( query )
        end   
	end
	 
	-- Handle the applicationExit event to close the db
	local function onSystemEvent( event )
	    if( event.type == "applicationExit" ) then              
	        closeConnection()
	    end
	end
	
	-- obtiene los datos de audios disponibles
	dbManager.getAudios = function()
		local result = {}
		openConnection( )
		local con = 1
		for row in db:nrows("SELECT * FROM audio;") do
			result[con] = row
			con = con + 1
		end
		closeConnection( )
		if #result > 0 then
			return result
		else
			return false
		end
	end
		-- obtiene los datos de audios disponibles
	dbManager.getAudiosFav = function()
		local result = {}
		openConnection( )
		local con = 1
		for row in db:nrows("SELECT * FROM audio WHERE fav = 1;") do
			result[con] = row
			con = con + 1
		end
		closeConnection( )
		if #result > 0 then
			return result
		else
			return false
		end
		
	end

	dbManager.getAudiosDWL = function()
		local result = {}
		openConnection( )
		local con = 1
		for row in db:nrows("SELECT * FROM audio WHERE downloaded = 1;") do
			result[con] = row
			con = con + 1
		end
		closeConnection( )
		if #result > 0 then
			return result
		else
			return false
		end
		
	end	

	dbManager.updateAudios = function( items )
		openConnection( )
		if ( #items > 0 ) then
			local query = "DELETE FROM audio"
			db:exec( query )
		end
		for i = 1, #items, 1 do
		local item = items[i]
			local query = "INSERT INTO audio VALUES ( '" .. item.id_day .."', '" .. item.day_date .."', '" .. item.day_type .."', '" .. item.day_name .."', '" .. item.day_shortdesc .."', '" .. item.day_longdesc .."', '" .. item.day_status .."', '" .. item.audio .."', '" .. item.weekday .."', '" .. item.day .."', '" .. item.month .."', '" .. item.fav .."', '" .. item.downloaded .."' );"
			db:exec( query )
		end
        
		
       
		closeConnection( )
	end
	
	-- obtiene los datos de configuracion
	dbManager.getSettings = function()
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM config;") do
			closeConnection( )
			return  row
		end
		closeConnection( )
		return 1
	end

    -- Actualiza login
    dbManager.updateUser = function(user)
		openConnection( )
        local query = "UPDATE config SET id = '"..user.id.."', fbid = '"..user.fbid.."', name = '"..user.name.."'"
        if user.idCard then
            query = query..", idCard = '"..user.idCard.."'"
        end
        
        db:exec( query )
		closeConnection( )
	end
	

	-- Setup squema if it doesn't exist
	dbManager.setupSquema = function()
		openConnection( )
		
		local query = "CREATE TABLE IF NOT EXISTS config (id INTEGER PRIMARY KEY, idDevice TEXT, url TEXT);"
		db:exec( query )
		
		local query = "CREATE TABLE IF NOT EXISTS audio (id_day INTEGER PRIMARY KEY, day_date TEXT, day_type INTEGER, day_name TEXT, day_shortdesc TEXT, day_longdesc TEXT, day_status INTEGER, audio TEXT, weekday text, day text, month text, fav  INTEGER, downloaded INTEGER);"
		db:exec( query )
    
        --updateTable('config', 'idCard', 'TEXT')
		
        for row in db:nrows("SELECT * FROM config;") do
            closeConnection( )
			do return end
		end

    	ID_D = system.getInfo("deviceID")
        query = "INSERT INTO config VALUES ('0', '"..ID_D.."', 'http://geekbucket.com.mx/prayer_ws/');"
		db:exec( query )
    
		closeConnection( )
    
        return 1
	end
	
	-- Setup the system listener to catch applicationExit
	Runtime:addEventListener( "system", onSystemEvent )

return dbManager