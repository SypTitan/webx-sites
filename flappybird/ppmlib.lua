local ppmlib = {}

function ppmlib.getHeader(width: number, height: number): string
    return "P3\n" .. width .. " " .. height .. "\n255\n"
end

function ppmlib.addPixel(source: string, red: number, green: number, blue: number): string
    return source .. red .. " " .. green .. " " .. blue .. "\n"
end

function ppmlib.fillFile(width: number, height: number, red: number, green: number, blue: number): string
    return ppmlib.getHeader(width, height) .. string.rep(red .. " " .. green .. " " .. blue .. "\n", width*height)
end

function ppmlib.getSize(source: string): (number, number)
    local start, finish = string.find(source, "(%d+ %d+)\n")
    --print("loc 1: " .. start .. ":" .. finish)
    local slice = string.sub(source, start, finish)
    --print("slice: " .. slice)
    local values = string.split(slice, " ")
    local width, height = tonumber(values[1]), tonumber(values[2])
    return width, height
end

function ppmlib.setRectangle(source: string, x: number, y: number, width: number, height: number, red: number, green: number, blue: number): string
    local fullwidth: number, _fullheight: number = ppmlib.getSize(source)
    local offset: number = 3
    local index: number = offset + x + y*fullwidth
    local separated = string.split(source, "\n")
    for i=1,height do
        for j=0,width-1 do
            separated[index+j] = red .. " " .. green .. " " .. blue
        end
        index += fullwidth
    end
    local output: string = table.concat(separated, "\n")
    return output
end

function ppmlib.fillTable(width: number, height: number, red: number, green: number, blue: number): {string}
    local colour = red .. " " .. green .. " " .. blue
    local result = table.create(width*height+3, colour)
    result[1] = "P3"
    result[2] = width .. " " .. height
    result[3] = 255

    return result
end

function ppmlib.setRectangleTable(source: { string }, x: number, y: number, width: number, height: number, red: number, green: number, blue: number): { string }
    local fullwidth: number = tonumber(string.split(source[2], " ")[1])
    local offset: number = 3
    local index: number = offset + x + y*fullwidth
    for i=1,height do
        for j=0,width-1 do
            source[index+j] = red .. " " .. green .. " " .. blue
        end
        index += fullwidth
    end
    return source
end

return ppmlib