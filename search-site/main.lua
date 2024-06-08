print("Running")

print("Imported!")

function split(str, sep)
    --if (sep==nil) then sep = "%s" end
    local split_str = {}
    for str in string.gmatch(str, "([^"..sep.."]+)") do
        table.insert(split_str, str)
    end
    return split_str
end

function tagToTable(tag)
    local result = {}
    for entry in string.gmatch(tag, '%a+="[^"]*"') do
        local pair = split(entry, '=')
        if string.sub(pair[2], 1, 1) == '"' and string.sub(pair[2], -1, -1) == '"' then pair[2] = string.sub(pair[2], 2, -2) end
        result[pair[1]] = pair[2]
    end
    return result
end

function FetchFromGithub(url)
    local split_url = split(url, "/")
    return string.format("http://raw.githubusercontent.com/%s/%s/main/%s", split_url[3], split_url[4], table.concat(split_url, "/", 7))
end

function ResolveDns(domain, tld)
    local res = fetch({
        url = string.format("http://api.buss.lol/domain/%s/%s", domain, tld),
        method = "GET",
        headers = { ["Content-Type"] = "application/json" },
        body = ""
    })
    return res['ip']
end

function GetSiteContents(url)
    if (string.sub(url, -1, -1) ~= "/")
    then
        url = url .. "/index.html"
    else
        url = url .. "index.html"
    end
    print("Final url: "..url)
    local res = fetch({
        url = "https://search-bot-app-syptitan.koyeb.app/content",
        method = "POST",
        headers = { ["Content-Type"] = "application/json" },
        body = '{ "url": "' .. url .. '" }'
    })
    return res['content']
end

local url = ResolveDns("fox", "uwu")

url = FetchFromGithub(url)

-- --print(FetchFromGithub("https://github.com/SypTitan/webx-sites/tree/main/fox-site"))

local title = get("title")
title.set_content(url)

local text = get("description")

print("Ready for this?")

local x = GetSiteContents(url)

print("Fetched!")

local i, j = string.find(x, "<meta.->")

print("Found!")

x = string.sub(x, i+5, j-1)

print("Subbed!")

y = tagToTable(x)

print("Tabularized!")

print(y)

if (y['name'] == "description") 
then
    text.set_content(y['content'])
end

print("Finished!")