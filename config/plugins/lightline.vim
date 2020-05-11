" lightline.vim

augroup user_lightline " {{{1
	autocmd!

	" Redraw on Vim events
	autocmd FileChangedShellPost,BufFilePost,BufNewFile,BufWritePost * call lightline#update()
	autocmd TextChanged,TextChangedI * call lightline#update()

	" Redraw on Plugins custom events
	autocmd User ALELintPost,ALEFixPost call lightline#update()
	autocmd User NeomakeJobFinished call lightline#update()
	autocmd User GutentagsUpdating call lightline#update()
	autocmd User CocStatusChange,CocGitStatusChange call lightline#update()
	autocmd User CocDiagnosticChange call lightline#update()
augroup END " }}}

let g:lightline = {}
let g:lightline#bufferline#show_number = 1
let g:lightline#bufferline#more_buffers = '…'
let g:lightline#bufferline#unnamed = '[No Name]'
let g:lightline#bufferline#clickable = 1
let g:lightline#bufferline#number_separator = ': '
let g:lightline#ale#indicator_checking = ''
let g:lightline#ale#indicator_warnings = '!'
let g:lightline#ale#indicator_errors = ''
let g:lightline#ale#indicator_ok = ''
let g:lightline.active = {
	\ 'left': [ [ 'mode', 'paste', 'spell' ],
	\           [ 'filename', 'windowmode', 'filesize','fileformat', 'filetype' ] ],
	\ 'right': [ [ 'lineinfo' ],
	\            [ 'linter_checking', 'linter_errors', 'linter_warnings', 'whitespace', 'linter_ok' ],
	\            [ 'gitstatus' ] ]
	\ }
let g:lightline.inactive = {
	\ 'left': [ [ 'filename' , 'filetype' ]],
	\ 'right': [ [ 'lineinfo' ] ]
	\ }
let g:lightline.tabline = {
	\ 'left': [ [ 'buffers' ] ],
	\ 'right': [ [ 'project', 'gitbranch', 'session', 'vim_logo' ] ]
	\ }
let g:lightline.component = {
	\ 'vim_logo': '',
	\ 'mode': '%{lightline#mode()}',
	\ 'paste': '%{&paste?"PASTE":""}',
	\ 'filesize': '%{badge#filesize()}',
	\ 'spell': '%{&spell?&spelllang:""}',
	\ 'lineinfo': '%2p%% %3l:%-2v',
	\ 'winnr': '%{winnr()}'
	\ }
let g:lightline.component_function = {
	\ 'windowmode': 'badge#windowmode',
	\ 'filetype': 'badge#filetype',
	\ 'fileformat': 'badge#format',
	\ 'filename': 'badge#filenamemod',
	\ 'project': 'badge#project',
	\ 'gitstatus': 'badge#gitstatus',
	\ 'gitbranch': 'badge#branch',
	\ 'session': 'badge#session'
	\ }
let g:lightline.component_expand = {
	\ 'buffers': 'lightline#bufferline#buffers',
	\ 'linter_checking': 'lightline#ale#checking',
	\ 'linter_warnings': 'lightline#ale#warnings',
	\ 'linter_errors': 'lightline#ale#errors',
	\ 'linter_ok': 'lightline#ale#ok',
	\ 'whitespace': 'badge#trails'
	\ }
let g:lightline.component_type = {
	\ 'buffers': 'tabsel',
	\ 'linter_warnings': 'warning',
	\ 'linter_errors': 'error',
	\ 'whitespace': 'warning'
	\ }
let g:lightline.component_raw = {
	\ 'buffers': 1
	\ }
let g:lightline.mode_map = {
	\ 'n' : 'N',
	\ 'i' : 'I',
	\ 'R' : 'R',
	\ 'v' : 'V',
	\ 'V' : 'VL',
	\ "\<C-v>": 'VB',
	\ 'c' : 'C',
	\ 's' : 'S',
	\ 'S' : 'SL',
	\ "\<C-s>": 'SB',
	\ 't': 'T',
	\ }
"}}}

" vim: set ts=2 sw=2 tw=80 noet fdm=marker ft=vim :
