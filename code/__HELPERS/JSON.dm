// FUCK!!!!

/*
n_Json v11.3.21
*/

var/list/rus_unicode_conversion = list(
	"À" = "\\u0410", "à" = "\\u0430",
	"Á" = "\\u0411", "á" = "\\u0431",
	"Â" = "\\u0412", "â" = "\\u0432",
	"Ã" = "\\u0413", "ã" = "\\u0433",
	"Ä" = "\\u0414", "ä" = "\\u0434",
	"Å" = "\\u0415", "å" = "\\u0435",
	"Æ" = "\\u0416", "æ" = "\\u0436",
	"Ç" = "\\u0417", "ç" = "\\u0437",
	"È" = "\\u0418", "è" = "\\u0438",
	"É" = "\\u0419", "é" = "\\u0439",
	"Ê" = "\\u041a", "ê" = "\\u043a",
	"Ë" = "\\u041b", "ë" = "\\u043b",
	"Ì" = "\\u041c", "ì" = "\\u043c",
	"Í" = "\\u041d", "í" = "\\u043d",
	"Î" = "\\u041e", "î" = "\\u043e",
	"Ï" = "\\u041f", "ï" = "\\u043f",
	"Ð" = "\\u0420", "ð" = "\\u0440",
	"Ñ" = "\\u0421", "ñ" = "\\u0441",
	"Ò" = "\\u0422", "ò" = "\\u0442",
	"Ó" = "\\u0423", "ó" = "\\u0443",
	"Ô" = "\\u0424", "ô" = "\\u0444",
	"Õ" = "\\u0425", "õ" = "\\u0445",
	"Ö" = "\\u0426", "ö" = "\\u0446",
	"×" = "\\u0427", "÷" = "\\u0447",
	"Ø" = "\\u0428", "ø" = "\\u0448",
	"Ù" = "\\u0429", "ù" = "\\u0449",
	"Ú" = "\\u042a", "ú" = "\\u044a",
	"Û" = "\\u042b", "û" = "\\u044b",
	"Ü" = "\\u042c", "ü" = "\\u044c",
	"Ý" = "\\u042d", "ý" = "\\u044d",
	"Þ" = "\\u042e", "þ" = "\\u044e",
	"ß" = "\\u042f", "ÿ" = "\\u044f",
	"&#255;" = "\\u044f",
	"&#x044f;" = "\\u044f",

	"¨" = "\\u0401", "¸" = "\\u0451"
	)

proc
	json2list(json)
		var/static/json_reader/_jsonr = new()
		return _jsonr.ReadObject(_jsonr.ScanJson(json))

	list2json(list/L)
		var/static/json_writer/_jsonw = new()
		return _jsonw.write(L)

	list2json_usecache(list/L)
		var/static/json_writer/_jsonw = new()
		_jsonw.use_cache = 1
		return _jsonw.write(L)

/*
Json Writer
*/

json_writer
	var
		use_cache = 0

	proc
		WriteObject(list/L, cached_data = null)
			if(use_cache && L["__json_cache"])
				return L["__json_cache"]

			. = "{"
			var/i = 1
			for(var/k in L)
				var/val = L[k]
				. += {"\"[k]\":[write(val)]"}
				if(i++ < L.len)
					. += ","
			. += "}"

		write(val)
			if(isnum(val))
				return num2text(val)
			else if(isnull(val))
				return "null"
			else if(istype(val, /list))
				if(is_associative(val))
					return WriteObject(val)
				else
					return write_array(val)
			else
				. += write_string("[val]")

		write_array(list/L)
			. = "\["
			for(var/i = 1 to L.len)
				. += write(L[i])
				if(i < L.len)
					. += ","
			. += "]"

		write_string(txt)
			var/static/list/json_escape = list("\\" = "\\\\", "\"" = "\\\"", "\n" = "\\n")+rus_unicode_conversion
			for(var/targ in json_escape)
				var/start = 1
				while(start <= lentext(txt))
					var/i = findtext(txt, targ, start)
					if(!i)
						break
					var/lrep = length(json_escape[targ])
					txt = copytext(txt, 1, i) + json_escape[targ] + copytext(txt, i + length(targ))
					start = i + lrep

			return {""[txt]""}

		is_associative(list/L)
			for(var/key in L)
				// if the key is a list that means it's actually an array of lists (stupid Byond...)
				if(!isnum(key) && !isnull(L[key]) && !istype(key, /list))
					return TRUE

/*
Json Reader
*/

json_token
	var
		value
	New(v)
		src.value = v
	text
	number
	word
	symbol
	eof

json_reader
	var
		list
			string		= list("'", "\"")
			symbols 	= list("{", "}", "\[", "]", ":", "\"", "'", ",")
			sequences 	= list("b" = 8, "t" = 9, "n" = 10, "f" = 12, "r" = 13)
			tokens
		json
		i = 1


	proc
		// scanner
		ScanJson(json)
			src.json = json
			. = new/list()
			src.i = 1
			while(src.i <= length(json))
				var/char = get_char()
				if(is_whitespace(char))
					i++
					continue
				if(string.Find(char))
					. += read_string(char)
				else if(symbols.Find(char))
					. += new/json_token/symbol(char)
				else if(is_digit(char))
					. += read_number()
				else
					. += read_word()
				i++
			. += new/json_token/eof()

		read_word()
			var/val = ""
			while(i <= length(json))
				var/char = get_char()
				if(is_whitespace(char) || symbols.Find(char))
					i-- // let scanner handle this character
					return new/json_token/word(val)
				val += char
				i++

		read_string(delim)
			var
				escape 	= FALSE
				val		= ""
			while(++i <= length(json))
				var/char = get_char()
				if(escape)
					escape=FALSE // WHICH STUPID ASSHOLE FORGOT THIS - N3X
					switch(char)
						if("\\", "'", "\"", "/", "u")
							val += char
						else
							// TODO: support octal, hex, unicode sequences
							//testing("Having trouble with \"\\[char]\" in string \"[val]\"")
							ASSERT(sequences.Find(char))
							val += ascii2text(sequences[char])
				else
					if(char == delim)
						return new/json_token/text(val)
					else if(char == "\\")
						escape = TRUE
					else
						val += char
			CRASH("Unterminated string.")

		read_number()
			var/val = ""
			var/char = get_char()
			while(is_digit(char) || char == "." || lowertext(char) == "e")
				val += char
				i++
				char = get_char()
			i-- // allow scanner to read the first non-number character
			return new/json_token/number(text2num(val))

		check_char()
			ASSERT(args.Find(get_char()))

		get_char()
			return copytext(json, i, i+1)

		is_whitespace(char)
			return char == " " || char == "\t" || char == "\n" || text2ascii(char) == 13

		is_digit(char)
			var/c = text2ascii(char)
			return 48 <= c && c <= 57 || char == "+" || char == "-"


		// parser
		ReadArray(list/tokens)
			src.tokens = tokens
			i = 1
			return read_array()


		// parser
		ReadObject(list/tokens)
			src.tokens = tokens
			. = new/list()
			i = 1
			read_token("{", /json_token/symbol)
			while(i <= tokens.len)
				var/json_token/K = get_token()
				check_type(/json_token/word, /json_token/text)
				next_token()
				read_token(":", /json_token/symbol)

				.[K.value] = read_value()

				var/json_token/S = get_token()
				check_type(/json_token/symbol)
				switch(S.value)
					if(",")
						next_token()
						continue
					if("}")
						next_token()
						return
					else
						die()

		get_token()
			return tokens[i]

		next_token()
			return tokens[++i]

		read_token(val, type)
			var/json_token/T = get_token()
			if(!(T.value == val && istype(T, type)))
				CRASH("Expected '[val]', found '[T.value]'.")
			next_token()
			return T

		check_type(...)
			var/json_token/T = get_token()
			for(var/type in args)
				if(istype(T, type))
					return
			CRASH("Bad token type: [T.type].")

		check_value(...)
			var/json_token/T = get_token()
			ASSERT(args.Find(T.value))

		read_key()
			var/char = get_char()
			if(char == "\"" || char == "'")
				return read_string(char)

		read_value()
			var/json_token/T = get_token()
			switch(T.type)
				if(/json_token/text, /json_token/number)
					next_token()
					return T.value
				if(/json_token/word)
					next_token()
					switch(T.value)
						if("true")
							return TRUE
						if("false")
							return FALSE
						if("null")
							return null
				if(/json_token/symbol)
					switch(T.value)
						if("\[")
							return read_array()
						if("{")
							return ReadObject(tokens.Copy(i))
			die()

		read_array()
			read_token("\[", /json_token/symbol)
			. = new/list()
			var/list/L = .
			while(i <= tokens.len)
				// Avoid using Add() or += in case a list is returned.
				L.len++
				L[L.len] = read_value()
				var/json_token/T = get_token()
				check_type(/json_token/symbol)
				switch(T.value)
					if(",")
						next_token()
						continue
					if("]")
						next_token()
						return
					else
						die()
						next_token()
				CRASH("Unterminated array.")


		die(json_token/T)
			if(!T) T = get_token()
			CRASH("Unexpected token: [T.value].")
