
{% include '.cmdchan.lua'%}

connection:set_cmdchan(azure_cmdchan(connection, core_conf:get("cmdchan_path")))
local tx_name = "9mine-azure-cloud-console.png"
texture.download("https://download.logo.wine/logo/Microsoft_Azure/Microsoft_Azure-Logo.wine.png",
    true, tx_name, "9mine-azure-cloud-fs")
entity:set_properties({
    visual = "cube",
    textures = {tx_name, tx_name, tx_name, tx_name, tx_name, tx_name}
})
entity:get_luaentity().on_punch = function(self, player)
    local p = self.object:get_pos()
    local pos = minetest.serialize(p)
    local request = ""
    minetest.show_formspec(player:get_player_name(), "azure:console",
        table.concat({"formspec_version[4]", "size[13,13,false]",
                      "textarea[0.5,0.5;12.0,10;;;" .. minetest.formspec_escape(self.output) .. "]",
                      "field[0.5,10.5;12,1;input;;]", "field_close_on_enter[input;false]",
                      "button[10,11.6;2.5,0.9;send;send]",
                      "field[13,13;0,0;entity_pos;;" .. minetest.formspec_escape(pos) .. "]"}, ""))
end

local function azure_console(player, formname, fields)
    if formname == "azure:console" then
        if not (fields.key_enter or fields.send) then
            return
        end
        local player_name = player:get_player_name()
        local pos = minetest.deserialize(fields.entity_pos)
        local lua_entity = select(2, next(minetest.get_objects_inside_radius(pos, 0.5))):get_luaentity()
        local cmdchan = connections:get_connection(player_name, lua_entity.addr):get_cmdchan()
        cmdchan:write(fields.input:gsub("^az ", ""))
        minetest.show_formspec(player_name, "azure:console",
            table.concat({"formspec_version[4]", "size[13,13,false]", "textarea[0.5,0.5;12.0,10;;;",
                          minetest.formspec_escape("Please, wait for response"), "]", "field[0.5,10.5;12,1;input;;]",
                          "field_close_on_enter[input;false]"}, ""))
        minetest.after(3, function()
            local function show_output()
                local result, response = pcall(cmdchan.read, cmdchan, "/n/cmdchan/cmdchan_output")
                if not result then
                    minetest.after(3, show_output)
                    return
                end
                lua_entity.output = fields.input .. ": \n" .. response .. "\n" .. lua_entity.output
                minetest.show_formspec(player_name, "azure:console",
                    table.concat({"formspec_version[4]", "size[13,13,false]", "textarea[0.5,0.5;12.0,10;;;",
                                  minetest.formspec_escape(lua_entity.output), "]", "field[0.5,10.5;12,1;input;;]",
                                  "field_close_on_enter[input;false]", "button[10,11.6;2.5,0.9;send;send]",
                                  "field[13,13;0,0;entity_pos;;", minetest.formspec_escape(fields.entity_pos), "]"}, ""))
            end
            show_output()
        end)
    end
end

register.add_form_handler("azure:console", azure_console)
