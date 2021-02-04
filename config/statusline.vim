" Statusline
" ---

" Active Statusline {{{1

let s:stl  = ''
let s:stl .= "%(%{badge#highlightmode()}%)"             " Change color for mode
let s:stl .= "%#StatusLineMode#"                        " Color mode
let s:stl .= "%( %{badge#mode('|', '🔎')} %)"           " Current mode
let s:stl .= "%#StatusLine#"                            " Color
let s:stl .= "%( %{&paste ? '=' : ''}%)"                " Paste symbol
let s:stl .= "%( %{badge#filenamemod('', '+')} %)"     " Filename
let s:stl .= '%#StatusLineNC#'                          " Color
let s:stl .= '%(  %{badge#branch()}%)'                 " Git branch name
let s:stl .= '%( %{badge#gitstatus()}%)'                " Git status

let s:stl .= '%='                                       " Align to right

let s:stl .= '%<'                                       " Truncate here
let s:stl .= '%(%{badge#indexing()} %)'                 " Indexing indicator
let s:stl .= "%(%{badge#trails('␣%s')} %)"              " Whitespace
let s:stl .= '%(%{badge#syntax()} %)'                   " Syntax lint
let s:stl .= '%(%{badge#format()} %)'                   " File format
let s:stl .= "%#StatusLine#"                            " Color
let s:stl .= '%( %{badge#filetype()} %)'                " File type
let s:stl .= "%#StatusLineMode#"                        " Color mode
let s:stl .= '%( %2p%% %3l:%-2v %)'                    " Line and column

" Non-active Statusline {{{1
let s:stl_nc  = ''
let s:stl_nc .= '%( %n:'                                " Buffer number
let s:stl_nc .= ' %{badge#filenamemod()} %)'            " Filename

let s:stl_nc .= '%='                                    " Align to right

let s:stl_nc .= '%(%{badge#filetype()} %)'              " File type
let s:stl_nc .= '%( %2p%% %3l:%-2v %)'                 " Line and column

" Status-line options {{{1
" Status-line blacklist
let s:statusline_filetypes_ignore = get(g:, 'statusline_filetypes_ignore',
	\ 'defx\|denite\|vista\|undotree\|diff\|sidemenu\|qf')

let s:statusline_filetypes = get(g:, 'statusline_filetypes', {
	\ 'defx': ['%{fnamemodify(getcwd(), ":t")}%=%l/%L'],
	\ 'magit': [
	\   '%y %{badge#gitstatus()}%<%=%{fnamemodify(badge#filename(), ":~")}%=%l/%L',
	\   '%y %{badge#gitstatus()}%= %l/%L'],
	\ 'minimap': [' '],
	\ 'denite-filter': ['%#Normal#'],
	\ })

let g:badge_mode_map = {
	\ 'n' : 'N',
	\ 'i' : 'I',
	\ 'R' : 'R',
	\ 'r' : 'P',
	\ 'v' : 'V',
	\ 'V' : 'VL',
	\ "\<C-v>": 'VB',
	\ 'c' : 'C',
	\ 's' : 'S',
	\ 'S' : 'SL',
	\ "\<C-s>": 'SB',
	\ 't': 'T',
	\ }

let g:badge_nofile = '[No Name]'

" Statusline (re)draw logic {{{1
" s:set_state replaces current statusline
function! s:set_state(filetype, index, default) abort " {{{2
	" Skip statusline render during session loading
	if &previewwindow || exists('g:SessionLoad') "|| empty(a:filetype)
		return
	endif
	if has_key(s:statusline_filetypes, a:filetype)
		let l:states = s:statusline_filetypes[a:filetype]
		let l:want = get(l:states, a:index, l:states[0])
		if &l:statusline != l:want
			let &l:statusline = l:want
		endif
	elseif a:filetype !~# s:statusline_filetypes_ignore
		if &l:statusline != a:default
			let &l:statusline = a:default
		endif
	endif
endfunction " }}}

" Bind to Vim events
augroup user_statusline
	autocmd!

	" Set active/inactive statusline templates
	autocmd VimEnter,ColorScheme, * let &l:statusline = s:stl
	autocmd FileType,WinEnter,BufWinEnter * call s:set_state(&filetype, 0, s:stl)
	autocmd WinLeave * call s:set_state(&filetype, 1, s:stl_nc)

	" Redraw on Vim events
	autocmd FileChangedShellPost,BufFilePost,BufNewFile,BufWritePost * redrawstatus

	" Redraw on Plugins custom events
	autocmd User ALELintPost,ALEFixPost redrawstatus
	autocmd User NeomakeJobFinished redrawstatus
	autocmd User GutentagsUpdating redrawstatus
	autocmd User CocStatusChange,CocGitStatusChange redrawstatus
	autocmd User CocDiagnosticChange redrawstatus
	" autocmd User lsp_diagnostics_updated redrawstatus

	" if exists('##LspDiagnosticsChanged')
	" 	autocmd LspDiagnosticsChanged * redrawstatus
	" endif
augroup END
" }}}

" vim: set ts=2 sw=2 tw=80 noet fdm=marker ft=vim :
