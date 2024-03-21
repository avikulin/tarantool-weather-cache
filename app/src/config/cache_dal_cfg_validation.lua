---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by andreyv.
--- DateTime: 21.03.2024 00:07
---

local utils = require('app.src.utils.validation_utils')
local cache_dal_metadata = require('app.src.config.cache_dal_metadata')
local log = require('log').new("cache_dal_cfg_validation")
log.cfg{ level='info'}

local function validate_config(config)
    if (config == nil) then
        log.error("Passes config object is empty")
        return false
    end

    -- собираем имена параметров
    local cache_size_cfg_key = cache_dal_metadata.get_cfg_cache_size_key()
    local cache_strategy_cfg_key = cache_dal_metadata.get_cfg_cache_strategy_key()
    local cache_ttl_limit_cfg_key = cache_dal_metadata.get_cfg_ttl_key()

    -- получаем параметры конфигурации
    local param_cache_size = config[cache_size_cfg_key]
    local param_cache_strategy = config[cache_strategy_cfg_key]
    local param_ttl_limit = config[cache_ttl_limit_cfg_key]

    if (param_cache_size and param_cache_strategy and param_ttl_limit) then
        log.info("Parsed <cache-dal> configuration data: "
            ..cache_size_cfg_key.." = "..param_cache_size..", "
            ..cache_strategy_cfg_key.." = "..param_cache_strategy..", "
            ..cache_ttl_limit_cfg_key.." = "..param_ttl_limit
        )
    end

    -- валидируем параметры конфигурации
    local err_msg = "Cluster global configuration error at <cache-dal> section"
    if (
        not utils.validate_numeric_value(cache_size_cfg_key, param_cache_size, 0, 1000000, err_msg) or
        not utils.validate_numeric_value(cache_ttl_limit_cfg_key, param_ttl_limit, 0, 3600, err_msg) or
        not utils.validate_string_value(cache_strategy_cfg_key, param_cache_strategy, err_msg) or
        not utils.validate_value_present_in_array(cache_strategy_cfg_key,
                                                  cache_dal_metadata.get_available_eviction_strategies(),
                                                  string.upper(param_cache_strategy),
                                                  err_msg
        )
    ) then
        return false
    end

    return true
end

return {validate_config = validate_config}
