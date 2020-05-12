" Configuration and plugin-manager manager :)
" ---
" Maintainer: Rafael Bodill
" See: github.com/rafi/vim-config
"
" Plugin-manager agnostic initialization and user configuration parsing

" Set custom augroup
augroup user_events
	autocmd!
augroup END

" Initializes options
let s:package_manager = get(g:, 'etc_package_manager', 'dein')
if empty(s:package_manager) || s:package_manager ==# 'none'
	finish
endif

" Enables 24-bit RGB color in the terminal
if has('termguicolors')
	if empty($COLORTERM) || $COLORTERM =~# 'truecolor\|24bit'
		set termguicolors
	endif
endif

" Disable vim distribution plugins

" let g:loaded_gzip = 1
" let g:loaded_tar = 1
" let g:loaded_tarPlugin = 1
" let g:loaded_zip = 1
" let g:loaded_zipPlugin = 1

let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1

let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_2html_plugin = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

" Set main configuration directory as parent directory
let $VIM_PATH =
	\ get(g:, 'etc_vim_path',
	\   exists('*stdpath') ? stdpath('config') :
	\   ! empty($MYVIMRC) ? fnamemodify(expand($MYVIMRC), ':h') :
	\   ! empty($VIMCONFIG) ? expand($VIMCONFIG) :
	\   ! empty($VIM_PATH) ? expand($VIM_PATH) :
	\   fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
	\ )

" Set data/cache directory as $XDG_CACHE_HOME/vim
let $DATA_PATH =
	\ expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache') . '/vim')

function! s:main()
	if has('vim_starting')
		" When using VIMINIT trick for exotic MYVIMRC locations, add path now.
		if &runtimepath !~# $VIM_PATH
			set runtimepath^=$VIM_PATH
		endif

		" Ensure data directories
		for s:path in [
				\ $DATA_PATH,
				\ $DATA_PATH . '/undo',
				\ $DATA_PATH . '/backup',
				\ $DATA_PATH . '/session',
				\ $VIM_PATH . '/spell' ]
			if ! isdirectory(s:path)
				call mkdir(s:path, 'p')
			endif
		endfor

		" Python interpreter settings
		if has('nvim')
			" Try using pyenv virtualenv called 'neovim'
			let l:virtualenv = ''
			if ! empty($PYENV_ROOT)
				let l:virtualenv = $PYENV_ROOT . '/versions/neovim/bin/python'
			endif
			if empty(l:virtualenv) || ! filereadable(l:virtualenv)
				" Fallback to old virtualenv location
				let l:virtualenv = $DATA_PATH . '/venv/neovim3/bin/python'
			endif
			if filereadable(l:virtualenv)
				let g:python3_host_prog = l:virtualenv
			endif

		elseif has('pythonx')
			if has('python3')
				set pyxversion=3
			elseif has('python')
				set pyxversion=2
			endif
		endif
	endif

	" Initializes dein
	call s:use_dein()
endfunction

function! s:use_dein()
	let l:cache_path = $DATA_PATH . '/dein'

	if has('vim_starting')
		" Use dein as a plugin manager
		let g:dein#auto_recache = 1
		let g:dein#install_max_processes = 12

		" Add dein to vim's runtimepath
		if &runtimepath !~# '/dein.vim'
			let s:dein_dir = l:cache_path . '/repos/github.com/Shougo/dein.vim'
			" Clone dein if first-time setup
			if ! isdirectory(s:dein_dir)
				call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_dir))
				if v:shell_error
					call s:error('dein installation has failed! is git installed?')
					finish
				endif
			endif

			execute 'set runtimepath+='.substitute(
				\ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
		endif
	endif

	" Initialize dein.vim (package manager)
	if dein#load_state(l:cache_path)
		" Start propagating file paths and plugin presets
		call dein#begin(l:cache_path)

		call dein#load_toml($VIM_PATH . '/config/plugins.toml')

		" Add any local ./dev plugins
		if isdirectory($VIM_PATH . '/dev')
			call dein#local($VIM_PATH . '/dev', { 'frozen': 1, 'merged': 0 })
		endif
		call dein#end()

		" Save cached state for faster startups
		if ! g:dein#_is_sudo
			call dein#save_state()
		endif

		" Update or install plugins if a change detected
		if dein#check_install()
			if ! has('nvim')
				set nomore
			endif
			call dein#install()
		endif
	endif

	filetype plugin indent on

	" Only enable syntax when vim is starting
	if has('vim_starting')
		syntax enable
	endif

	" Trigger source event hooks
	call dein#call_hook('source')
	call dein#call_hook('post_source')
endfunction

" General utilities, mainly for dealing with user configuration parsing
" ---

function! s:error(msg)
	for l:mes in s:str2list(a:msg)
		echohl WarningMsg | echomsg '[config/init] ' . l:mes | echohl None
	endfor
endfunction

function! s:debug(msg)
	for l:mes in s:str2list(a:msg)
		echohl WarningMsg | echomsg '[config/init] ' . l:mes | echohl None
	endfor
endfunction

function! s:str2list(expr)
	" Convert string to list
	return type(a:expr) ==# v:t_list ? a:expr : split(a:expr, '\n')
endfunction

call s:main()

" vim: set ts=2 sw=2 tw=80 noet :
