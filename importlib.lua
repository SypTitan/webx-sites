importlib = {}

function get(lib)
    return require(window.link .. lib)
end

function require(lib)
    return get(lib)
end

function import(lib)
    return get(lib)
end

return importlib