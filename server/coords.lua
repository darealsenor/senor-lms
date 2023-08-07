-- TODO: after accessing the right coords, make a command to push to json new locations based on the 
-- Name, and move it to config right after
function addCoordsToConfig(location)
    local loadFile = LoadResourceFile(GetCurrentResourceName(), './locations.json')
    local decodedFile = json.decode(loadFile)
    
    -- Access the "Locations" object
    local locations = decodedFile.Locations
    
    -- Iterate over the locations
    for k, v in ipairs(locations.coords) do
        -- Access the coordinates
        local x = v.x
        local y = v.y
        local z = v.z
        local h = v.h
        
        -- Print or use the coordinates as needed
        print('Coordinates:', x, y, z, h)
    end
end


addCoordsToConfig('Maze Bank')