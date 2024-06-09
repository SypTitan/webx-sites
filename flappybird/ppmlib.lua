local ppmlib = {}

function ppmlib.fillTable(width: number, height: number, red: number, green: number, blue: number): {string}
    local colour = string.format("%d %d %d", red, green, blue)
    local result = table.create(width*height+3, colour)
    result[1] = "P3"
    result[2] = width .. " " .. height
    result[3] = 255

    return result, width, height
end

function ppmlib.setRectangleTable(source: { string }, x: number, y: number, width: number, height: number, red: number, green: number, blue: number, fullwidth: number?, fullheight: number?): { string }
    if (fullwidth == nil) then
        local fullwidth: number = tonumber(string.split(source[2], " ")[1])
    end
    local offset: number = 3
    local index: number = offset + x + y*fullwidth
    local colour = string.format("%d %d %d", red, green, blue)
    for i=1,height do
        for j=0,width-1 do
            source[index+j] = colour
        end
        index += fullwidth
    end
    return source
end

return ppmlib