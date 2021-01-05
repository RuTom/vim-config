" Tabline
" ---

" Configuration

" Limit display of directories in path
let g:badge_tab_filename_max_dirs =
	\ get(g:, 'badge_tab_filename_max_dirs', 1)

" Limit display of characters in each directory in path
let g:badge_tab_dir_max_chars =
	\ get(g:, 'badge_tab_dir_max_chars', 5)

" Display entire tabline
function! Tabline()
	if exists('g:SessionLoad')
		" Skip tabline render during session loading
		return ''
	endif

	" Active project name
	let l:tabline =
		\ '%#TabLineAlt# %{"  " . badge#project()} '

	" Iterate through all tabs and collect labels
	let l:current = tabpagenr()
	for i in range(tabpagenr('$'))
		let l:nr = i + 1
		let l:bufnrlist = tabpagebuflist(l:nr)
		let l:bufnr = l:bufnrlist[tabpagewinnr(l:nr) - 1]

		" Left-side of single tab
		if l:nr == l:current
			let l:tabline .= '%#TabLineSel# '
		else
			let l:tabline .= '%#TabLine#  '
		endif

		" Get file-name with custom cutoff settings
		let l:tabline .= '%' . l:nr . 'T%{badge#filename('
			\ . l:bufnr . ', ' . g:badge_tab_filename_max_dirs . ', '
			\ . g:badge_tab_dir_max_chars . ', "tabname")}'

		" Add '+' if one of the buffers in the tab page is modified
		for l:bufnr in l:bufnrlist
			if getbufvar(l:bufnr, "&modified")
				let l:tabline .= (l:nr == l:current ? '%#Number#' : '%6*') . '+%*'
				break
			endif
		endfor

		" Right-side of single tab
		if l:nr == l:current
			let l:tabline .= '%#TabLineSel# '
		else
			let l:tabline .= '%#TabLine#  '
		endif
	endfor

	" Empty elastic space and session indicator
	let l:tabline .=
		\ '%#TabLineFill#%T%=%#TabLine#' .
		\ '%{badge#session("' . fnamemodify(v:this_session, ':t:r') . '  ")}'

	return l:tabline
endfunction

function! s:numtr(number, charset) abort
	let l:result = ''
	for l:char in split(a:number, '\zs')
		let l:result .= a:charset[l:char]
	endfor
	return l:result
endfunction

let &tabline='%!Tabline()'

" vim: set ts=2 sw=2 tw=80 noet :
