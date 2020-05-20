" Statusline
" ---

" Active Statusline {{{1

let s:stl  = ''
let s:stl .= "%(%{badge#highlightmode()}%)"             " Change color for mode
let s:stl .= "%#StatusLineMode#"                        " Color mode
let s:stl .= "%( %{badge#mode('|')} %)"                 " Current mode
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
let s:stl_nc .= '%( %2p%% %3l:%-2v %)'                  " Line and column

" Status-line options {{{1
let s:disable_statusline =
	\ 'defx\|denite\|vista\|tagbar\|undotree\|diff\|peekaboo\|sidemenu'

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

" active & inactive toggle functions {{{1
function! s:active()
	if &filetype ==# 'defx'
		let &l:statusline = '%y %<%=%{badge#filename()}%= %l/%L'
	elseif &filetype ==# 'magit'
		let &l:statusline = '%y %{badge#gitstatus()}%<%=%{badge#filename()}%= %l/%L'
	elseif &filetype !~# s:disable_statusline
		let &l:statusline = s:stl
	endif
endfunction

function! s:inactive()
	if &filetype ==# 'defx'
		let &l:statusline = '%y %= %l/%L'
	elseif &filetype ==# 'magit'
		let &l:statusline = '%y %{badge#gitstatus()}%= %l/%L'
	elseif &filetype !~# s:disable_statusline
		let &l:statusline = s:stl_nc
	endif
endfunction

" Statusline (re)draw logic {{{1
augroup user_statusline
	autocmd!

	" Set active/inactive statusline templates
	autocmd VimEnter,ColorScheme,FileType,WinEnter,BufWinEnter * call s:active()
	autocmd WinLeave * call s:inactive()

	" Redraw on Vim events
	autocmd FileChangedShellPost,BufFilePost,BufNewFile,BufWritePost * redrawstatus

	" Redraw on Plugins custom events
	autocmd User ALELintPost,ALEFixPost redrawstatus
	autocmd User NeomakeJobFinished redrawstatus
	autocmd User GutentagsUpdating redrawstatus
	autocmd User CocStatusChange,CocGitStatusChange redrawstatus
	autocmd User CocDiagnosticChange redrawstatus
augroup END
" }}}

" vim: set ts=2 sw=2 tw=80 noet fdm=marker ft=vim :
