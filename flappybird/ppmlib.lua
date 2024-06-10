local ppmlib = {}

local b64 = require("https://raw.githubusercontent.com/Reselim/Base64/master/Base64.lua")

local encoded_header = { ["width"] = -1, ["height"] = -1, ["data"] = ""} 
local preprocessed_colours = {}

function getMeta(): string
    return "data:image/x-portable-bitmap;base64,"
end

function createHeader(width: number, height: number): string
    return "P3\n" .. width .. " " .. height .. "\n255\n"
end

function fixLength(data: string): string
    return data..string.rep("\n", (3 - (string.len(data) % 3)) % 3)
end

function encode(data: string): string
    return buffer.tostring(b64.encode(buffer.fromstring(fixLength(data))))
end

function processColour(colour: string): string
    local processed_colour = preprocessed_colours[colour]
    if (processed_colour == nil) then
        processed_colour = encode(colour)
        preprocessed_colours[colour] = processed_colour
        print("Added colour "..colour .. ": " .. preprocessed_colours[colour])
    end
    return processed_colour
end

function encodeHeader(width: number, height: number): string
    return encode(createHeader(width, height))
end

function getHeader(width: number, height: number): string
    if (encoded_header["width"] == width and encoded_header["height"] == height) then
        return encoded_header["data"]
    else
        encoded_header["width"] = width
        encoded_header["height"] = height
        encoded_header["data"] = encodeHeader(width, height)
        return encoded_header["data"]
    end
end

function ppmlib.fillStringOg(width: number, height: number, red: number, green: number, blue: number): string
    return table.concat(ppmlib.fillTableOg(width, height, red, green, blue), "\n")
end

function ppmlib.fillTableOg(width: number, height: number, red: number, green: number, blue: number): {string}
    local colour = string.format("%d %d %d", red, green, blue)
    local result = table.create(width*height+1, colour)
    result[1] = fixLength(createHeader(width, height))

    return result, width, height
end

function ppmlib.fillString(width: number, height: number, red: number, green: number, blue: number): string
    return table.concat(ppmlib.fillTable(width, height, red, green, blue), "")
end

function ppmlib.fillTable(width: number, height: number, red: number, green: number, blue: number): {string}
    local colour = string.format("%d %d %d\n", red, green, blue)
    local encoded_colour = processColour(colour)
    local result = table.create(width*height+2, encoded_colour)
    result[1] = getMeta()
    result[2] = getHeader(width, height)

    return result, width, height
end

function ppmlib.setRectangleTable(source: { string }, x: number, y: number, width: number, height: number, red: number, green: number, blue: number, fullwidth: number, fullheight: number?): { string }
    local offset: number = 2
    local index: number = offset + x + y*fullwidth
    local colour = string.format("%d %d %d\n", red, green, blue)
    local encoded_colour = processColour(colour)
    for i=1,height do
        for j=0,width-1 do
            source[index+j] = encoded_colour
        end
        index += fullwidth
    end
    return source
end

return ppmlib