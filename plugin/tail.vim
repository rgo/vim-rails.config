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
