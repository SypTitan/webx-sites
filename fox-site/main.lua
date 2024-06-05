print("Fox :3")

local img = get("foximage")
local button = get("newbutton")

function GenerateImage()
    local res = fetch({
        url = "https://randomfox.ca/floof/",
        method = "GET",
        headers = { ["Content-Type"] = "application/json" },
        body = ""
    })

    img.set_source(res["image"])
end

GenerateImage()

button.on_click(function()
    GenerateImage()
end)