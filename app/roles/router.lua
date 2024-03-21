local cartridge = require('cartridge')
local cluster_cfg = require('cartridge.clusterwide-config')
local weather_provider_metadata = require('app.src.config.open_weather_client_metadata')
local weather_config_validator = require('app.src.config.weather_client_cfg_validation')
local json = require('json')
local log = require('log').new("app.roles.router")
log.cfg{ level='info'}

-- подключаем кастомные модули

local http_handlers = require('app.src.http_handlers')



local function init(opts) -- luacheck: no unused args
    -- устанавливаем обработчик
    local httpd = assert(cartridge.service_get('httpd'), "Failed to get httpd service")

    httpd:route({method = 'GET', path = '/weather/:actuality'}, http_handlers.get_weather)
    httpd:route({method = 'GET', path = '/get'}, http_handlers.get)
    httpd:route({method = 'GET', path = '/put'}, http_handlers.put)

    return true
end

local function stop()
    return true
end

local function validate_config(conf_new, conf_old)
    if (conf_new ~= nil) then
        local weather_cfg = conf_new[weather_provider_metadata.get_root_cgk_key()]
        if (weather_cfg == nil) then
            return true
        end

        log.info("Cluster configuration at section <"
            ..weather_provider_metadata.get_root_cgk_key()
            .."> : "..json.encode(weather_cfg))
        return weather_config_validator.validate_config(weather_cfg)
    end
    return true
end

local function apply_config(conf, opts)
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
