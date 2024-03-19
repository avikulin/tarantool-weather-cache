---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by avikulin.
--- DateTime: 19.03.2024 20:35
---
local CONFIG_URI_KEY<const> = "uri"
local CONFIG_X_COORD<const> = "x_coord_param"
local CONFIG_Y_COORD<const> = "y_coord_param"
local CONFIG_ACTUALITY_OPTS<const> = "actuality_options"
local CONFIG_QUERY_OPTIONS<const> = "query_options"
local URI_ROUTE_HOME_PATH<const> = "weather/"


local function get_uri_cfg_key()
    return CONFIG_URI_KEY
end

local function get_latitude_cfg_key()
    return CONFIG_Y_COORD
end

local function get_longitude_cfg_key()
    return CONFIG_X_COORD
end

local function get_actuality_opts_cfg_key()
    return CONFIG_ACTUALITY_OPTS
end

local function get_query_opts_cfg_key()
    return CONFIG_QUERY_OPTIONS
end

local function get_route_home_path()
    return URI_ROUTE_HOME_PATH
end

return {
    get_route_home_path = get_route_home_path,
    get_query_opts_cfg_key = get_query_opts_cfg_key,
    get_actuality_opts_cfg_key = get_actuality_opts_cfg_key,
    get_longitude_cfg_key = get_longitude_cfg_key,
    get_latitude_cfg_key = get_latitude_cfg_key,
    get_uri_cfg_key = get_uri_cfg_key
}
