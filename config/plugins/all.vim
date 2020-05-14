" Plugin Keyboard-Mappings
" ---

if dein#tap('vim-clap')
	" nnoremap <silent><LocalLeader>f :<C-u>Clap! files<CR>
	" nnoremap <silent><LocalLeader>b :<C-u>Clap! buffers<CR>
	" nnoremap <silent><LocalLeader>g :<C-u>Clap! grep<CR>
	" nnoremap <silent><LocalLeader>j :<C-u>Clap! jumps<CR>
	" nnoremap <silent><LocalLeader>h :<C-u>Clap! help_tags<CR>
	" nnoremap <silent><LocalLeader>t :<C-u>Clap! tags<CR>
	" nnoremap <silent><LocalLeader>l :<C-u>Clap! loclist<CR>
	" nnoremap <silent><LocalLeader>q :<C-u>Clap! quickfix<CR>
	" nnoremap <silent><LocalLeader>m :<C-u>Clap! files ~/docs/books<CR>
	" nnoremap <silent><LocalLeader>y :<C-u>Clap! yanks<CR>
	" nnoremap <silent><LocalLeader>/ :<C-u>Clap! lines<CR>
	" nnoremap <silent><LocalLeader>* :<C-u>Clap! lines ++query=<cword><CR>
	" nnoremap <silent><LocalLeader>; :<C-u>Clap! command_history<CR>

	" nnoremap <silent><Leader>gl :<C-u>Clap! commits<CR>
	" nnoremap <silent><Leader>gt :<C-u>Clap! tags ++query=<cword><CR>
	" xnoremap <silent><Leader>gt :<C-u>Clap! tags ++query=@visual<CR><CR>
	" nnoremap <silent><Leader>gf :<C-u>Clap! files ++query=<cword><CR>
	" xnoremap <silent><Leader>gf :<C-u>Clap! files ++query=@visual<CR><CR>
	" nnoremap <silent><Leader>gg :<C-u>Clap! grep ++query=<cword><CR>
	" xnoremap <silent><Leader>gg :<C-u>Clap! grep ++query=@visual<CR><CR>

	autocmd user_events FileType clap_input call s:clap_mappings()

	function! s:clap_mappings()
		nnoremap <silent> <buffer> <nowait>' :call clap#handler#tab_action()<CR>
		inoremap <silent> <buffer> <Tab>   <C-R>=clap#navigation#linewise('down')<CR>
		inoremap <silent> <buffer> <S-Tab> <C-R>=clap#navigation#linewise('up')<CR>
		nnoremap <silent> <buffer> <C-f> :<c-u>call clap#navigation#scroll('down')<CR>
		nnoremap <silent> <buffer> <C-b> :<c-u>call clap#navigation#scroll('up')<CR>

		nnoremap <silent> <buffer> sg  :<c-u>call clap#handler#try_open('ctrl-v')<CR>
		nnoremap <silent> <buffer> sv  :<c-u>call clap#handler#try_open('ctrl-x')<CR>
		nnoremap <silent> <buffer> st  :<c-u>call clap#handler#try_open('ctrl-t')<CR>

		nnoremap <silent> <buffer> q     :<c-u>call clap#handler#exit()<CR>
		nnoremap <silent> <buffer> <Esc> :call clap#handler#exit()<CR>
		inoremap <silent> <buffer> <Esc> <C-R>=clap#navigation#linewise('down')<CR><C-R>=clap#navigation#linewise('up')<CR><Esc>
		inoremap <silent> <buffer> jj    <C-R>=clap#navigation#linewise('down')<CR><C-R>=clap#navigation#linewise('up')<CR><Esc>
	endfunction
endif

if dein#tap('vim-tmux-navigator')
	nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
	nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
	nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
	nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
	nnoremap <silent> <M-\> :TmuxNavigatePrevious<cr>
endif

if dein#tap('denite.nvim')
	nnoremap <silent><LocalLeader>r :<C-u>Denite -resume -refresh -no-start-filter<CR>
	nnoremap <silent><LocalLeader>f :<C-u>Denite file/rec<CR>
	nnoremap <silent><LocalLeader>g :<C-u>Denite grep -start-filter<CR>
	nnoremap <silent><LocalLeader>b :<C-u>Denite buffer file_mru -default-action=switch<CR>
	nnoremap <silent><LocalLeader>d :<C-u>Denite directory_rec directory_mru -default-action=cd<CR>
	nnoremap <silent><LocalLeader>v :<C-u>Denite neoyank -buffer-name=register<CR>
	xnoremap <silent><LocalLeader>v :<C-u>Denite neoyank -buffer-name=register -default-action=replace<CR>
	nnoremap <silent><LocalLeader>l :<C-u>Denite location_list -buffer-name=list -no-start-filter<CR>
	nnoremap <silent><LocalLeader>q :<C-u>Denite quickfix -buffer-name=list -no-start-filter<CR>
	nnoremap <silent><LocalLeader>n :<C-u>Denite dein<CR>
	nnoremap <silent><LocalLeader>j :<C-u>Denite jump change file/point -no-start-filter<CR>
	nnoremap <silent><LocalLeader>u :<C-u>Denite junkfile:new junkfile -buffer-name=list<CR>
	nnoremap <silent><LocalLeader>o :<C-u>Denite outline -no-start-filter<CR>
	nnoremap <silent><LocalLeader>s :<C-u>Denite session -buffer-name=list<CR>
	nnoremap <silent><LocalLeader>t :<C-u>Denite tag<CR>
	nnoremap <silent><LocalLeader>p :<C-u>Denite jump<CR>
	nnoremap <silent><LocalLeader>h :<C-u>Denite help<CR>
	nnoremap <silent><LocalLeader>m :<C-u>Denite file/rec -buffer-name=memo -path=~/docs/books<CR>
	nnoremap <silent><LocalLeader>z :<C-u>Denite z -buffer-name=list<CR>
	nnoremap <silent><LocalLeader>; :<C-u>Denite command_history command<CR>
	nnoremap <silent><expr><LocalLeader>/ wordcount().chars > 10000 ?
		\ ":\<C-u>Denite -search line/external\<CR>"
		\ : ":\<C-u>Denite -search line\<CR>"
	nnoremap <silent><expr><LocalLeader>* wordcount().chars > 10000 ?
		\ ":\<C-u>DeniteCursorWord -no-start-filter -search line/external\<CR>"
		\ : ":\<C-u>DeniteCursorWord -no-start-filter -search line\<CR>"

	" chemzqm/denite-git
	nnoremap <silent> <Leader>gl :<C-u>Denite gitlog:all -no-start-filter<CR>
	nnoremap <silent> <Leader>gs :<C-u>Denite gitstatus -no-start-filter<CR>
	nnoremap <silent> <Leader>gc :<C-u>Denite gitbranch -no-start-filter<CR>

	" Open Denite with word under cursor or selection
	nnoremap <silent> <Leader>gt :DeniteCursorWord tag:include -no-start-filter -immediately<CR>
	nnoremap <silent> <Leader>gf :DeniteCursorWord file/rec -no-start-filter<CR>
	nnoremap <silent> <Leader>gg :DeniteCursorWord grep -no-start-filter<CR>
	vnoremap <silent> <Leader>gg
		\ :<C-u>call <SID>get_selection('/')<CR>
		\ :execute 'Denite -no-start-filter grep:::'.@/<CR><CR>

	function! s:get_selection(cmdtype)
		let temp = @s
		normal! gv"sy
		let @/ = substitute(escape(@s, '\' . a:cmdtype), '\n', '\\n', 'g')
		let @s = temp
	endfunction

endif

if dein#tap('vim-lsp')
	" Close preview window with Escape key
	autocmd user_events User lsp_float_opened nmap <buffer> <silent> <Esc>
		\ <Plug>(lsp-preview-close)
	autocmd user_events User lsp_float_closed nunmap <buffer> <Esc>
endif

if dein#tap('defx.nvim')
	nnoremap <silent> <LocalLeader>e
		\ :<C-u>Defx -toggle `getcwd()` -buffer-name=tab`tabpagenr()`<CR>
	nnoremap <silent> <LocalLeader>a
		\ :<C-u>Defx `getcwd()` -search=`expand('%:p')` -buffer-name=tab`tabpagenr()`<CR>
endif

if dein#tap('delimitMate')
	imap <buffer><expr> <C-Tab> delimitMate#JumpAny()
endif

if dein#tap('ale')
	nmap <silent> [c <Plug>(ale_previous)
	nmap <silent> ]c <Plug>(ale_next)
endif

if dein#tap('vista.vim')
	nnoremap <silent> <Leader>b :<C-u>Vista<CR>
	nnoremap <silent> <Leader>a :<C-u>Vista show<CR>
endif

if dein#tap('vim-gitgutter')
	nmap ]g <Plug>(GitGutterNextHunk)
	nmap [g <Plug>(GitGutterPrevHunk)
	nmap gS <Plug>(GitGutterStageHunk)
	xmap gS <Plug>(GitGutterStageHunk)
	nmap <Leader>gr <Plug>(GitGutterUndoHunk)
	nmap gs <Plug>(GitGutterPreviewHunk)
endif

if dein#tap('context.vim')
	nmap <silent><Leader>tc :<C-u>ContextEnableWindow<CR>
	nmap <silent><Leader>tp :<C-u>ContextPeek<CR>
endif

if dein#tap('vim-go')
	autocmd user_events FileType go
		\   nmap <C-]> <Plug>(go-def)
		\ | nmap <Leader>god  <Plug>(go-describe)
		\ | nmap <Leader>goc  <Plug>(go-callees)
		\ | nmap <Leader>goC  <Plug>(go-callers)
		\ | nmap <Leader>goi  <Plug>(go-info)
		\ | nmap <Leader>gom  <Plug>(go-implements)
		\ | nmap <Leader>gos  <Plug>(go-callstack)
		\ | nmap <Leader>goe  <Plug>(go-referrers)
		\ | nmap <Leader>gor  <Plug>(go-run)
		\ | nmap <Leader>gov  <Plug>(go-vet)
endif

if dein#tap('iron.nvim')
	nmap <silent> <Leader>rr :<C-u>IronRepl<CR><Esc>
	nmap <silent> <Leader>rq <Plug>(iron-exit)
	nmap <silent> <Leader>rl <Plug>(iron-send-line)
	vmap <silent> <Leader>rl <Plug>(iron-visual-send)
	nmap <silent> <Leader>rp <Plug>(iron-repeat-cmd)
	nmap <silent> <Leader>rc <Plug>(iron-clear)
	nmap <silent> <Leader>r<CR>  <Plug>(iron-cr)
	nmap <silent> <Leader>r<Esc> <Plug>(iron-interrupt)
endif

if dein#tap('vim-sandwich')
	nmap <silent> sa <Plug>(operator-sandwich-add)
	xmap <silent> sa <Plug>(operator-sandwich-add)
	omap <silent> sa <Plug>(operator-sandwich-g@)
	nmap <silent> sd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
	xmap <silent> sd <Plug>(operator-sandwich-delete)
	nmap <silent> sr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
	xmap <silent> sr <Plug>(operator-sandwich-replace)
	nmap <silent> sdb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
	nmap <silent> srb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
	omap ib <Plug>(textobj-sandwich-auto-i)
	xmap ib <Plug>(textobj-sandwich-auto-i)
	omap ab <Plug>(textobj-sandwich-auto-a)
	xmap ab <Plug>(textobj-sandwich-auto-a)
	omap is <Plug>(textobj-sandwich-query-i)
	xmap is <Plug>(textobj-sandwich-query-i)
	omap as <Plug>(textobj-sandwich-query-a)
	xmap as <Plug>(textobj-sandwich-query-a)
endif

if dein#tap('vim-operator-replace')
	xmap p <Plug>(operator-replace)
endif

if dein#tap('accelerated-jk')
	nmap <silent> j <Plug>(accelerated_jk_gj)
	nmap <silent> k <Plug>(accelerated_jk_gk)
endif

if dein#tap('vim-edgemotion')
	map gj <Plug>(edgemotion-j)
	map gk <Plug>(edgemotion-k)
	xmap gj <Plug>(edgemotion-j)
	xmap gk <Plug>(edgemotion-k)
endif

if dein#tap('vim-quickhl')
	nmap <Leader>mt <Plug>(quickhl-manual-this)
	xmap <Leader>mt <Plug>(quickhl-manual-this)
endif

if dein#tap('vim-sidemenu')
	nmap <Leader>l <Plug>(sidemenu)
	xmap <Leader>l <Plug>(sidemenu-visual)
endif

if dein#tap('vim-indent-guides')
	nmap <silent><Leader>ti :<C-u>IndentGuidesToggle<CR>
endif

if dein#tap('vim-signature')
	let g:SignatureIncludeMarks = 'abcdefghijkloqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
	let g:SignatureMap = {
		\ 'Leader':            'm',
		\ 'ListBufferMarks':   'm/',
		\ 'ListBufferMarkers': 'm?',
		\ 'PlaceNextMark':     'm,',
		\ 'ToggleMarkAtLine':  'mm',
		\ 'PurgeMarksAtLine':  'm-',
		\ 'DeleteMark':        'dm',
		\ 'PurgeMarks':        'm<Space>',
		\ 'PurgeMarkers':      'm<BS>',
		\ 'GotoNextLineAlpha': "']",
		\ 'GotoPrevLineAlpha': "'[",
		\ 'GotoNextSpotAlpha': '`]',
		\ 'GotoPrevSpotAlpha': '`[',
		\ 'GotoNextLineByPos': "]'",
		\ 'GotoPrevLineByPos': "['",
		\ 'GotoNextSpotByPos': 'mn',
		\ 'GotoPrevSpotByPos': 'mp',
		\ 'GotoNextMarker':    ']-',
		\ 'GotoPrevMarker':    '[-',
		\ 'GotoNextMarkerAny': ']=',
		\ 'GotoPrevMarkerAny': '[=',
		\ }
endif

if dein#tap('auto-git-diff')
	autocmd user_events FileType gitrebase
		\  nmap <buffer><CR>  <Plug>(auto_git_diff_scroll_manual_update)
		\| nmap <buffer><C-n> <Plug>(auto_git_diff_scroll_down_page)
		\| nmap <buffer><C-p> <Plug>(auto_git_diff_scroll_up_page)
		\| nmap <buffer><C-d> <Plug>(auto_git_diff_scroll_down_half)
		\| nmap <buffer><C-u> <Plug>(auto_git_diff_scroll_up_half)
endif

if dein#tap('committia.vim')
	let g:committia_hooks = {}
	function! g:committia_hooks.edit_open(info)
		imap <buffer><C-d> <Plug>(committia-scroll-diff-down-half)
		imap <buffer><C-u> <Plug>(committia-scroll-diff-up-half)

		setlocal winminheight=1 winheight=1
		resize 10
		startinsert
	endfunction
endif

if dein#tap('python_match.vim')
	autocmd user_events FileType python
		\ nmap <buffer> {{ [%
		\ | nmap <buffer> }} ]%
endif

if dein#tap('goyo.vim')
	nnoremap <Leader>G :Goyo<CR>
endif

if dein#tap('vim-choosewin')
	nmap -         <Plug>(choosewin)
	nmap <Leader>- :<C-u>ChooseWinSwapStay<CR>
endif

if dein#tap('vimagit')
	nnoremap <silent> <Leader>mg :Magit<CR>
endif

if dein#tap('vim-fugitive')
	nnoremap <silent> <leader>ga :Git add %:p<CR>
	nnoremap <silent> <leader>gd :Gdiffsplit<CR>
	nnoremap <silent> <leader>gc :Git commit<CR>
	nnoremap <silent> <leader>gb :Git blame<CR>
	nnoremap <silent> <leader>gF :Gfetch<CR>
	nnoremap <silent> <leader>gS :Git<CR>
	nnoremap <silent> <leader>gp :Gpush<CR>
endif

if dein#tap('gv.vim')
	nmap <Leader>gv :GV! --all<cr>
	vmap <Leader>gv :GV! --all<cr>
endif

if dein#tap('vim-altr')
	nmap <leader>n  <Plug>(altr-forward)
	nmap <leader>N  <Plug>(altr-back)
endif

if dein#tap('undotree')
	nnoremap <Leader>gu :UndotreeToggle<CR>
endif

if dein#tap('vim-asterisk')
	map *   <Plug>(asterisk-g*)
	map g*  <Plug>(asterisk-*)
	map #   <Plug>(asterisk-g#)
	map g#  <Plug>(asterisk-#)

	map z*  <Plug>(asterisk-z*)
	map gz* <Plug>(asterisk-gz*)
	map z#  <Plug>(asterisk-z#)
	map gz# <Plug>(asterisk-gz#)
endif

if dein#tap('vim-expand-region')
	xmap v <Plug>(expand_region_expand)
	xmap V <Plug>(expand_region_shrink)
endif

if dein#tap('sideways.vim')
	nnoremap <silent> <, :SidewaysLeft<CR>
	nnoremap <silent> >, :SidewaysRight<CR>
	nnoremap <silent> [, :SidewaysJumpLeft<CR>
	nnoremap <silent> ], :SidewaysJumpRight<CR>
	omap <silent> a, <Plug>SidewaysArgumentTextobjA
	xmap <silent> a, <Plug>SidewaysArgumentTextobjA
	omap <silent> i, <Plug>SidewaysArgumentTextobjI
	xmap <silent> i, <Plug>SidewaysArgumentTextobjI
endif

if dein#tap('splitjoin.vim')
	let g:splitjoin_join_mapping = ''
	let g:splitjoin_split_mapping = ''
	nmap sj :SplitjoinJoin<CR>
	nmap sk :SplitjoinSplit<CR>
endif

if dein#tap('linediff.vim')
	vnoremap <Leader>mdf :Linediff<CR>
	vnoremap <Leader>mda :LinediffAdd<CR>
	nnoremap <Leader>mds :<C-u>LinediffShow<CR>
	nnoremap <Leader>mdr :<C-u>LinediffReset<CR>
endif

if dein#tap('dsf.vim')
	nmap dsf <Plug>DsfDelete
	nmap csf <Plug>DsfChange
endif

if dein#tap('caw.vim')
	function! InitCaw() abort
		if ! (&l:modifiable && &buftype ==# '')
			silent! nunmap <buffer> <Leader>V
			silent! xunmap <buffer> <Leader>V
			silent! nunmap <buffer> <Leader>v
			silent! xunmap <buffer> <Leader>v
			silent! nunmap <buffer> gc
			silent! xunmap <buffer> gc
			silent! nunmap <buffer> gcc
			silent! xunmap <buffer> gcc
		else
			xmap <buffer> <Leader>V <Plug>(caw:wrap:toggle)
			nmap <buffer> <Leader>V <Plug>(caw:wrap:toggle)
			xmap <buffer> <Leader>v <Plug>(caw:hatpos:toggle)
			nmap <buffer> <Leader>v <Plug>(caw:hatpos:toggle)
			nmap <buffer> gc <Plug>(caw:prefix)
			xmap <buffer> gc <Plug>(caw:prefix)
			nmap <buffer> gcc <Plug>(caw:hatpos:toggle)
			xmap <buffer> gcc <Plug>(caw:hatpos:toggle)
		endif
	endfunction
	autocmd user_events FileType * call InitCaw()
	call InitCaw()
endif

if dein#tap('vim-textobj-multiblock')
	omap <silent> ab <Plug>(textobj-multiblock-a)
	omap <silent> ib <Plug>(textobj-multiblock-i)
	xmap <silent> ab <Plug>(textobj-multiblock-a)
	xmap <silent> ib <Plug>(textobj-multiblock-i)
endif

if dein#tap('vim-textobj-function')
	omap <silent> af <Plug>(textobj-function-a)
	omap <silent> if <Plug>(textobj-function-i)
	xmap <silent> af <Plug>(textobj-function-a)
	xmap <silent> if <Plug>(textobj-function-i)
endif

if dein#tap('vimtex')
	autocmd user_events FileType tex,bib call s:vimtex_mappings()
	function! s:vimtex_mappings() abort
		function! s:map(mode, lhs, rhs, ...) abort
			if !hasmapto(a:rhs, a:mode)
				\ && index(get(g:vimtex_mappings_disable, a:mode, []), a:lhs) < 0
				\ && (empty(maparg(a:lhs, a:mode)) || a:0 > 0)
				silent execute a:mode . 'map <silent><nowait><buffer>' a:lhs a:rhs
			endif
		endfunction

		call s:map('n', '<leader>li', '<plug>(vimtex-info)')
		call s:map('n', '<leader>lI', '<plug>(vimtex-info-full)')
		call s:map('n', '<leader>lx', '<plug>(vimtex-reload)')
		call s:map('n', '<leader>lX', '<plug>(vimtex-reload-state)')
		call s:map('n', '<leader>ls', '<plug>(vimtex-toggle-main)')
		call s:map('n', '<leader>lq', '<plug>(vimtex-log)')
		call s:map('n', 'ds$', '<plug>(vimtex-env-delete-math)')
		call s:map('n', 'cs$', '<plug>(vimtex-env-change-math)')
		call s:map('n', 'dse', '<plug>(vimtex-env-delete)')
		call s:map('n', 'cse', '<plug>(vimtex-env-change)')
		call s:map('n', 'tse', '<plug>(vimtex-env-toggle-star)')
		call s:map('n', 'dsc',  '<plug>(vimtex-cmd-delete)')
		call s:map('n', 'csc',  '<plug>(vimtex-cmd-change)')
		call s:map('n', 'tsc',  '<plug>(vimtex-cmd-toggle-star)')
		call s:map('n', 'tsf',  '<plug>(vimtex-cmd-toggle-frac)')
		call s:map('x', 'tsf',  '<plug>(vimtex-cmd-toggle-frac)')
		call s:map('i', '<F7>', '<plug>(vimtex-cmd-create)')
		call s:map('n', '<F7>', '<plug>(vimtex-cmd-create)')
		call s:map('x', '<F7>', '<plug>(vimtex-cmd-create)')
		call s:map('n', 'dsd', '<plug>(vimtex-delim-delete)')
		call s:map('n', 'csd', '<plug>(vimtex-delim-change-math)')
		call s:map('n', 'tsd', '<plug>(vimtex-delim-toggle-modifier)')
		call s:map('x', 'tsd', '<plug>(vimtex-delim-toggle-modifier)')
		call s:map('n', 'tsD', '<plug>(vimtex-delim-toggle-modifier-reverse)')
		call s:map('x', 'tsD', '<plug>(vimtex-delim-toggle-modifier-reverse)')
		call s:map('i', ']]',  '<plug>(vimtex-delim-close)')
		if g:vimtex_doc_enabled
			call s:map('n', 'K', '<plug>(vimtex-doc-package)')
		endif
		if g:vimtex_compiler_enabled
			call s:map('n', '<leader>ll', '<plug>(vimtex-compile)')
			call s:map('n', '<leader>lo', '<plug>(vimtex-compile-output)')
			call s:map('n', '<leader>lL', '<plug>(vimtex-compile-selected)')
			call s:map('x', '<leader>lL', '<plug>(vimtex-compile-selected)')
			call s:map('n', '<leader>lk', '<plug>(vimtex-stop)')
			call s:map('n', '<leader>lK', '<plug>(vimtex-stop-all)')
			call s:map('n', '<leader>le', '<plug>(vimtex-errors)')
			call s:map('n', '<leader>lc', '<plug>(vimtex-clean)')
			call s:map('n', '<leader>lC', '<plug>(vimtex-clean-full)')
			call s:map('n', '<leader>lg', '<plug>(vimtex-status)')
			call s:map('n', '<leader>lG', '<plug>(vimtex-status-all)')
		endif
		if g:vimtex_motion_enabled
			" These are forced in order to overwrite matchit mappings
			call s:map('n', '%', '<plug>(vimtex-%)', 1)
			call s:map('x', '%', '<plug>(vimtex-%)', 1)
			call s:map('o', '%', '<plug>(vimtex-%)', 1)
			call s:map('n', ']]', '<plug>(vimtex-]])')
			call s:map('n', '][', '<plug>(vimtex-][)')
			call s:map('n', '[]', '<plug>(vimtex-[])')
			call s:map('n', '[[', '<plug>(vimtex-[[)')
			call s:map('x', ']]', '<plug>(vimtex-]])')
			call s:map('x', '][', '<plug>(vimtex-][)')
			call s:map('x', '[]', '<plug>(vimtex-[])')
			call s:map('x', '[[', '<plug>(vimtex-[[)')
			call s:map('o', ']]', '<plug>(vimtex-]])')
			call s:map('o', '][', '<plug>(vimtex-][)')
			call s:map('o', '[]', '<plug>(vimtex-[])')
			call s:map('o', '[[', '<plug>(vimtex-[[)')
			call s:map('n', ']M', '<plug>(vimtex-]M)')
			call s:map('n', ']m', '<plug>(vimtex-]m)')
			call s:map('n', '[M', '<plug>(vimtex-[M)')
			call s:map('n', '[m', '<plug>(vimtex-[m)')
			call s:map('x', ']M', '<plug>(vimtex-]M)')
			call s:map('x', ']m', '<plug>(vimtex-]m)')
			call s:map('x', '[M', '<plug>(vimtex-[M)')
			call s:map('x', '[m', '<plug>(vimtex-[m)')
			call s:map('o', ']M', '<plug>(vimtex-]M)')
			call s:map('o', ']m', '<plug>(vimtex-]m)')
			call s:map('o', '[M', '<plug>(vimtex-[M)')
			call s:map('o', '[m', '<plug>(vimtex-[m)')
			call s:map('n', ']/', '<plug>(vimtex-]/)')
			call s:map('n', ']*', '<plug>(vimtex-]*)')
			call s:map('n', '[/', '<plug>(vimtex-[/)')
			call s:map('n', '[*', '<plug>(vimtex-[*)')
			call s:map('x', ']/', '<plug>(vimtex-]/)')
			call s:map('x', ']*', '<plug>(vimtex-]*)')
			call s:map('x', '[/', '<plug>(vimtex-[/)')
			call s:map('x', '[*', '<plug>(vimtex-[*)')
			call s:map('o', ']/', '<plug>(vimtex-]/)')
			call s:map('o', ']*', '<plug>(vimtex-]*)')
			call s:map('o', '[/', '<plug>(vimtex-[/)')
			call s:map('o', '[*', '<plug>(vimtex-[*)')
		endif
		if g:vimtex_text_obj_enabled
			call s:map('x', 'id', '<plug>(vimtex-id)')
			call s:map('x', 'ad', '<plug>(vimtex-ad)')
			call s:map('o', 'id', '<plug>(vimtex-id)')
			call s:map('o', 'ad', '<plug>(vimtex-ad)')
			call s:map('x', 'i$', '<plug>(vimtex-i$)')
			call s:map('x', 'a$', '<plug>(vimtex-a$)')
			call s:map('o', 'i$', '<plug>(vimtex-i$)')
			call s:map('o', 'a$', '<plug>(vimtex-a$)')
			call s:map('x', 'iP', '<plug>(vimtex-iP)')
			call s:map('x', 'aP', '<plug>(vimtex-aP)')
			call s:map('o', 'iP', '<plug>(vimtex-iP)')
			call s:map('o', 'aP', '<plug>(vimtex-aP)')
			call s:map('x', 'im', '<plug>(vimtex-im)')
			call s:map('x', 'am', '<plug>(vimtex-am)')
			call s:map('o', 'im', '<plug>(vimtex-im)')
			call s:map('o', 'am', '<plug>(vimtex-am)')
			if vimtex#text_obj#targets#enabled()
				call vimtex#text_obj#targets#init()
				" These are handled explicitly to avoid conflict with gitgutter
				call s:map('x', 'ic', '<plug>(vimtex-targets-i)c')
				call s:map('x', 'ac', '<plug>(vimtex-targets-a)c')
				call s:map('o', 'ic', '<plug>(vimtex-targets-i)c')
				call s:map('o', 'ac', '<plug>(vimtex-targets-a)c')
			else
				if g:vimtex_text_obj_variant ==# 'targets'
					call vimtex#log#warning(
						\ "Ignoring g:vimtex_text_obj_variant = 'targets'"
						\ . " because 'g:loaded_targets' does not exist or is 0.")
				endif
				let g:vimtex_text_obj_variant = 'vimtex'
				call s:map('x', 'ie', '<plug>(vimtex-ie)')
				call s:map('x', 'ae', '<plug>(vimtex-ae)')
				call s:map('o', 'ie', '<plug>(vimtex-ie)')
				call s:map('o', 'ae', '<plug>(vimtex-ae)')
				call s:map('x', 'ic', '<plug>(vimtex-ic)')
				call s:map('x', 'ac', '<plug>(vimtex-ac)')
				call s:map('o', 'ic', '<plug>(vimtex-ic)')
				call s:map('o', 'ac', '<plug>(vimtex-ac)')
			endif
		endif
		nnoremap <silent> <leader>lt :<c-u>Denite vimtex<cr>
		if g:vimtex_imaps_enabled
			call s:map('n', '<leader>lm', '<plug>(vimtex-imaps-list)')
		endif
		if has_key(b:vimtex, 'viewer')
			call s:map('n', '<leader>lv', '<plug>(vimtex-view)')
			if has_key(b:vimtex.viewer, 'reverse_search')
				call s:map('n', '<leader>lr', '<plug>(vimtex-reverse-search)')
			endif
		endif
	endfunction
endif

" vim: set ts=2 sw=2 tw=80 noet :
