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
