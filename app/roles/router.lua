local cartridge = require('cartridge')
local cluster_cfg = require('cartridge.clusterwide-config')
local log = require('log')

-- подключаем кастомные модули

--[[    ИСТОЧНИК ПРОБЛЕМЫ ВОТ В ЭТОМ ИМПОРТЕ    ]]
local utils = require('app.src.validation_utils')

--[[
local http_handlers = require('app.src.http_handlers')

local ROOT_CONFIG_KEY<const> = "weather-provider"
]]

local function init(opts) -- luacheck: no unused args
    return true
    --[[
    log.info("Начало инициализации роли <app.roles.router>")
    -- загружаем дефолный конфиг
    cluster_cfg.load("cfg/weather-provider-config.yml")

    -- устанавливаем обработчик
    local httpd = assert(cartridge.service_get('httpd'), "Failed to get httpd service")
    httpd:route({method = 'GET', path = '/hello'}, http_handlers.get_weather)

    return true]]
end

local function stop()
    return true
end

local function validate_config(conf_new, conf_old) -- luacheck: no unused args
    --[[
    local cfg_weather_provider = conf_new[ROOT_CONFIG_KEY]

    if (cfg_weather_provider == nil) then
        return false
    end

    -- собираем имена параметров
    local uri_cfg_key = weather_provider_metadata.get_uri_cfg_key()
    local x_coord_cfg_key = weather_provider_metadata.get_longitude_cfg_key()
    local y_coord_cfg_key = weather_provider_metadata.get_latitude_cfg_key()
    local actuality_opts_cfg_key = weather_provider_metadata.get_actuality_opts_cfg_key()
    local query_opts_cfg_key = weather_provider_metadata.get_query_opts_cfg_key()

    -- получаем параметры конфигурации
    local param_uri = cfg_weather_provider[uri_cfg_key]
    local param_x_coord = cfg_weather_provider[x_coord_cfg_key]
    local param_y_coord = cfg_weather_provider[y_coord_cfg_key]
    local param_actuality_opts = cfg_weather_provider[actuality_opts_cfg_key]
    local param_query_opts = cfg_weather_provider[query_opts_cfg_key]

    -- валидируем параметры конфигурации
    local err_msg = "Cluster global configuration error"
    if (
        ~utils.validate_string_value(uri_cfg_key, param_uri, err_msg) or
        ~utils.validate_string_value(x_coord_cfg_key, param_x_coord, err_msg) or
        ~utils.validate_string_value(y_coord_cfg_key, param_y_coord, err_msg) or
        ~utils.validate_array_value(actuality_opts_cfg_key, param_actuality_opts, err_msg) or
        ~utils.validate_array_value(query_opts_cfg_key, param_query_opts, err_msg)
    ) then
        return false
    end

    return true
    ]]
end

local function apply_config(conf, opts) -- luacheck: no unused args
    -- if opts.is_master then
    -- end

    return true
end

return {
    role_name = 'app.roles.router',
    init = init,
    stop = stop,
    validate_config = validate_config,
    apply_config = apply_config,
    dependencies = {'cartridge.roles.vshard-router'},
}
