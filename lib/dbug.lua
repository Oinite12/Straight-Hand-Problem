DBUG = {}
DBUG.tab_format = '    '
DBUG.tab = function(size)
    size = size or 0
    return DBUG.tab_format:rep(size)
end

-- https://stackoverflow.com/a/27028488, heavily modified
function dump(obj, depth)
    depth = depth or 1 -- For tabbing

    if getmetatable(obj) and getmetatable(obj).__tostring then
        return obj:__tostring(depth)
    end

    if type(obj) ~= 'table' then
        return tostring(obj)
    end
    
    local tab = DBUG.tab
    local output_table = {}
    local has_value = false

    for key, value in pairs(obj) do
        has_value = true
        
        if type(key) == 'number' then
            key = ('[%s]'):format(key)
        -- first character number not permitted as naked table key
        elseif (type(key) ~= 'string' or tonumber(key:sub(1,1))) then
            key = ('["%s"]'):format(key)
        end

        local value_dump = dump(value, depth + 1)
        table.insert(output_table, ("\n%s%s = %s,"):format(
            tab(depth), key, value_dump
        ))
    end

    local formatted_output = table.concat(output_table)
    local tab_or_none = has_value and ("\n" .. tab(depth - 1)) or ""
    return ('{%s%s}'):format(formatted_output, tab_or_none)
end

function printObj(obj) print(dump(obj)) end