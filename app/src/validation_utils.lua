---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by avikulin.
--- DateTime: 19.03.2024 17:26
---
local log = require('log')

local function check_string_is_empty(s)
    return s == nil or s == ''
end

local function validate_string_value(name, value, err_msg)
    if (value ~= nil and type(value) =="string" and check_string_is_empty(value)) then
        log.error(err_msg..".\nPassed value for ["..name.."] is not a valid string: "..value)
        return false
    end

    return true
end

local function validate_array_value(name, array, err_msg)
    if (array == nil or type(array)~="array" or #array == 0) then
        log.error(err_msg..".\nPassed value for ["..name.."] is not a valid array: "..array)
        return false
    end
    return true
end

local function validate_numeric_value(name, value, min, max, err_msg)
    if (type(value) ~= "number") then
        log.error(err_msg..".\nPassed value for ["..name.."] is not a numeric: "..value)
        return false
    end

    local x = tonumber(value)
    if ((x < min) or (x > max)) then
        log.error(err_msg..".\nPassed value for ["..name.."] exceeds available range: min = "..min..",
        max = "..max.."Actual value: "..value)
        return false
    end
    return true
end

local function validate_value_present_in_array(name, array, value, err_msg)
    if ( ~validate_array(name, array) or ~validate_string(name, value)) then
        return false
    end

    for i,v in ipairs(array) do
        if (v == value) then
            return true
        end
    end

    log.error(err_msg..".\nPassed value ("..value..") for ["..name.."] is absent in array "..array)
    return false
end

return {
    validate_value_present_in_array = validate_value_present_in_array,
    validate_numeric_value = validate_numeric_value,
    check_string_is_empty = check_string_is_empty,
    validate_array_value = validate_array_value,
    validate_string_value = validate_string_value
}