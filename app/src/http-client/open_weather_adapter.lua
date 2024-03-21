---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by andreyv.
--- DateTime: 20.03.2024 21:14
---

local weather_provider_metadata = require('app.src.config.open_weather_client_metadata')
local utils = require('app.src.utils.validation_utils')

local http_client = require('http.client').new()
local json = require('json')
local log = require('log').new("open_meteo_adapter")
log.cfg{ level='info'}

local function get_http_weather_data(weather_cfg, x_coord, y_coord, actuality)
    -- Проверяем корректность конфигурации
    if (weather_cfg == nil) then
        local msg = "Configuration dataset is empty"
        log.error(msg)
        error(msg)
    end

    -- Читаем параметры конфигурации
    local uri_param = weather_cfg[weather_provider_metadata.get_uri_cfg_key()]
    local long_param = weather_cfg[weather_provider_metadata.get_longitude_cfg_key()]
    local lat_param = weather_cfg[weather_provider_metadata.get_latitude_cfg_key()]
    local actuality_opts = weather_cfg[weather_provider_metadata.get_actuality_opts_cfg_key()]
    local query_opts = weather_cfg[weather_provider_metadata.get_query_opts_cfg_key()]

    -- Валидируем параметры вызова на соответствие конфигурации
    local err_msg = "Invalid <OpenWeather:getWeather> query parameters"
    if (
        not utils.validate_numeric_value("x_coord", x_coord, -180, 180, err_msg) or
        not utils.validate_numeric_value("y_coord", y_coord, -180, 180, err_msg) or
        not utils.validate_value_present_in_array("actuality", actuality_opts, actuality, err_msg)

    ) then
        local  msg = "ERROR!\nInvalid run-time parameters passed: "
            .."x_coord = "..x_coord..", "
            .."y_coord = "..y_coord..", "
            .."actuality = "..actuality

        log.error(msg)
        error(msg)
    end

    -- Выполняем подготовку параметров вызова OpenMeteo API
    if (query_opts == nil or #query_opts == 0) then
        error("Query options is null/empty")
    end

    log.info("Configured parameters for weather query: "..json.encode(query_opts))
    local weather_options = table.concat(query_opts,",")
    log.info("Compiled weather parameter: "..actuality.."="..weather_options)

    local http_params_values = {}

    http_params_values[long_param] = x_coord
    http_params_values[lat_param] = y_coord
    http_params_values[actuality] = weather_options

    log.info(json.encode(http_params_values))

    local response = http_client:get(uri_param, {
        params = http_params_values
    })

    if (response ~= nil) then
        log.info("Received response: "..json.encode(response))
        return response:decode()
    end

    return "NO DATA"
end

return {
    get_http_weather_data = get_http_weather_data
}
