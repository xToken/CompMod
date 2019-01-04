-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Utilities\CustomGamestrings\client.lua
-- - Dragon

Script.Load("lua/dkjson.lua")

local kCustomGamestringsTable = { }
local localeFiles = { }

local function BuildGamestringTable()

    Shared.GetMatchingFileNames("lua/CompMod/Gamestrings/*.json", false, localeFiles )

    if #localeFiles > 0 then
        for i = 1, #localeFiles do
            local fileName = localeFiles[i]
            local localeName = string.gsub(string.gsub(fileName, "lua/CompMod/Gamestrings/", ""), ".json", "")
            Shared.Message("Loading Custom Gamestring " .. fileName)
            local openedFile = GetFileExists(fileName) and io.open(fileName, "r")
            if openedFile then
                local parsedFile, _, errStr = json.decode(openedFile:read("*all"))
                if errStr then
                    Shared.Message("Error while opening " .. fileName .. ": " .. errStr)
                end
                io.close(openedFile)
                kCustomGamestringsTable[localeName] = parsedFile
            end
            
        end
    end
    
end

BuildGamestringTable()

local oldLocaleResolveString = Locale.ResolveString
function Locale.ResolveString(s)
    -- determine users locale
    local locale = Locale.GetLocale()
    -- check if we replace/add this tag
    local modString = kCustomGamestringsTable["enUS"][s]
    if modString then
        -- We modify this tag
        -- return locale specific string
        if kCustomGamestringsTable[locale] then
            return kCustomGamestringsTable[locale][s]
        end
        return modString 
    else
        return oldLocaleResolveString(s)
    end
end