" Default GUI Colours
let s:foreground = "f3f3f3"
let s:background = "141414"
let s:selection = "333333"
let s:line = "282a2e"
let s:comment = "818181"
let s:bright = "f3f3f3"
let s:shade = "b4b4b4"
let s:mid = "c5c5c5"
let s:window = "4d5057"

" Console 256 Colours
if !has("gui_running")
	let s:background = "212121"
	let s:window = "5e5e5e"
	let s:line = "3a3a3a"
	let s:selection = "585858"
    let s:terminal_italic=1
end

hi clear

syntax reset

let g:colors_name = "Soot"

if has("gui_running") || &t_Co == 88 || &t_Co == 256
	" Returns an approximate grey index for the given grey level
	fun <SID>grey_number(x)
		if &t_Co == 88
			if a:x < 23
				return 0
			elseif a:x < 69
				return 1
			elseif a:x < 103
				return 2
			elseif a:x < 127
				return 3
			elseif a:x < 150
				return 4
			elseif a:x < 173
				return 5
			elseif a:x < 196
				return 6
			elseif a:x < 219
				return 7
			elseif a:x < 243
				return 8
			else
				return 9
			endif
		else
			if a:x < 14
				return 0
			else
				let l:n = (a:x - 8) / 10
				let l:m = (a:x - 8) % 10
				if l:m < 5
					return l:n
				else
					return l:n + 1
				endif
			endif
		endif
	endfun

	" Returns the actual grey level represented by the grey index
	fun <SID>grey_level(n)
		if &t_Co == 88
			if a:n == 0
				return 0
			elseif a:n == 1
				return 46
			elseif a:n == 2
				return 92
			elseif a:n == 3
				return 115
			elseif a:n == 4
				return 139
			elseif a:n == 5
				return 162
			elseif a:n == 6
				return 185
			elseif a:n == 7
				return 208
			elseif a:n == 8
				return 231
			else
				return 255
			endif
		else
			if a:n == 0
				return 0
			else
				return 8 + (a:n * 10)
			endif
		endif
	endfun

	" Returns the palette index for the given grey index
	fun <SID>grey_colour(n)
		if &t_Co == 88
			if a:n == 0
				return 16
			elseif a:n == 9
				return 79
			else
				return 79 + a:n
			endif
		else
			if a:n == 0
				return 16
			elseif a:n == 25
				return 231
			else
				return 231 + a:n
			endif
		endif
	endfun

	" Returns an approximate colour index for the given colour level
	fun <SID>rgb_number(x)
		if &t_Co == 88
			if a:x < 69
				return 0
			elseif a:x < 172
				return 1
			elseif a:x < 230
				return 2
			else
				return 3
			endif
		else
			if a:x < 75
				return 0
			else
				let l:n = (a:x - 55) / 40
				let l:m = (a:x - 55) % 40
				if l:m < 20
					return l:n
				else
					return l:n + 1
				endif
			endif
		endif
	endfun

	" Returns the actual colour level for the given colour index
	fun <SID>rgb_level(n)
		if &t_Co == 88
			if a:n == 0
				return 0
			elseif a:n == 1
				return 139
			elseif a:n == 2
				return 205
			else
				return 255
			endif
		else
			if a:n == 0
				return 0
			else
				return 55 + (a:n * 40)
			endif
		endif
	endfun

	" Returns the palette index for the given R/G/B colour indices
	fun <SID>rgb_colour(x, y, z)
		if &t_Co == 88
			return 16 + (a:x * 16) + (a:y * 4) + a:z
		else
			return 16 + (a:x * 36) + (a:y * 6) + a:z
		endif
	endfun

	" Returns the palette index to approximate the given R/G/B colour levels
	fun <SID>colour(r, g, b)
		" Get the closest grey
		let l:gx = <SID>grey_number(a:r)
		let l:gy = <SID>grey_number(a:g)
		let l:gz = <SID>grey_number(a:b)

		" Get the closest colour
		let l:x = <SID>rgb_number(a:r)
		let l:y = <SID>rgb_number(a:g)
		let l:z = <SID>rgb_number(a:b)

		if l:gx == l:gy && l:gy == l:gz
			" There are two possibilities
			let l:dgr = <SID>grey_level(l:gx) - a:r
			let l:dgg = <SID>grey_level(l:gy) - a:g
			let l:dgb = <SID>grey_level(l:gz) - a:b
			let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
			let l:dr = <SID>rgb_level(l:gx) - a:r
			let l:dg = <SID>rgb_level(l:gy) - a:g
			let l:db = <SID>rgb_level(l:gz) - a:b
			let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
			if l:dgrey < l:drgb
				" Use the grey
				return <SID>grey_colour(l:gx)
			else
				" Use the colour
				return <SID>rgb_colour(l:x, l:y, l:z)
			endif
		else
			" Only one possibility
			return <SID>rgb_colour(l:x, l:y, l:z)
		endif
	endfun

	" Returns the palette index to approximate the 'rrggbb' hex string
	fun <SID>rgb(rgb)
		let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
		let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
		let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

		return <SID>colour(l:r, l:g, l:b)
	endfun

	" Sets the highlighting for the given group
	fun <SID>X(group, fg, bg, attr)
		if a:fg != ""
			exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
		endif
		if a:bg != ""
			exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
		endif
		if a:attr != ""
			exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
		endif
	endfun

	" Vim Highlighting
	call <SID>X("Normal", s:foreground, s:background, "")
	call <SID>X("LineNr", s:selection, "", "")
	call <SID>X("NonText", s:selection, "", "")
	call <SID>X("SpecialKey", s:selection, "", "")
	call <SID>X("Search", s:background, s:bright, "")
	call <SID>X("TabLine", s:window, s:foreground, "reverse")
	call <SID>X("TabLineFill", s:window, s:foreground, "reverse")
	call <SID>X("StatusLine", s:window, s:bright, "reverse")
	call <SID>X("StatusLineNC", s:window, s:foreground, "reverse")
	call <SID>X("VertSplit", s:window, s:window, "none")
	call <SID>X("Visual", "", s:selection, "")
	call <SID>X("Directory", s:mid, "", "")
	call <SID>X("ModeMsg", s:shade, "", "")
	call <SID>X("MoreMsg", s:shade, "", "")
	call <SID>X("Question", s:shade, "", "")
	call <SID>X("WarningMsg", s:shade, "", "")
	call <SID>X("MatchParen", "", s:selection, "")
	call <SID>X("Folded", s:comment, s:background, "")
	call <SID>X("FoldColumn", "", s:background, "")
	if version >= 700
		call <SID>X("CursorLine", "", s:line, "none")
		call <SID>X("CursorColumn", "", s:line, "none")
		call <SID>X("PMenu", s:foreground, s:selection, "none")
		call <SID>X("PMenuSel", s:foreground, s:selection, "reverse")
		call <SID>X("SignColumn", "", s:background, "none")
	end
	if version >= 703
		call <SID>X("ColorColumn", "", s:line, "none")
	end

	" Standard Highlighting
	call <SID>X("Comment", s:comment, "", "")
	call <SID>X("Todo", s:comment, s:background, "")
	call <SID>X("Title", s:comment, "", "")
	call <SID>X("Identifier", s:shade, "", "none")
	call <SID>X("Statement", s:bright, "", "")
	call <SID>X("Conditional", s:bright, "", "")
	call <SID>X("Repeat", s:foreground, "", "")
	call <SID>X("Structure", s:mid, "", "")
	call <SID>X("Function", s:bright, "", "")
	call <SID>X("Constant", s:bright, "", "")
	call <SID>X("Keyword", s:bright, "", "")
	call <SID>X("String", s:shade, "", "")
	call <SID>X("Special", s:foreground, "", "")
	call <SID>X("PreProc", s:mid, "", "")
	call <SID>X("Operator", s:mid, "", "none")
	call <SID>X("Type", s:foreground, "", "none")
	call <SID>X("Define", s:mid, "", "none")
	call <SID>X("Include", s:mid, "", "")
	"call <SID>X("Ignore", "666666", "", "")

	" Vim Highlighting
	call <SID>X("vimCommand", s:shade, "", "none")

	" C Highlighting
	call <SID>X("cType", s:bright, "", "")
	call <SID>X("cStorageClass", s:mid, "", "")
	call <SID>X("cConditional", s:mid, "", "")
	call <SID>X("cRepeat", s:mid, "", "")

	" PHP Highlighting
	call <SID>X("phpVarSelector", s:shade, "", "")
	call <SID>X("phpKeyword", s:mid, "", "")
	call <SID>X("phpRepeat", s:mid, "", "")
	call <SID>X("phpConditional", s:mid, "", "")
	call <SID>X("phpStatement", s:mid, "", "")
	call <SID>X("phpMemberSelector", s:foreground, "", "")
    call <SID>X("phpInclude", s:bright, "", "")
    call <SID>X("phpKeyword", s:bright, "", "")
    call <SID>X("phpUseClass", s:bright, "", "")
    call <SID>X("phpClassExtends", s:bright, "", "")
    call <SID>X("phpType", s:bright, "", "")
    call <SID>X("phpFunction", s:mid, "", "")
    call <SID>X("phpStaticClasses", s:bright, "", "")
    call <SID>X("phpMethod", s:mid, "", "")
    call <SID>X("phpIdentifier", s:bright, "", "")
    call <SID>X("phpOperator", s:foreground, "", "")

	" Ruby Highlighting
	call <SID>X("rubySymbol", s:shade, "", "")
	call <SID>X("rubyConstant", s:bright, "", "")
	call <SID>X("rubyAccess", s:bright, "", "")
	call <SID>X("rubyAttribute", s:mid, "", "")
	call <SID>X("rubyInclude", s:mid, "", "")
	call <SID>X("rubyLocalVariableOrMethod", s:bright, "", "")
	call <SID>X("rubyCurlyBlock", s:bright, "", "")
	call <SID>X("rubyStringDelimiter", s:shade, "", "")
	call <SID>X("rubyInterpolationDelimiter", s:bright, "", "")
	call <SID>X("rubyConditional", s:mid, "", "")
	call <SID>X("rubyRepeat", s:mid, "", "")
	call <SID>X("rubyControl", s:mid, "", "")
	call <SID>X("rubyException", s:mid, "", "")

	" Crystal Highlighting
	call <SID>X("crystalSymbol", s:shade, "", "")
	call <SID>X("crystalConstant", s:bright, "", "")
	call <SID>X("crystalAccess", s:bright, "", "")
	call <SID>X("crystalAttribute", s:mid, "", "")
	call <SID>X("crystalInclude", s:mid, "", "")
	call <SID>X("crystalLocalVariableOrMethod", s:bright, "", "")
	call <SID>X("crystalCurlyBlock", s:bright, "", "")
	call <SID>X("crystalStringDelimiter", s:shade, "", "")
	call <SID>X("crystalInterpolationDelimiter", s:bright, "", "")
	call <SID>X("crystalConditional", s:mid, "", "")
	call <SID>X("crystalRepeat", s:mid, "", "")
	call <SID>X("crystalControl", s:mid, "", "")
	call <SID>X("crystalException", s:mid, "", "")

	" Python Highlighting
	call <SID>X("pythonInclude", s:mid, "", "")
	call <SID>X("pythonStatement", s:mid, "", "")
	call <SID>X("pythonConditional", s:mid, "", "")
	call <SID>X("pythonRepeat", s:mid, "", "")
	call <SID>X("pythonException", s:mid, "", "")
	call <SID>X("pythonFunction", s:mid, "", "")
	call <SID>X("pythonPreCondit", s:mid, "", "")
	call <SID>X("pythonRepeat", s:mid, "", "")
	call <SID>X("pythonExClass", s:bright, "", "")

	" JavaScript Highlighting
	call <SID>X("javaScriptBraces", s:foreground, "", "")
	call <SID>X("javaScriptFunction", s:bright, "", "")
	call <SID>X("javaScriptConditional", s:mid, "", "")
	call <SID>X("javaScriptRepeat", s:bright, "", "")
	call <SID>X("javaScriptNumber", s:bright, "", "")
	call <SID>X("javaScriptMember", s:bright, "", "")
	call <SID>X("javascriptNull", s:bright, "", "")
	call <SID>X("javascriptGlobal", s:bright, "", "")
	call <SID>X("javascriptStatement", s:bright, "", "")
  call <SID>X("javaScriptIdentifier", s:bright, "", "")
  call <SID>X("javaScriptConditional", s:bright, "", "")
  call <SID>X("javaScriptExceptions", s:bright, "", "")
	call <SID>X("jsStorageClass", s:bright, "", "")
	call <SID>X("jsThis", s:bright, "", "")
  call <SID>X("jsOperator", s:foreground, "", "")
  call <SID>X("jsFuncCall", s:bright, "", "")
	call <SID>X("jsClassMethodType", s:bright, "", "")
	call <SID>X("jsNull", s:shade, "", "")
	call <SID>X("jsFunction", s:bright, "", "")
  call <SID>X("javaScriptFuncExp", s:bright, "", "")
    
  " Django highlighting 
  call <SID>X("djangoTagBlock", s:foreground, "", "")
  call <SID>X("djangoStatement", s:bright, "", "")
  call <SID>X("djangoVarBlock", s:foreground, "", "")

  " (S)CSS highlighting 
  call <SID>X("scssAmpersand", s:foreground, "", "")
  call <SID>X("scssInclude", s:bright, "", "")
  call <SID>X("cssPseudoClassId", s:shade, "", "")
  call <SID>X("scssVariable", s:bright, "", "")
  call <SID>X("scssFunctionName", s:mid, "", "")
  
  " Spelling 
  call <SID>X("SpellBad", s:shade, s:background, "")
  call <SID>X("SpellCap", s:mid, s:background, "")
  call <SID>X("SpellRare", s:shade, s:background, "")
  call <SID>X("SpellLocal", s:bright, s:background, "")

  hi SpellBad cterm=underline
  hi SpellCap cterm=underline
  hi SpellRare cterm=underline
  hi SpellLocal cterm=underline

	" CoffeeScript Highlighting
	call <SID>X("coffeeRepeat", s:mid, "", "")
	call <SID>X("coffeeConditional", s:mid, "", "")
	call <SID>X("coffeeKeyword", s:mid, "", "")
	call <SID>X("coffeeObject", s:bright, "", "")

	" HTML Highlighting
	call <SID>X("htmlTag", s:shade, "", "")
	call <SID>X("htmlTagName", s:shade, "", "")
	call <SID>X("htmlArg", s:bright, "", "")
	call <SID>X("htmlScriptTag", s:shade, "", "")
	call <SID>X("djangoVarError", s:foreground, s:background, "")
  
  " JSX Highlighting 
  call <SID>X("jsxAttribKeyword", s:bright, "", "")
  call <SID>X("jsxAttrib", s:bright, "", "")
  call <SID>X("jsxClosePunct", s:shade, "", "")
  call <SID>X("jsxOpenPunct", s:shade, "", "")
  call <SID>X("jsxCloseString", s:shade, "", "") 
  call <SID>X("jsxComponentName", s:mid, "", "")

  " CSS Highlighting 
  call <SID>X("cssBraces", s:foreground, "", "")

	" Diff Highlighting
	call <SID>X("diffAdd", "", "4c4e39", "")
	call <SID>X("diffDelete", s:background, s:shade, "")
	call <SID>X("diffChange", "", "2B5B77", "")
	call <SID>X("diffText", s:line, s:mid, "")

	" ShowMarks Highlighting
	call <SID>X("ShowMarksHLl", s:bright, s:background, "none")
	call <SID>X("ShowMarksHLo", s:mid, s:background, "none")
	call <SID>X("ShowMarksHLu", s:bright, s:background, "none")
	call <SID>X("ShowMarksHLm", s:mid, s:background, "none")

	" Lua Highlighting
	call <SID>X("luaStatement", s:mid, "", "")
	call <SID>X("luaRepeat", s:mid, "", "")
	call <SID>X("luaCondStart", s:mid, "", "")
	call <SID>X("luaCondElseif", s:mid, "", "")
	call <SID>X("luaCond", s:mid, "", "")
	call <SID>X("luaCondEnd", s:mid, "", "")

	" Cucumber Highlighting
	call <SID>X("cucumberGiven", s:mid, "", "")
	call <SID>X("cucumberGivenAnd", s:mid, "", "")

	" Go Highlighting
	call <SID>X("goDirective", s:mid, "", "")
	call <SID>X("goDeclaration", s:mid, "", "")
	call <SID>X("goStatement", s:mid, "", "")
	call <SID>X("goConditional", s:mid, "", "")
	call <SID>X("goConstants", s:bright, "", "")
	call <SID>X("goTodo", s:bright, "", "")
	call <SID>X("goDeclType", s:mid, "", "")
	call <SID>X("goBuiltins", s:mid, "", "")
	call <SID>X("goRepeat", s:mid, "", "")
	call <SID>X("goLabel", s:mid, "", "")

	" Clojure Highlighting
	call <SID>X("clojureConstant", s:bright, "", "")
	call <SID>X("clojureBoolean", s:bright, "", "")
	call <SID>X("clojureCharacter", s:bright, "", "")
	call <SID>X("clojureKeyword", s:shade, "", "")
	call <SID>X("clojureNumber", s:bright, "", "")
	call <SID>X("clojureString", s:shade, "", "")
	call <SID>X("clojureRegexp", s:shade, "", "")
	call <SID>X("clojureParen", s:mid, "", "")
	call <SID>X("clojureVariable", s:bright, "", "")
	call <SID>X("clojureCond", s:mid, "", "")
	call <SID>X("clojushadeefine", s:mid, "", "")
	call <SID>X("clojureException", s:shade, "", "")
	call <SID>X("clojureFunc", s:mid, "", "")
	call <SID>X("clojureMacro", s:mid, "", "")
	call <SID>X("clojureRepeat", s:mid, "", "")
	call <SID>X("clojureSpecial", s:mid, "", "")
	call <SID>X("clojureQuote", s:mid, "", "")
	call <SID>X("clojureUnquote", s:mid, "", "")
	call <SID>X("clojureMeta", s:mid, "", "")
	call <SID>X("clojushadeeref", s:mid, "", "")
	call <SID>X("clojureAnonArg", s:mid, "", "")
	call <SID>X("clojureRepeat", s:mid, "", "")
	call <SID>X("clojushadeispatch", s:mid, "", "")

	" Scala Highlighting
	call <SID>X("scalaKeyword", s:mid, "", "")
	call <SID>X("scalaKeywordModifier", s:mid, "", "")
	call <SID>X("scalaOperator", s:mid, "", "")
	call <SID>X("scalaPackage", s:shade, "", "")
	call <SID>X("scalaFqn", s:foreground, "", "")
	call <SID>X("scalaFqnSet", s:foreground, "", "")
	call <SID>X("scalaImport", s:mid, "", "")
	call <SID>X("scalaBoolean", s:bright, "", "")
	call <SID>X("scalaDef", s:mid, "", "")
	call <SID>X("scalaVal", s:mid, "", "")
	call <SID>X("scalaVar", s:mid, "", "")
	call <SID>X("scalaClass", s:mid, "", "")
	call <SID>X("scalaObject", s:mid, "", "")
	call <SID>X("scalaTrait", s:mid, "", "")
	call <SID>X("scalaDefName", s:mid, "", "")
	call <SID>X("scalaValName", s:foreground, "", "")
	call <SID>X("scalaVarName", s:foreground, "", "")
	call <SID>X("scalaClassName", s:foreground, "", "")
	call <SID>X("scalaType", s:bright, "", "")
	call <SID>X("scalaTypeSpecializer", s:bright, "", "")
	call <SID>X("scalaAnnotation", s:bright, "", "")
	call <SID>X("scalaNumber", s:bright, "", "")
	call <SID>X("scalaDefSpecializer", s:bright, "", "")
	call <SID>X("scalaClassSpecializer", s:bright, "", "")
	call <SID>X("scalaBackTick", s:shade, "", "")
	call <SID>X("scalaRoot", s:foreground, "", "")
	call <SID>X("scalaMethodCall", s:mid, "", "")
	call <SID>X("scalaCaseType", s:bright, "", "")
	call <SID>X("scalaLineComment", s:comment, "", "")
	call <SID>X("scalaComment", s:comment, "", "")
	call <SID>X("scalaDocComment", s:comment, "", "")
	call <SID>X("scalaDocTags", s:comment, "", "")
	call <SID>X("scalaEmptyString", s:shade, "", "")
	call <SID>X("scalaMultiLineString", s:shade, "", "")
	call <SID>X("scalaUnicode", s:bright, "", "")
	call <SID>X("scalaString", s:shade, "", "")
	call <SID>X("scalaStringEscape", s:shade, "", "")
	call <SID>X("scalaSymbol", s:bright, "", "")
	call <SID>X("scalaChar", s:bright, "", "")
	call <SID>X("scalaXml", s:shade, "", "")
	call <SID>X("scalaConstructorSpecializer", s:bright, "", "")
	call <SID>X("scalaBackTick", s:mid, "", "")

	" Git
	call <SID>X("diffAdded", s:shade, "", "")
	call <SID>X("diffRemoved", s:shade, "", "")
	call <SID>X("gitcommitSummary", "", "", "bold")

	" Delete Functions
	delf <SID>X
	delf <SID>rgb
	delf <SID>colour
	delf <SID>rgb_colour
	delf <SID>rgb_level
	delf <SID>rgb_number
	delf <SID>grey_colour
	delf <SID>grey_level
	delf <SID>grey_number

endif
