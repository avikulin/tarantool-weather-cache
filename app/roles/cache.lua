---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by avikulin.
--- DateTime: 19.03.2024 13:50
---


local cache_dal_metadata = require('app.src.config.cache_dal_metadata')
local cache_dal_cfg_validator = require('app.src.config.cache_dal_cfg_validation')
local cache_ctx = require('app.src.cache-dal.cache_ctx_adapter')

local json = require('json')
local log = require('log').new("app.roles.cache")
log.cfg{ level='info'}

local function init(opts)
    rawset(_G, "cache_put", cache_ctx.cache_put )
    rawset(_G, "cache_lookup", cache_ctx.cache_lookup )
    rawset(_G, "get_number_of_cached_items", cache_ctx.get_number_of_cached_items )
    rawset(_G, "get_most_aged_item_id", cache_ctx.get_most_aged_item_id )
    rawset(_G, "get_most_late_accessed_item_id", cache_ctx.get_most_late_accessed_item_id )
    rawset(_G, "get_less_usage_item_id", cache_ctx.get_less_usage_item_id )
    rawset(_G, "cache_evict", cache_ctx.cache_evict )


    if opts.is_master then
        local cache = box.schema.space.create('request_cache', { if_not_exists = true })
        cache:format({
            {name='request_key', type='string', is_nullable=false},
            {name='request_path', type='string', is_nullable=false},
            {name='bucket_id', type='unsigned', is_nullable=false},
            {name='response_data', type='string', is_nullable=false},
            {name='usage_rating', type='unsigned', is_nullable=false},
            {name='created_moment', type='datetime', is_nullable=false},
            {name='last_access_moment', type='datetime', is_nullable=true},
        })

        cache:create_index('primary', {parts = {'request_key', 'request_path'}, if_not_exists = true })
        cache:create_index('bucket_id', {parts = {'bucket_id'}, unique = false, if_not_exists = true })
        cache:create_index('created_moment_idx', {parts = {'created_moment'}, unique = false, if_not_exists = true })
        cache:create_index('last_access_moment', {parts = {'last_access_moment'}, unique = false, if_not_exists = true })
        cache:create_index('usage_rating_idx', {parts = {'usage_rating'}, unique = false, if_not_exists = true })

        box.schema.func.create('cache_put', { if_not_exists = true })
        box.schema.role.grant('public', 'execute', 'function', 'cache_put', { if_not_exists = true })

        box.schema.func.create('cache_lookup', { if_not_exists = true })
        box.schema.role.grant('public', 'execute', 'function', 'cache_lookup', { if_not_exists = true })

        box.schema.func.create('get_number_of_cached_items', { if_not_exists = true })
        box.schema.role.grant('public', 'execute', 'function', 'get_number_of_cached_items', { if_not_exists = true })

        box.schema.func.create('get_most_aged_item_id', { if_not_exists = true })
        box.schema.role.grant('public', 'execute', 'function', 'get_most_aged_item_id', { if_not_exists = true })

        box.schema.func.create('get_less_usage_item_id', { if_not_exists = true })
        box.schema.role.grant('public', 'execute', 'function', 'get_less_usage_item_id', { if_not_exists = true })

        box.schema.func.create('get_most_late_accessed_item_id', { if_not_exists = true })
        box.schema.role.grant('public', 'execute', 'function', 'get_most_late_accessed_item_id', { if_not_exists = true })

        box.schema.func.create('cache_evict', { if_not_exists = true })
        box.schema.role.grant('public', 'execute', 'function', 'cache_evict', { if_not_exists = true })
    end

    return true
end

local function stop()
    return true
end

local function validate_config(conf_new, conf_old)
    if (conf_new ~= nil) then
        local cache_cfg = conf_new[cache_dal_metadata.get_cfg_root_key()]

        if (cache_cfg == nil) then
            return true
        end
        log.info("Cluster configuration at section <"
            ..cache_dal_metadata.get_cfg_root_key()
            .."> : "..json.encode(cache_cfg))
        return cache_dal_cfg_validator.validate_config(cache_cfg)
    end
    return true
end

local function apply_config(conf, opts)
    return true
end

return {
    role_name = 'app.roles.cache',
    init = init,
    stop = stop,
    validate_config = validate_config,
    apply_config = apply_config,
    dependencies = {'cartridge.roles.vshard-storage'},
}
