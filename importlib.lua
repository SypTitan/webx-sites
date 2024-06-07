importlib = {}

function importlib.get(lib)
    return require(window.link .. lib)
end

function importlib.require(lib)
    return get(lib)
end

function importlib.import(lib)
    return get(lib)
end

return importlib