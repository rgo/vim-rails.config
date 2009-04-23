"------------------------------------------------------------------------------
"  Description: Works like "tail -f" .
"	   $Id: tail.vim 773 2007-09-17 08:58:57Z krischik $
"   Maintainer: Martin Krischik (krischik@users.sourceforge.net)
"		Jason Heddings (vim at heddway dot com)
"      $Author: krischik $
"	 $Date: 2007-09-17 10:58:57 +0200 (Mo, 17 Sep 2007) $
"      Version: 3.0
"    $Revision: 773 $
"     $HeadURL: https://gnuada.svn.sourceforge.net/svnroot/gnuada/trunk/tools/vim/autoload/tail.vim $
"      History: 22.09.2006 MK Improve for vim 7.0
"		15.10.2006 MK Bram's suggestion for runtime integration
"		05.11.2006 MK Bram suggested not to use include protection for
"			      autoload
"		07.11.2006 MK Tabbed Tail
"               31.12.2006 MK Bug fixing
"               01.01.2007 MK Bug fixing
"    Help Page: tail.txt
"------------------------------------------------------------------------------

if version < 700
   finish
else
   let s:Status_Char = "|"

   " set the default options for the plugin
   if !exists("g:tail#Height")
      let g:tail#Height = 10
   endif

   if !exists("g:tail#Center_Win")
      let g:tail#Center_Win = 0
   endif

   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
   " sets up the preview window to watch the specified file for changes
   "
   function tail#Open (type, file)					" {{{1
      let l:file = substitute(expand(a:file), "\\", "/", "g")

      if !filereadable(l:file)
	 echohl ErrorMsg
	 echo "Cannot open for reading: " . l:file
	 echohl None
      else
	 " if the buffer is already open, kill it
	 " in case there is a preview window already, also removes autocmd's
	 "silent pclose

	 if bufexists (bufnr (l:file))
	    execute ':' . bufnr(l:file) . 'bwipeout'
	 endif
	 " set it up to be watched closely

	 augroup Tail
	    " monitor calls -- try to catch the update as much as possible
	    autocmd CursorHold	* :call tail#Monitor()
	    autocmd CursorHoldI * :call tail#Monitor()
	    autocmd FocusLost	* :call tail#Monitor()
	    autocmd FocusGained * :call tail#Monitor()
	    autocmd BufEnter	* :call tail#Monitor()

	    " utility calls
	    execute 'autocmd BufWinEnter '	. l:file . " :call tail#Setup()"
	    execute 'autocmd BufWinLeave '	. l:file . " :call tail#Stop()"
	    execute 'autocmd FileChangedShell ' . l:file . " :call tail#Refresh()"
	 augroup END

	 " set up the new window with minimal functionality
	 silent execute a:type . " " . l:file
      endif

      return
   endfunction								" }}}1

   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
   " watch the specified file for changes in different split window
   "
   function tail#Open_Split (file)					" {{{1
      "if has ('win32') || has ('win64')
	 "call tail#Open ('pedit', a:file)
      "else
	 call tail#Open (g:tail#Height . 'new', a:file)
      "endif

      return
   endfunction tail#Open_Spluit						" }}}1

   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
   " watch the specified file for changes in different tabs
   "
   function tail#Open_Tabs (...)					" {{{1
      for l:i in a:000
	 call tail#Open ('tabnew', l:i)
      endfor

      return
   endfunction tail#Open_Tabs						" }}}1

   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
   " used by Tail to check the file status
   "
   function tail#Monitor ()						" {{{1
      " do our file change checks
      "if has ('win32') || has ('win64')
	 "" checktime won't work all that well with windows
	 "pedit!
      "else
	 " the easy check
	 checktime   " the easy check
      "endif

      call tail#Status ()
   endfunction								" }}}1

   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
   " used by Tail to check the file status
   "
   function tail#Status ()						" {{{1
      " update the status indicator
      if s:Status_Char == "|"
	 let s:Status_Char = "/"
      elseif s:Status_Char == "/"
	 let s:Status_Char = "-"
      elseif s:Status_Char == "-"
	 let s:Status_Char = "\\"
      elseif s:Status_Char == "\\"
	 let s:Status_Char = "|"
      endif

      return s:Status_Char
   endfunction								" }}}1

   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
   " used by Tail to set up the preview window settings
   "
   function tail#Setup ()						" {{{1
      setlocal autoread
      setlocal bufhidden=delete
      setlocal nobuflisted
      setlocal nomodifiable
      setlocal nonumber
      setlocal noshowcmd
      setlocal noswapfile
      setlocal nowrap
      setlocal previewwindow

      nnoremap <buffer> i :setlocal wrap<CR>
      nnoremap <buffer> I :setlocal nowrap<CR>

      nnoremap <buffer> a :setlocal number<CR>
      nnoremap <buffer> A :setlocal nonumber<CR>

      nnoremap <buffer> o :setlocal statusline=%F\ %{tail#Status()}<CR>
      nnoremap <buffer> O :setlocal statusline<<CR>

      nnoremap <buffer> r :call tail#Refresh ()<CR>
      nnoremap <buffer> R :view!<CR>

      call tail#SetCursor()
   endfunction								" }}}1

   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
   " used by Tail to refresh the window contents & position
   " use this instead of autoread for silent reloading and better control
   "
   function tail#Refresh()						" {{{1
      if &previewwindow
	 " if the cursor is on the last line, we'll move it with the update

	 let l:update_cursor  = line(".") == line("$")
	 let l:wrap	      = &wrap
	 let l:number	      = &number
	 let l:statusline     = &statusline

	 " do all the necessary updates
	 silent execute "view!"

	 if l:wrap
	    set wrap
	 endif

	 if l:number
	    set number
	 endif

	 execute 'set statusline=' . escape (l:statusline, ' \')

	 if l:update_cursor
	    call tail#SetCursor()
	 endif
      else
	 try
	    " jump to the preview window to reload
	    wincmd P

	    " do all the necessary updates
	    silent execute "view!"

	    call tail#SetCursor()

	    " jump back
	    wincmd p
	 endtry
      endif
   endfunction								" }}}1

   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
   " used by Tail to set the cursor position in the preview window
   " assumes that the correct window has already been selected
   "
   function tail#SetCursor()						" {{{1
      normal G
      if g:tail#Center_Win
	 normal zz
      endif
   endfunction								" }}}1

   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
   " used by Tail to stop watching the file and clean up
   "
   function tail#Stop()							" {{{1
      autocmd! Tail
      augroup! Tail
   endfunction								" }}}1

finish

"------------------------------------------------------------------------------
"   Copyright (C) 2006	Martin Krischik
"
"   Vim is Charityware - see ":help license" or uganda.txt for licence details.
"------------------------------------------------------------------------------
" vim: textwidth=78 nowrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab
" vim: filetype=vim foldmethod=marker
