let g:lightline.colorscheme = 'gruvbox'

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
