return function(wordlist)
    local str = ""
	for _,v in pairs(wordlist) do
		str = str .. Screen.String(v) .. ( _ < #wordlist and "::" or "" )
    end
    return str
end