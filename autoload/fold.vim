function! fold#text() abort " {{{1

	"get first non-blank line
	let fs = v:foldstart
	let linep = s:getnonblankline(fs)
	let line = linep[0]
	let lpos = linep[1]

	" remove leading comments from line
	let line = s:removeleadingcomment(line)
	" remove foldmarker from line
	let line = s:removefoldmarker(line)

	" use next line for fold if marker is on otherwise empty line
	if &l:fdm == 'marker' && line =~# '^\s*$' && lpos < v:foldend
		let line = s:getnonblankline(lpos + 1)[0]
		let line = s:removeleadingcomment(line)
		let line = s:removefoldmarker(line)
	endif

	let foldsymbol='+'
	let repeatsymbol='-'
	let prefix = foldsymbol . ' '

	let net_width = dimensions#NetWindowWidth() " text window width

	" get text width by probing for textwidth and colorcolumn
	if &colorcolumn != ''
		let column = split(&colorcolumn, ',')[0]
		if strpart(column, 0, 1) == '+'
			let width = &textwidth
		else
			let width = column - 1
		endif
	else
		let width = net_width
	endif
	" use smaller of net_width and width for fold size
	if width > net_width
		let w = net_width
	else
		let w = width
	endif

	" setup fold string elements
	let foldSize = 1 + v:foldend - v:foldstart
	let foldSizeStr = printf(' %d lines ', foldSize)
	let foldLevelStr = '+'. v:folddashes
	let lineCount = line('$')
	let foldPercentage = printf('[%4.1f%%]', (foldSize*1.0)/lineCount*100)
	let expansionString = repeat(repeatsymbol, w -
		\ strwidth(prefix.foldSizeStr.line.foldLevelStr.foldPercentage))
	let foldinfo = foldSizeStr . foldPercentage . foldLevelStr
	" return fold string
	return prefix . line . expansionString . foldinfo
endfunction

function! s:removeleadingcomment(line) abort " {{{1
	let l:pat  = matchstr(&l:cms, '^\V\.\{-}\ze%s\m')
	return substitute(a:line, '^\s*'.l:pat.'\s*', '', '')
endfunction

function! s:removefoldmarker(line) abort " {{{1
	let l:pat  = matchstr(&l:cms, '^\V\.\{-}\ze%s\m')
	let l:pat  = '\%('. l:pat. '\)\?\s*'. split(&l:fmr, ',')[0]. '\s*\d*'
	let l:string = substitute(a:line, l:pat, ' ', '')
	return substitute(l:string, '\s\+$', ' ', '')
endfunction

function! s:getnonblankline(fs) abort " {{{1
	let l:fs = a:fs
	while getline(l:fs) =~# '^\s*$' | let l:fs = nextnonblank(l:fs + 1) | endwhile
	if l:fs > v:foldend
		let l:line = getline(v:foldstart)
	else
		let l:line = substitute(getline(l:fs), '\t', repeat(' ', &tabstop), 'g')
	endif
	return [l:line, l:fs]
endfunction
" }}}

" vim: set ts=2 sw=2 tw=80 noet fdm=marker ft=vim :
