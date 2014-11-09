function string.trim(s)
	return s:match "^%s*(.-)%s*$"
end

function recursive_print_table(t, i)
	i = i or 0
	local k = ''
	for j = 0, i do
		k = k .. '\t'
	end
	for a, b in pairs(t) do
		if type(b) ~= 'table' then
			print(k .. a, b)
		else
			print(k .. a .. ':')
			recursive_print_table(b, i + 1)
		end
	end
end
