---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by avikulin.
--- DateTime: 19.03.2024 13:53
---

local cartridge = require('cartridge')
local vshard = require('vshard')
local json = require('json')
local log = require('log').new("http-handlers")
local cache_ctx = require('app.src.cache-dal.cache_ctx_adapter')
local date = require('datetime')

log.cfg{ level='info'}

local X_COORD_QUERY_PARAM = "longitude"
local Y_COORD_QUERY_PARAM = "latitude"

local cached_weather_provider = require('app.src.http-client.cache_enabled_weather_adapter')
local weather_provider_metadata = require('app.src.config.open_weather_client_metadata')

-- Примеры поддерживаемых запросов:
-- http://localhost:8081/weather/current?latitude=...&longitude=...
-- http://localhost:8081/weather/hourly?latitude=...&longitude=...
-- http://localhost:8081/weather/minutely_15?latitude=...&longitude=...
local function get_weather(request_data)
    -- Получаем и проверяем параметры интеграции с OpenMeteo API
    local global_cfg = cartridge.config_get_deepcopy()
    if (global_cfg == nil) then
        error("Empty cluster configuration at section <"
            ..weather_provider_metadata.get_root_cgk_key()..">")
    end

    local cfg_root_key = weather_provider_metadata.get_root_cgk_key()
    local weather_cfg = global_cfg[cfg_root_key]

    -- Формируем параметры вызова
    local actuality = string.sub(
                                    request_data.path,
                                    string.len(weather_provider_metadata.get_route_home_path()) + 1,
                                    string.len(request_data.path)
    )

    local x_coord = request_data:query_param(X_COORD_QUERY_PARAM)
    local y_coord = request_data:query_param(Y_COORD_QUERY_PARAM)

    log.info("Preparing query: actuality = "..actuality..", x_coord = "..x_coord..", y_coord = "..y_coord)
    local response = cached_weather_provider.get_http_weather_data(weather_cfg, x_coord, y_coord, actuality)


    local result_body = {}
    if (response.error_message ~= "") then
        result_body = response.error_message
    else
        result_body = response.data
    end

    local result =  {
                        body = response.data,
                        headers = {
                            ['content-type'] = 'application/json; charset=utf8',
                            ['x-cached-data'] = response.cached,
                            ['x-cache-ttl'] = response.ttl,
                            ['x-cache-hit-rate'] = response.cache_hit_rate
                        },
                        status = response.status
    }
    log.info("Retrieved data: "..json.encode(result))
    return result
end

return {
    get_weather = get_weather
}


