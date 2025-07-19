local tab = '    '

-- https://stackoverflow.com/a/27028488, heavily modified
function dump(o, depth)
    depth = depth or 1
    if type(o) ~= 'table' or (getmetatable(o) and getmetatable(o).__tostring) then
        return tostring(o)
    else
        local output = '{'
        local has_value = false

        for key,value in pairs(o) do
            has_value = true
            
            if type(key) == 'number' then
                key =  '[' .. key .. ']'
            elseif type(key) ~= 'string' or tonumber(key) then
                key = '["' .. tostring(key) .. '"]'
            end

            output = output .. ("\n%s%s = %s,"):format(
                tab:rep(depth),
                key,
                dump(value, depth + 1)
            )
        end
        return output .. ('%s}'):format(has_value and ("\n" .. tab:rep(depth - 1)) or "")
    end
end

function printObj(o) print(dump(o)) end