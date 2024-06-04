local img = get("foximg")
local button = get("newbutton")

function generateImage()
    local res = fetch({
        url = "https://randomfox.ca/floof/",
        method = "GET",
        headers = { ["Content-Type"] = "application/json" },
        body = ""
    })

    img.set_source(res["image"])
end

generateImage()

button.on_click(function ()
    generateImage()
end)