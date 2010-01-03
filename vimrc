set nocompatible
syntax on
filetype plugin indent on
set encoding=utf-8
set mouse=a
set ruler
set number
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoread
" Normal behaviour of backspace key
set backspace=indent,eol,start

" Set terminal to 256 colors
set t_Co=256
" Textmate scheme colors clone
"colorscheme vividchalk
" colorscheme vibrantink
colorscheme herald

" don't keep backup after close
set nobackup
" do keep a backup while working
set writebackup
" Store temporary files in a central spot
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp


" Set tag files
set tags=tags,./tags,tmp/tags,./tmp/tags


" Default browser
command -bar -nargs=1 OpenURL :!firefox <args> 2>&1 >/dev/null &


" Set minium window size
set wmh=0
" Mapeamos las teclas + y - para que nos maximice o minimice la ventana actual
if bufwinnr(1)
	map + <C-W>_
	map - <C-W>=
endif


" Move between tabs
" Note: tabnext = gt AND tabprevious = gT
" nnoremap <c-n> <esc>:tabnext<CR>
" nnoremap <c-p> <esc>:tabprevious<CR>
" nnoremap <silent> <C-t> :tabnew<CR>
" tip 199 (comments) - Open actual buffer in a tab and then close
nmap t% :tabedit %<CR>
nmap td :tabclose<CR>
nmap tn :tabnew<CR>


" Paste from X clipboard to vim
" Commented to use Visual blocks
vnoremap <C-C> "+y
"noremap <C-V> <ESC>"+gP
inoremap <C-V> <ESC>"+gPi


"  move text and rehighlight -- vim tip_id=224
"vnoremap > ><CR>gv
"vnoremap < <<CR>gv
" Enable TAB indent and SHIFT-TAB unindent
vnoremap <silent> <TAB> >gv
vnoremap <silent> <S-TAB> <gv


" A really status line
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
if &statusline == ''
	"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
	set statusline=[%n]\ %<%.99f\ %h%w%m%r%y%=%-16(\ %l,%c-%v\ %)%P
end
set laststatus=2


" Toggle paste mode
nmap <silent> <F2> :set invpaste<CR>:set paste?<CR>
" Toggle Highlight search - deprecated now I use :nohl
"nmap <silent> <F3> :set invhls<CR>:set hls?<CR>
" Toggle List 
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <F3> :set invlist<CR>:set list?<CR>
" set text wrapping toggles
nmap <silent> <F4> :set invwrap<CR>:set wrap?<CR>


" ACK integration
set grepprg=ack-grep 
set grepformat=%f:%l:%m

" Find searched_string in directories(...)
function RailsGrep(searched_string,...)
	let s:dir_list = ''
	for dir in a:000
		let s:dir_list = s:dir_list . dir
	endfor
	execute "silent! grep --ruby " . a:searched_string . " " . s:dir_list
	botright cw
	redraw!
endfunction
" Find searched_string in all project(app and lib directories)
:command -nargs=+ Rgrep call RailsGrep('<q-args>',"app/ lib/ config/initializers vendor/plugins")
" Find  definition in the project(models,controllers,helpers and lib)
:command -nargs=1 Rgrepdef call RailsGrep("'def .*" . <q-args> . "'","app/models app/controllers app/helpers lib/ config/initializers vendor/plugins")


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Recommendations from http://items.sjbach.com/319/configuring-vim-right "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 
" Jump to mark line and column
nnoremap ' `
" Jump to mark line
nnoremap ` '

" Keep a longer history
set history=100

" Use case-smart searching
set ignorecase 
set smartcase

" Set terminal title
set title

" Maintain more context around the cursor
set scrolloff=3
set sidescrolloff=5

" When a bracket is insert, briefly jump to the matching one.
set showmatch
" Show command in the last line of the screen
set showcmd

" Make file/command completion useful
" Show a wildmenu when try to find a command or file
set wildmenu
set wildmode=longest,full

" Read on comments:
set diffopt+=iwhite             " ignore whitespace in diff mode


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Trinity																			                  "
" This small plugin is just an IDE manager to control the three "
" plugins(NERDtree, Source Explorer and Taglist)                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F5> :TrinityToggleAll<CR>
map <F6> :TrinityToggleSourceExplorer<CR>
map <F7> :TrinityToggleTagList<CR>
map <F8> :TrinityToggleNERDTree<CR>

"" NERDtree
" XXX - Modified in Trinity_InitNERDTree function at line 147 in trinity.vim
" Set the window width to default
" let g:NERDTreeWinSize = 30
" Highlight the cursor line
" let g:NERDTreeHighlightCursorline = 1

"" TagList
"
" Sort type by order(default) or name
" XXX - Modified in Trinity_InitNERDTree function at line 93 in trinity.vim
"let Tlist_Sort_Type = 'name'


"""""""""""""""""""""""""""""""""""""""""""""""""
" FuzzyFinder                                   "
" Provides convenient ways to quickly reach the "
" buffer/file/command/bookmark/tag you want.    "
"""""""""""""""""""""""""""""""""""""""""""""""""
let g:fuzzy_ignore = "*.log,*.jpg,*.png,*.gif,*.swp"
let g:fuzzy_matching_limit = 70
map <leader>ft :FuzzyFinderTextMate<CR>
map <leader>ff :FuzzyFinderFile<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""
" Matchit                                         "
" Load matchit (% to bounce from do to end, etc.) "
"""""""""""""""""""""""""""""""""""""""""""""""""""
runtime! plugin/matchit.vim
runtime! macros/matchit.vim


""""""""""""""""""""""""""""""""""""""""""""""""""
" allml                                          "
" Provide maps for editing tags                  "
""""""""""""""""""""""""""""""""""""""""""""""""""
let g:allml_global_maps = 1 


""""""""""""""""""""""""""""""""""""""""""""""""""
" gist                                           "
""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gist_open_browser_after_post = 1
let g:gist_detect_filetype = 1
let g:gist_browser_command = 'firefox %URL% &'

""""""""""""""""""""""""""""""""""""""""""""""""""
" Snipmate with AutoComplPop(acp)                "
""""""""""""""""""""""""""""""""""""""""""""""""""
let g:acp_behaviorSnipmateLength = 1
let g:acp_ignorecaseOption = 0


""""""""""""""""""""""""""""""""""""""""""""""""""
" VCScommand                                     "
" VIM 7 plugin useful for manipulating files     "
" controlled by CVS, SVN, SVK, git, bzr, and hg. "
""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove detault mappings
let VCSCommandDisableMappings=1

""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimwiki                                        "
""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vimwiki_list = [{'path': '~/Documents/vimwiki/',
			\ 'path_html': '~/Documents/vimwiki_html/'}]


""""""""""""""""""""""""""""""""""""""""""""""""""
" Ruby Debugger                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:ruby_debugger_fast_sender = 1
