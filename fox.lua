local img = get("foximg")

local function setrandomfox(target)
    local res = fetch({
        url = "https://randomfox.ca/floof/",
        method = "GET",
        headers = { ["Content-Type"] = "application/json" },
        body = ""
    })

    img.set_source(res["image"])
end

//print("Source: " .. window.link)

setrandomfox(img)