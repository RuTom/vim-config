" dimensions.vim: Functions for querying aspects of window dimensions.
"
" DEPENDENCIES:
"
" Copyright: (C) 2008-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.005.001	08-Apr-2013	file creation from autoload/ingowindow.vim
"   1.005.002	04-Apr-2020	removed NetVisibleLines() to drop dependency

function! dimensions#GetNumberWidth( isGetAbsoluteNumberWidth )
"******************************************************************************
"* PURPOSE:
"   Get the width of the number column for the current window.
"* ASSUMPTIONS / PRECONDITIONS:
"   None.
"* EFFECTS / POSTCONDITIONS:
"   None.
"* INPUTS:
"   a:isGetAbsoluteNumberWidth	If true, assumes absolute number are requested.
"				Otherwise, determines whether 'number' or
"				'relativenumber' are actually set and calculates
"				based on the actual window settings.
"* RETURN VALUES:
"   Width for displaying numbers. To use the result for printf()-style
"   formatting of numbers, subtract 1:
"   printf('%' . (dimensions#GetNumberWidth(1) - 1) . 'd', l:lnum)
"******************************************************************************
    let l:maxNumber = 0
    " Note: 'numberwidth' is only the minimal width, can be more if...
    if &l:number || a:isGetAbsoluteNumberWidth
	" ...the buffer has many lines.
	let l:maxNumber = line('$')
    elseif exists('+relativenumber') && &l:relativenumber
	" ...the window width has more digits.
	let l:maxNumber = winheight(0)
    endif
    if l:maxNumber > 0
	let l:actualNumberWidth = strlen(string(l:maxNumber)) + 1
	return (l:actualNumberWidth > &l:numberwidth ? l:actualNumberWidth : &l:numberwidth)
    else
	return 0
    endif
endfunction

" Determine the number of virtual columns of the current window that are not
" used for displaying buffer contents, but contain window decoration like line
" numbers, fold column and signs.
function! dimensions#WindowDecorationColumns()
    let l:decorationColumns = 0
    let l:decorationColumns += dimensions#GetNumberWidth(0)

    if has('folding')
	let l:decorationColumns += &l:foldcolumn
    endif

    if has('signs')
	redir => l:signsOutput
	silent execute 'sign place buffer=' . bufnr('')
	redir END

	" The ':sign place' output contains two header lines.
	" The sign column is fixed at two columns.
	if len(split(l:signsOutput, "\n")) > 2
	    let l:decorationColumns += 2
	endif
    endif

    return l:decorationColumns
endfunction

" Determine the number of virtual columns of the current window that are
" available for displaying buffer contents.
function! dimensions#NetWindowWidth()
    return winwidth(0) - dimensions#WindowDecorationColumns()
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :

