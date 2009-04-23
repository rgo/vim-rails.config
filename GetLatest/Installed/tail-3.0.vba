" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
tail_options.vim	[[[1
63
"------------------------------------------------------------------------------
"  Description: Options setable by the Tail plugin
"	   $Id: tail_options.vim 773 2007-09-17 08:58:57Z krischik $
"    Copyright: Copyright (C) 2006 Martin Krischik
"   Maintainer:	Martin Krischik (krischik@users.sourceforge.net)
"      $Author: krischik $
"	 $Date: 2007-09-17 10:58:57 +0200 (Mo, 17 Sep 2007) $
"      Version: 2.2
"    $Revision: 773 $
"     $HeadURL: https://gnuada.svn.sourceforge.net/svnroot/gnuada/trunk/tools/vim/tail_options.vim $
"      History:	17.11.2006 MK Tail_Options
"               01.01.2007 MK Bug fixing
"	 Usage: copy content into your .vimrc and change options to your
"		likeing.
"    Help Page: tail.txt
"------------------------------------------------------------------------------

echoerr 'It is suggested to copy the content of ada_options into .vimrc!'
finish " 1}}}

" Section: Tail options {{{1

   let g:tail#Height	   = 10
   let g:tail#Center_Win   = 0

   let g:mapleader	   = "<F12>"

   filetype plugin indent on
   syntax enable

" }}}1

" Section: Vimball options {{{1
:set noexpandtab fileformat=unix encoding=utf-8
:.+2,.+6 MkVimball tail-3.0.vba

tail_options.vim
autoload/tail.vim
doc/tail.txt
macros/vim-tail.zsh
plugin/tail.vim

" }}}1

" Section: Tar options {{{1

tar --create --bzip2		 \
   --file="tail-3.0.tar.bz2"	 \
   tail_options.vim		 \
   autoload/tail.vim		 \
   doc/tail.txt			 \
   macros/vim-tail.zsh		 \
   plugin/tail.vim		 ;

" }}}1

"------------------------------------------------------------------------------
"   Copyright (C) 2006	Martin Krischik
"
"   Vim is Charityware - see ":help license" or uganda.txt for licence details.
"------------------------------------------------------------------------------
" vim: textwidth=0 nowrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab
" vim: foldmethod=marker
autoload/tail.vim	[[[1
235
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
doc/tail.txt	[[[1
102
*Tail.txt*	   Watch the contents of a file in real time

Author: Jason Heddings (jason@heddings.com)
	Martin Krischik (krischik@users.sourceforge.net)
For Vim version 7.0 and above
Last change: 17 September, 2007

1. Overview                                     |tail-about|
2. Commands                                     |tail-commands|
2. Mappings                                     |tail-mappings|
3. Configuration				|tail-configure|

==============================================================================
                                                *tail-about*
1. Overview~

Tail allows you to view the contents of a file in real time.  When a
change in the file is detected, the window displaying the file is updated and
repositioned to the last line.

The update is not exactly real time, but usually updates within a few seconds
of the file change.  The update interval of the output is determined by the
|updatetime| parameter, along with continued usage of Vim.  This means that if
you are not doing any editing or motion commands, the preview window will not
be updated.  See |CursorHold| for more information.

Because this window becomes the preview window, it will accept all related
commands.  For more information, see |preview-window|.

==============================================================================
							       *tail-commands*
2. Commands~

The Tail plugin does not create any automatic mappings, but provides the
following commands:

|:Tail|          begin watching the specified file
|:STail|         Same as :Tail
|:TabTail|       begin watching the specified files in seperate Tabs

							      *:Tail* *:STail*
:Tail <filename>
:STail <filename>
        Begin watching the specified file in the preview window.  This will
        cause any existing preview windows to be closed.  If the file is
        already open in another buffer, that buffer will be wiped out.

								    *:TabTail*
:TabTail  <filenames>
        Begin watching the specified files in tabed preview windows.

Once open, the window accepts all preview window commands.  For example, to
close the preview window, use |:pclose|.

							       *:vim-tail.zsh*

You can also open one or more files for (tabbed) tailing using |vim-tail.zsh|
which is provided in the macros directory. |vim-tail.zsh| will use a single
gvim server and |:TabTail| to open the files.

==============================================================================
							       *tail-mappings*
2. Mappings~

Once the Tail windows is opened it offeres the following mappings:

<i> :setlocal wrap<CR>
<I> :setlocal nowrap<CR>

<a> :setlocal number<CR>
<A> :setlocal nonumber<CR>

<o> :setlocal statusline=%F\ %{tail#Status()}<CR>
<O> :setlocal statusline<<CR>

<r> :call tail#Refresh ()<CR>
<R> :view!<CR>

==============================================================================
                                                *tail-configure*
3. Configuration~

Tail may be customized using variables set by the |let| command in your
.vimrc file.  The default values for the options are shown in square brackets.

|'Tail_Height'|      Specify the height of the preview window [10]
|'Tail_Center_Win'|  Center the output in the preview window   [0]

                                                *'Tail_Height'*
Tail_Height~
  Using this setting, you can alter the height of the preview window that is
  created when |:Tail| is called for a file.  >
      let g:Tail_Height = 12
<
Tail_Center_Win~
  When set to true, this will cause the last line of the output to be centered
  in the preview window.  By default, the last line of output will be on the
  last line of the window >
      let g:Tail_Center_Win = 1
<
==============================================================================
vim:textwidth=78:tabstop=8:noexpandtab:filetype=help
macros/vim-tail.zsh	[[[1
34
#!/bin/zsh
#------------------------------------------------------------------------------
#  Description: Works like "tail -f" .
#          $Id: tail.vim,v 1.1 2007/09/10 09:31:47 krischikm Exp $
#   Maintainer: Martin Krischik (krischik@users.sourceforge.net)
#      $Author: krischikm $
#        $Date: 2007/09/10 09:31:47 $
#      Version: 3.0
#    $Revision: 1.1 $
#     $HeadURL: https://gnuada.svn.sourceforge.net/svnroot/gnuada/trunk/tools/vim/plugin/tail.vim $
#      History: 17.11.2007 Now with Startup Scripts.
#    Help Page: tail.txt
#------------------------------------------------------------------------------

setopt No_X_Trace;

for I ; do
    if
        gvim --servername "tail" --remote-send ":TabTail ${I}<CR>";
    then
        ; # do nothing
    else
        gvim --servername "tail" --remote-silent +":TabTail %<CR>" "${I}"
    fi
    sleep 1;
done;

#------------------------------------------------------------------------------
#   Copyright (C) 2006  Martin Krischik
#
#   Vim is Charityware - see ":help license" or uganda.txt for licence details.
#------------------------------------------------------------------------------
#vim: set nowrap tabstop=8 shiftwidth=4 softtabstop=4 noexpandtab :
#vim: set textwidth=0 filetype=zsh foldmethod=marker nospell :
plugin/tail.vim	[[[1
40
"------------------------------------------------------------------------------
"  Description: Works like "tail -f" .
"          $Id: tail.vim 773 2007-09-17 08:58:57Z krischik $
"   Maintainer: Martin Krischik (krischik@users.sourceforge.net)
"               Jason Heddings (vim at heddway dot com)
"      $Author: krischik $
"        $Date: 2007-09-17 10:58:57 +0200 (Mo, 17 Sep 2007) $
"      Version: 3.0
"    $Revision: 773 $
"     $HeadURL: https://gnuada.svn.sourceforge.net/svnroot/gnuada/trunk/tools/vim/plugin/tail.vim $
"      History: 22.09.2006 MK Improve for vim 7.0
"               15.10.2006 MK Bram's suggestion for runtime integration
"		05.11.2006 MK Bram suggested to save on spaces
"               07.11.2006 MK Tabbed Tail
"               31.12.2006 MK Bug fixing
"               01.01.2007 MK Bug fixing
"               17.11.2007 Now with Startup Scripts.
"    Help Page: tail.txt
"------------------------------------------------------------------------------

if exists('g:Tail_Loaded') || version < 700
   finish
endif

let g:Tail_Loaded = 22

" command exports
command -nargs=1 -complete=file Tail    call tail#Open_Split   (<q-args>)
command -nargs=1 -complete=file STail   call tail#Open_Split   (<q-args>)
command -nargs=* -complete=file TabTail call tail#Open_Tabs    (<f-args>)

finish " 1}}}

"------------------------------------------------------------------------------
"   Copyright (C) 2006  Martin Krischik
"
"   Vim is Charityware - see ":help license" or uganda.txt for licence details.
"------------------------------------------------------------------------------
" vim: textwidth=0 nowrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab
" vim: filetype=vim foldmethod=marker
