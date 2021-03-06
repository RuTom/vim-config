" vim-badge - Bite-size badges for tab & status lines
" Maintainer: Rafael Bodill <justrafi at gmail dot com>
"-------------------------------------------------

" Configuration {{{1

" Maximum number of directories in filepath
let g:badge_status_filename_max_dirs =
	\ get(g:, 'badge_status_filename_max_dirs', 3)

" Maximum number of characters in each directory
let g:badge_status_dir_max_chars =
	\ get(g:, 'badge_status_dir_max_chars', 5)

" Less verbosity on specific filetypes (regexp)
let g:badge_filetype_blacklist =
	\ get(g:, 'badge_filetype_blacklist',
	\ 'vimfiler\|gundo\|diff\|fugitive\|gitv')

let g:badge_loading_charset =
	\ get(g:, 'badge_loading_charset',
	\ ['⠃', '⠁', '⠉', '⠈', '⠐', '⠠', '⢠', '⣠', '⠄', '⠂'])

let g:badge_nofile = get(g:, 'badge_nofile', 'N/A')

let s:badge_mode_map = {
	\ 'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE', 'v': 'VISUAL', 'V': 'V-LINE',
	\ "\<C-v>": 'V-BLOCK', 'c': 'COMMAND', 's': 'SELECT', 'S': 'S-LINE',
	\ "\<C-s>": 'S-BLOCK', 't': 'TERMINAL'
	\ }

let s:badge_mode_seperator = '|'

" Private variables
let s:caches = []

" Setup {{{1

" Private variables
let s:caches = []

" Clear cache on save
augroup statusline_cache
	autocmd!
	autocmd BufWritePre,FileChangedShellPost,TextChanged,InsertLeave *
		\ unlet! b:badge_cache_trails
	autocmd BufReadPost,BufFilePost,BufNewFile,BufWritePost *
		\ for cache_name in s:caches | execute 'unlet! b:' . cache_name | endfor
augroup END

" Functions {{{1

function! badge#project() abort " {{{2
	" Try to guess the project's name

	let dir = badge#root()
	return fnamemodify(dir ? dir : getcwd(), ':t')
endfunction

function! badge#gitstatus(...) abort " {{{2
	" Display git status indicators

	let l:icons = ['₊', '∗', '₋']  " added, modified, removed
	let l:out = ''
	" if &filetype ==# 'magit'
	"	let l:map = {}
	"	for l:file in magit#git#get_status()
	"		let l:map[l:file['unstaged']] = get(l:map, l:file['unstaged'], 0) + 1
	"	endfor
	"	for l:status in l:map
	"		let l:out = values(l:map)
	"	endfor
	" else
		if exists('*gitgutter#hunk#summary')
			let l:summary = gitgutter#hunk#summary(bufnr('%'))
			for l:idx in range(0, len(l:summary) - 1)
				if l:summary[l:idx] > 0
					let l:out .= ' ' . l:icons[l:idx] . l:summary[l:idx]
				endif
			endfor
		endif
	" endif
	return trim(l:out)
endfunction

function! badge#filename(...) abort " {{{2
	" Provides relative path with limited characters in each directory name, and
	" limits number of total directories. Caches the result for current buffer.
	" Parameters:
	"   1: Buffer number, ignored if tab number supplied
	"   2: Maximum characters displayed in base filename
	"   3: Maximum characters displayed in each directory
	"   4: Cache key

	" Compute buffer id
	let l:bufnr = '%'
	if a:0 > 0
		let l:bufnr = a:1
	endif

	" Use buffer's cached filepath
	let l:cache_var_name = a:0 > 3 ? a:4 : 'filename'
	let l:cache_var_name = 'badge_cache_' . l:cache_var_name
	let l:fn = getbufvar(l:bufnr, l:cache_var_name, '')
	if len(l:fn) > 0
		return l:fn
	endif

	let l:bufname = bufname(l:bufnr)
	let l:filetype = getbufvar(l:bufnr, '&filetype')

	if l:filetype =~? g:badge_filetype_blacklist
		" Empty if owned by certain plugins
		let l:fn = ''
	elseif l:filetype ==# 'denite.*\|quickpick-filter'
		let l:fn = '⌖ '
	elseif l:filetype ==# 'qf'
		let l:fn = '⌗ list'
	elseif l:filetype ==# 'TelescopePrompt'
		let l:fn = '⌖ '
	elseif l:filetype ==# 'defx'
		let l:fn = ' '
	elseif l:filetype ==# 'magit'
		let l:fn = magit#git#top_dir()
	elseif l:filetype ==# 'vimfiler'
		let l:fn = vimfiler#get_status_string()
	elseif empty(l:bufname)
		" Placeholder for empty buffer
		let l:fn = g:badge_nofile
	" elseif ! &buflisted
	" 	let l:fn = ''
	else
		" Shorten dir names
		let l:max = a:0 > 2 ? a:3 : g:badge_status_dir_max_chars
		let short = substitute(l:bufname,
			\ "[^/]\\{" . l:max . "}\\zs[^/]\*\\ze/", '', 'g')

		" Decrease dir count
		let l:max = a:0 > 1 ? a:2 : g:badge_status_filename_max_dirs
		let parts = split(short, '/')
		if len(parts) > l:max
			let parts = parts[-l:max-1 : ]
		endif

		let l:fn .= join(parts, '/')
	endif

	" Append fugitive blob type
	let l:fugitive = getbufvar(l:bufnr, 'fugitive_type')
	if l:fugitive ==# 'blob'
		let l:fn .= ' (blob)'
	endif

	" Cache and return the final result
	call setbufvar(l:bufnr, l:cache_var_name, l:fn)
	if index(s:caches, l:cache_var_name) == -1
		call add(s:caches, l:cache_var_name)
	endif
	return l:fn
endfunction

function! badge#filesize(...) abort " {{{2
	" Return filesize in human readable form or bytes if called with an argument

	let fsize = line2byte('$') + len(getline('$'))
	if a:0 > 0
		return winwidth(0) > 70 ? fsize : ''
	endif
	return winwidth(0) > 70 ? s:humansize(fsize) : ''
endfunction

function! badge#root() abort " {{{2
	" Find the root directory by searching for the version-control dir

	let dir = getbufvar('%', 'project_dir')
	let curr_dir = getcwd()
	if empty(dir) || getbufvar('%', 'project_dir_last_cwd') != curr_dir
		let patterns = ['.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
		for pattern in patterns
			let is_dir = stridx(pattern, '/') != -1
			let match = is_dir ? finddir(pattern, curr_dir . ';')
				\ : findfile(pattern, curr_dir . ';')
			if ! empty(match)
				let dir = fnamemodify(match, is_dir ? ':p:h:h' : ':p:h')
				call setbufvar('%', 'project_dir', dir)
				call setbufvar('%', 'project_dir_last_cwd', curr_dir)
				break
			endif
		endfor
	endif
	return dir
endfunction

function! badge#branch() abort " {{{2
	" Returns git branch name, using different plugins.

	if &filetype !~? g:badge_filetype_blacklist
		if exists('*gitbranch#name')
			return gitbranch#name()
		elseif exists('*vcs#info')
			return vcs#info('%b')
		elseif exists('fugitive#head')
			return fugitive#head(8)
		endif
	endif
	return ''
endfunction

function! badge#syntax() abort " {{{2
	" Returns syntax warnings from several plugins
	" Supports vim-lsp, ALE, Neomake, and Syntastic
	if &filetype =~? g:badge_filetype_blacklist
		return ''
	endif

	let l:msg = ''
	let l:errors = 0
	let l:warnings = 0
	let l:hints = 0
	let l:information = 0
	if exists('*lsp#get_buffer_diagnostics_counts')
			\ && get(g:, 'lsp_diagnostics_enabled', 1)
		let l:counts = lsp#get_buffer_diagnostics_counts()
		let l:errors = get(l:counts, 'error', '')
		let l:warnings = get(l:counts, 'warning', '')
		let l:hints = get(l:counts, 'hint', '')
		let l:information = get(l:counts, 'information', '')
	elseif exists('*neomake#Make')
		let l:counts = neomake#statusline#get_counts(bufnr('%'))
		let l:errors = get(l:counts, 'E', '')
		let l:warnings = get(l:counts, 'W', '')
	elseif exists('g:loaded_ale')
		let l:counts = ale#statusline#Count(bufnr('%'))
		let l:errors = l:counts.error + l:counts.style_error
		let l:warnings = l:counts.total - l:errors
	elseif exists('*SyntasticStatuslineFlag')
		let l:msg = SyntasticStatuslineFlag()
	endif
	if l:errors > 0
		let l:msg .= printf(' %d ', l:errors)
	endif
	if l:warnings > 0
		let l:msg .= printf(' %d ', l:warnings)
	endif
	if l:hints > 0
		let l:msg .= printf(' %d ', l:hints)
	endif
	if l:information > 0
		let l:msg .= printf(' %d ', l:information)
	endif
	return substitute(l:msg, '\s*$', '', '')
endfunction

function! badge#trails(...) abort " {{{2
	" Detect trailing whitespace and cache result per buffer
	" Parameters:
	"   Whitespace warning message, use %s for line number, default: WS:%s

	if ! exists('b:badge_cache_trails')
		let b:badge_cache_trails = ''
		if ! &readonly && &modifiable && line('$') < 9000
			let trailing = search('\s$', 'nw')
			if trailing != 0
				let label = a:0 == 1 ? a:1 : 'WS:%s'
				let b:badge_cache_trails .= printf(label, trailing)
			endif
		endif
	endif
	return b:badge_cache_trails
endfunction

function! badge#modified(...) abort " {{{2
	" Make sure we ignore &modified when choosewin is active
	" Parameters:
	"   Modified symbol, default: +

	let label = a:0 == 1 ? a:1 : '+'
	let choosewin = exists('g:choosewin_active') && g:choosewin_active
	return &modified && ! choosewin ? label : ''
endfunction

function! badge#readonly(...) abort " {{{2
	" Returns file's read-only state
	" Parameters:
	"   Read-only symbol, default: R
	"
	if &filetype !~? g:badge_filetype_blacklist && &readonly
		return a:0 >= 1 ? a:1 : 'R'
	endif
	return ''
endfunction

function! badge#mode(...) abort " {{{2
	" Returns vim mode
	" Parameters:
	"   1: Seperator between mode and spell, if present. default '|'
	"   2: Zoomed buffer symbol, default: Z
	" Options:
	"   g:badge_mode_map dictionary to match modes

	let l:mode = get(exists('g:badge_mode_map') ? g:badge_mode_map : s:badge_mode_map,
		\ mode(), '')

	let l:sep = a:0 > 0 ? a:1 : s:badge_mode_seperator
	if &spell
		let l:mode .= ' ' . l:sep . ' ' . &spelllang
	endif
	if exists('t:zoomed') && bufnr('%') == t:zoomed.nr
		let l:mode .= ' ' . l:sep . ' ' . ( a:0 > 1 ? a:2 : 'Z' )
	endif
	return l:mode
endfunction

function! badge#highlightmode() abort " {{{2
	" Links Statusline_mode to colors depending on mode
	let l:mode_match = {
		\ 'n': 'normal', 'i': 'insert', 'R': 'replace', 'v': 'visual',
		\ 'V': 'visual', "\<C-v>": 'visual', 'c': 'command', 's': 'select',
		\ 'S': 'select', "\<C-s>": 'select', 't': 'terminal'
		\ }
	let l:mode = get(l:mode_match, mode(), 'normal')
	exec printf('hi! link StatusLineMode StatusLineMode_%s', l:mode)
	return ''
endfunction

function! badge#format() abort " {{{2
	" Returns file format

	if &filetype=~? g:badge_filetype_blacklist
		return ''
	endif
	return winwidth(0) > 70 ? ((&fenc !=# '' ? &fenc : &enc) . '[' . &ff . ']') : ''
endfunction

function! badge#filenamemod(...) abort " {{{2
	" Returns read-only status, filename and modified status
	" Parameters:
	"   1: Read-only symbol, default: see badge#readonly()
	"   2: Modified symbol, default: see badge#modified()

	let l:ret = ''
	let l:readonly = a:0 >= 1 ? badge#readonly(a:1) : badge#readonly()
	let l:modified = a:0 >= 2 ? badge#modified(a:2) : badge#modified()
	if l:readonly !=# ''
		let l:ret .= l:readonly . ' '
	endif
	let l:ret .= badge#filename()
	if l:modified !=# ''
		let l:ret .= ' ' . l:modified
	endif
	return l:ret
endfunction

function! badge#filetype() abort " {{{2
	" Returns filetype with devicons symbol if plugin is present

	let ftsymbol = ''
	if exists('*WebDevIconsGetFileTypeSymbol()')
		let ftsymbol = ' ' . WebDevIconsGetFileTypeSymbol()
	endif
	return strlen(&filetype) ? &filetype . ftsymbol : 'no ft'
endfunction

function! badge#session(...) abort " {{{2
	" Returns an indicator for active session
	" Parameters:
	"   Active session symbol, default: [S]

	return empty(v:this_session) ? '' : a:0 == 1 ? a:1 : '[S]'
endfunction

function! badge#indexing() abort " {{{2
	let l:out = ''

	if exists('*lsp#get_progress')
		let s:lsp_progress = lsp#get_progress()
		if len(s:lsp_progress) > 0 && has_key(s:lsp_progress[0], 'message')
			" Show only last progress message
			let s:lsp_progress = s:lsp_progress[0]
			let l:percent = get(s:lsp_progress, 'percentage')
			if s:lsp_progress['message'] != '' && l:percent != 100
				let l:out .= s:lsp_progress['server'] . ':'
					\ . s:lsp_progress['title'] . ' '
					\ . s:lsp_progress['message']
					\ . l:percent
				if l:percent >= 0
					let l:out .= ' ' . string(l:percent) . '%'
				endif
			endif
		endif
	endif
	if exists('*gutentags#statusline')
		let l:tags = gutentags#statusline('[', ']')
		if ! empty(l:tags)
			if exists('*reltime')
				let s:wait = split(reltimestr(reltime()), '\.')[1] / 100000
			else
				let s:wait = get(s:, 'wait', 9) == 9 ? 0 : s:wait + 1
			endif
			let l:out .= get(g:badge_loading_charset, s:wait, '') . ' ' . l:tags
		endif
	endif
	if exists('*coc#status')
		let l:out .= coc#status()
	endif
	if exists('g:SessionLoad') && g:SessionLoad == 1
		let l:out .= '[s]'
	endif
	return l:out
endfunction

function! s:numtr(number, charset) abort " {{{2
	let l:result = ''
	for l:char in split(a:number, '\zs')
		let l:result .= a:charset[l:char]
	endfor
	return l:result
endfunction

function! s:humansize(bytes) abort " {{{2
	" Returns byte size in human readable form (B, KiB, MiB, GiB)

	let l:bytes = a:bytes
	let l:sizes = ['B', 'KiB', 'MiB', 'GiB']
	let l:i = 0
	while l:bytes >= 1024
		let l:bytes = l:bytes / 1024.0
		let l:i += 1
	endwhile
	return printf('%.1f%s', l:bytes, l:sizes[l:i])
endfunction

" }}}
" }}}

" vim: set ts=2 sw=2 tw=80 noet fdm=marker :
