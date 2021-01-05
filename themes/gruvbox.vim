" Colors: {{{1
function! s:HL(group, fg, bg, ...)
	" Arguments: group, guifg, guibg, gui,
	" foreground
	let fg = a:fg
	" background
	let bg = a:bg
	" emphasis
	if a:0 >= 2 && strlen(a:2)
		let emstr = a:2
	else
		let emstr = 'NONE,'
	endif
	let histring = [ 'hi', a:group,
		\ 'guifg=' . fg[0], 'ctermfg=' . fg[1],
		\ 'guibg=' . bg[0], 'ctermbg=' . bg[1],
		\ 'gui=' . emstr[:-2], 'cterm=' . emstr[:-2]
		\ ]
	execute join(histring, ' ')
endfunction

function! s:getGruvColor(group)
	let guiColor = synIDattr(hlID(a:group), "fg", "gui")
	let termColor = synIDattr(hlID(a:group), "fg", "cterm")
	return [ guiColor, termColor ]
endfunction

let s:bg0  = s:getGruvColor('GruvboxBg0')
let s:bg1  = s:getGruvColor('GruvboxBg1')
let s:bg2  = s:getGruvColor('GruvboxBg2')
let s:bg4  = s:getGruvColor('GruvboxBg4')
let s:fg1  = s:getGruvColor('GruvboxFg1')
let s:fg4  = s:getGruvColor('GruvboxFg4')

let s:yellow = s:getGruvColor('GruvboxYellow')
let s:blue   = s:getGruvColor('GruvboxBlue')
let s:aqua   = s:getGruvColor('GruvboxAqua')
let s:orange = s:getGruvColor('GruvboxOrange')
let s:green = s:getGruvColor('GruvboxGreen')

" Statusline: {{{1
call s:HL('StatusLineMode_normal', s:bg0, s:fg4, 'bold')
call s:HL('StatusLineMode_insert', s:bg0, s:blue, 'bold')
call s:HL('StatusLineMode_visual', s:bg0, s:orange, 'bold')
call s:HL('StatusLineMode_replace', s:bg0, s:aqua, 'bold')
call s:HL('StatusLineMode_terminal', s:bg0, s:green, 'bold')
hi! link StatusLineMode_command StatusLineMode_normal
hi! link StatusLineMode_select StatusLineMode_visual

" Tabline: {{{1
call s:HL('TabLineAlt', s:green, s:bg1, 'italic')

" Plugins: {{{1
" FZF: {{{2
let g:fzf_colors = {
	\ 'fg':      ['fg', 'GruvboxFg1'],
	\ 'bg':      ['fg', 'GruvboxBg0'],
	\ 'hl':      ['fg', 'GruvboxRed'],
	\ 'fg+':     ['fg', 'GruvboxGreen'],
	\ 'bg+':     ['fg', 'GruvboxBg1'],
	\ 'hl+':     ['fg', 'GruvboxRed'],
	\ 'info':    ['fg', 'GruvboxOrange'],
	\ 'border':  ['fg', 'GruvboxBg0'],
	\ 'prompt':  ['fg', 'GruvboxAqua'],
	\ 'pointer': ['fg', 'GruvboxOrange'],
	\ 'marker':  ['fg', 'GruvboxYellow'],
	\ 'spinner': ['fg', 'GruvboxGreen'],
	\ 'header':  ['fg', 'GruvboxBlue']
	\ }
" }}}

" Syntax: {{{1
" LaTex: {{{2
highlight! link texStatement GruvboxGreen
highlight! link texOnlyMath GruvboxGrey
highlight! link texDefName GruvboxYellow
highlight! link texNewCmd GruvboxOrange
highlight! link texCmdName GruvboxBlue
highlight! link texBeginEnd GruvboxRed
highlight! link texBeginEndName GruvboxBlue
highlight! link texDocType GruvboxPurple
highlight! link texDocTypeArgs GruvboxOrange
" }}}
" }}}

" vim: set ts=2 sw=2 tw=80 noet fdm=marker ft=vim :
