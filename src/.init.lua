local function set_texture(entry, entity)
    local prefix = init_path:match("/$") and init_path:sub(1, -2) or init_path
    if not prefix then
        return
    end
    local azure_textures_directory = "9mine-azure-cloud-fs"
    local texture_prefix = "9mine-azure-cloud-fs"
    if entry.entry_string == prefix .. "/vm" then
        local tx_name = texture_prefix .. "-vm.png"
        texture.download(
            "https://www.clipartmax.com/png/middle/18-189604_microsoft-azure-icon-logo-vector-microsoft-azure-logo-vector.png",
            true, tx_name, azure_textures_directory)
        entity:set_properties({
            visual = "sprite",
            textures = {tx_name}
        })
    end

    if entry.entry_string == prefix .. "/vm/list" then
        local tx_name = texture_prefix .. "-vm-list.png"
        texture.download("https://theautomationguy.files.wordpress.com/2019/08/img_1342.png?w=641&h=619&crop=1", true,
            tx_name, azure_textures_directory)
        entity:set_properties({
            visual = "sprite",
            textures = {tx_name}
        })
    end

    if entry.platform_string == prefix .. "/vm/list" then
        local tx_name = texture_prefix .. "-vm-instance.png"
        texture.download(
            "https://www.pikpng.com/pngl/m/230-2302946_azure-service-fabric-icon-png-download-azure-virtual.png", true,
            tx_name, azure_textures_directory)
        entity:set_properties({
            visual = "sprite",
            textures = {tx_name}
        })
    end

    if entry.platform_string:match(string.gsub(prefix .. "/vm/list", "%-", "%%%-") .. "/[%d%a%p]+") then
        local tx_name = texture_prefix .. "-vm-conf.png"
        texture.download("https://static.thenounproject.com/png/1274728-200.png", true, tx_name,
            azure_textures_directory)
        entity:set_properties({
            visual = "sprite",
            textures = {tx_name}
        })
    end
end

register.add_texture_handler(init_path .. "9mine-azure-cloud-fs", set_texture)
