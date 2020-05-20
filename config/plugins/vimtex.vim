
" mappings are in config/all.vim
let g:vimtex_mappings_enabled = 0

let g:vimtex_doc_enabled = 0

let g:vimtex_cache_root = $DATA_PATH . '/vimtex'

let g:vimtex_imaps_leader = '`'

let g:vimtex_compiler_latexmk = { 'build_dir' : 'build', }

if executable('zathura')
	let g:vimtex_view_method = 'zathura'
endif

if executable('pulp')
	let g:vimtex_quickfix_method = 'pulp'
elseif executable('pplatex')
	let g:vimtex_quickfix_method = 'pplatex'
else
	let g:vimtex_quickfix_method = 'latexlog'
endif

let g:vimtex_fold_enabled = 1
let g:vimtex_fold_manual = 1

let g:vimtex_syntax_nested = {
	\ 'aliases' : {
	\   'C' : 'c',
	\   'c++' : 'cpp',
  \   'viml' : 'vim',
  \   'bash' : 'sh',
  \   'py' : 'python',
	\ },
	\ 'ignored' : {
	\   'python' : [
	\     'pythonEscape',
	\     'pythonBEscape',
	\     'pythonBytesEscape',
	\   ],
	\   'java' : [
	\     'javaError',
	\   ],
	\   'haskell' : [
	\     'hsVarSym',
	\   ],
	\ }
	\ }

" vim: set ts=2 sw=2 tw=80 noet ft=vim :
