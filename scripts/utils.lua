bool_to_number={ [true]=1, [false]=0 }


-- from https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
-- dumps a table in a readable string
function dump_table(o, depth)
    if depth == nil then
        depth = 0
    end
    if type(o) == 'table' then
        local tabs = ('\t'):rep(depth)
        local tabs2 = ('\t'):rep(depth + 1)
        local s = '{\n'
        for k, v in pairs(o) do
            local kc = k
            if type(k) ~= 'number' then
                kc = '"' .. k .. '"'
            end
            s = s .. tabs2 .. '[' .. kc .. '] = ' .. dump_table(v, depth + 1) .. ',\n'
        end
        return s .. tabs .. '}'
    else
        return tostring(o)
    end
end

function tableContains(table, element)
    if table == nil then
        return false
    end
    for _, value in pairs(table) do
      if value == element then
        return true
      end
    end
    return false
end

function tableHasKey(table, element)
    for key, value in pairs(table) do
      if key == element then
        return true
      end
    end
    return false
end

function removeFromArray(array, element)
    for i, value in ipairs(array) do
        if value == element then
            table.remove(array, i)
        end
    end
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end