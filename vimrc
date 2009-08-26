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
" Set terminal to 256 colors
set t_Co=256
"
" Textmate scheme colors clone
"colorscheme vividchalk
colorscheme vibrantink
"set visualbell

" Remap leader (finally I will try it)
let mapleader = ","

"set nobackup
" Store temporary files in a central spot
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Normal behaviour of backspace key
set backspace=indent,eol,start

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
nnoremap <c-n> <esc>:tabnext<cr>
nnoremap <c-p> <esc>:tabprevious<cr>
nnoremap <silent> <C-t> :tabnew<CR>
" tip 199 (comments) - Open actual buffer in a tab and then close
nmap t% :tabedit %<CR>
nmap td :tabclose<CR>


" Paste from X clipboard to vim
" Commented to use Visual blocks
vnoremap <C-C> "+y
"noremap <C-V> <ESC>"+gP
inoremap <C-V> <ESC>"+gPi


" Follow help links with enter
nmap <buffer> <CR> <C-]>
" Back to previous help page with backspace
nmap <buffer> <BS> <C-T>

" Ommnicompletion for:
" 	javascript
" 	html
" 	css
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:ruby_minlines = 500
" Load matchit (% to bounce from do to end, etc.)
runtime! plugin/matchit.vim
runtime! macros/matchit.vim

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


au FileType haskell,vhdl,ada let b:comment_leader = '-- '
au FileType vim let b:comment_leader = '" '
au FileType c,cpp,java let b:comment_leader = '// '
au FileType ruby,sh,make let b:comment_leader = '# '
au FileType tex let b:comment_leader = '% '


" Complete filenames like a terminal(show list) - :help wildmode
" set wildmode=longest,list:full
"
" Tip 1386 [http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE]
"set completeopt=longest,menuone


"Autoinstall GetLatestVimScripts
let g:GetLatestVimScripts_allowautoinstall=1


" Gist options
"   * if you want to open browser after the post...
let g:gist_open_browser_after_post = 1
"     # detect filetype if vim failed auto-detection.
let g:gist_detect_filetype = 1
let g:gist_browser_command = 'firefox %URL% &'


" tip 908 -Quick generic option toggling http://vim.wikia.com/wiki/Quick_generic_option_toggling  
" Map key to toggle opt
function MapToggle(key, opt) 
 let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>" 
 exec 'nnoremap '.a:key.' '.cmd 
 exec 'inoremap '.a:key." \<C-O>".cmd 
endfunction 

command -nargs=+ MapToggle call MapToggle(<f-args>) 

MapToggle <F2> paste 
MapToggle <F3> hlsearch 
MapToggle <F4> wrap 

" The following will make tabs and trailing spaces visible when requested(F10) 
" set listchars=tab:>-,trail:·,eol:$
" MapToggle <F10> list 
" MapToggle <F11> scrollbind 


" Load NERD_tree
map <F9> :NERDTreeToggle<CR>

" NERDCommenter
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
nmap \\ <Plug>NERDCommenterInvert
xmap \\ <Plug>NERDCommenterInvert
 

"VCScommand
" Remove detault mappings
let VCSCommandDisableMappings=1
" Show log related to the current file
nmap <leader>cl :VCSLog<CR>
" Show diffs with version in the CVS
nmap <leader>cd :VCSVimDiff<CR>
" Check-in the current version
nmap <leader>ci :VCSCommit <CR>
" Update current file
nmap <leader>cu :VCSUpdate <CR>
" Shows the status of the file
nmap <leader>cs :VCSStatus<CR>




" Fuzzy Finder modified by Jamis Buck
let g:fuzzy_ignore = "*.log,*.jpg,*.png,*.gif,*.swp"
let g:fuzzy_matching_limit = 70

map <leader>t :FuzzyFinderTextMate<CR>
map <leader>b :FuzzyFinderBuffer<CR>
map <leader>f :FuzzyFinderFile<CR>

" ACK integration
set grepprg=ack 
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

" If at end of a line of spaces, delete back to the previous line.
" Otherwise, <Left>
inoremap <silent> <C-B> <C-R>=getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"<CR>
cnoremap <C-B> <Left>
" If at end of line, decrease indent, else <Del>
inoremap <silent> <C-D> <C-R>=col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"<CR>
cnoremap <C-D> <Del>
" If at end of line, fix indent, else <Right>
inoremap <silent> <C-F> <C-R>=col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"<CR>
inoremap <C-E> <End>
cnoremap <C-F> <Right>

" Ruby Debugger
" see :help ruby-debugger to understand it. Only for POSIX systems
let g:ruby_debugger_fast_sender = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Recommendations from http://items.sjbach.com/319/configuring-vim-right
 
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add the contents of this file to your ~/.vimrc file
"
"
" Crucial setting, set to the dir in which your ruby projects reside

let base_dir = "/home/leptom/Workspace/" . expand("%")

" Central additions (also add the functions below)

:command RTlist call CtagAdder("app/models","app/controllers","app/views","public", "config", "lib")

map <F7> :RTlist<CR>

" Optional, handy TagList settings

:nnoremap <silent> <F8> :Tlist<CR>

let Tlist_Compact_Format = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Process_File_Always = 1

let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1

let Tlist_WinWidth = 35

let Tlist_Highlight_Tag = 1

let Tlist_Sort_Type = 'name'


" Function that gets the dirtrees for the provided dirs and feeds 
" them to the TlAddAddFiles function below

func CtagAdder(...)
	let curdir = getcwd()
	let index = 1
	let s:dir_list = ''
	while index <= a:0
		let s:dir_list = s:dir_list . TlGetDirs(a:{index})
		let index = index + 1
	endwhile
	call TlAddAddFiles(s:dir_list)
	wincmd p
	exec "normal ="
	wincmd p
	exec "cd " . curdir
endfunc 

" Adds *.rb, *.rhtml and *.css files to TagList from a given list
" of dirs

func TlAddAddFiles(dir_list)
	let dirlist = a:dir_list
	let s:olddir = getcwd()
	while strlen(dirlist) > 0
		let curdir = substitute (dirlist, '|.*', "", "")
		let dirlist = substitute (dirlist, '[^|]*|\?', "", "")
		exec "cd " . g:base_dir
		exec "TlistAddFiles " . curdir . "/*.rb"
		exec "TlistAddFiles " . curdir . "/*.rhtml"
		exec "TlistAddFiles " . curdir . "/*.erb"
		exec "TlistAddFiles " . curdir . "/*.css"
"		exec "TlistAddFiles " . curdir . "/*.js"
	endwhile
	exec "cd " . s:olddir
endfunc

" Gets all dirs within a given dir, returns them in a string,
" separated by '|''s

func TlGetDirs(start_dir)
	try
		let s:olddir = getcwd()
		exec "cd " . g:base_dir . '/' . a:start_dir
		let dirlist = a:start_dir . '|'
		let dirlines = glob ('*')
		let dirlines = substitute (dirlines, "\n", '/', "g")
		while strlen(dirlines) > 0
			let curdir = substitute (dirlines, '/.*', "", "")
			let dirlines = substitute (dirlines, '[^/]*/\?', "", "")
			if isdirectory(g:base_dir . '/' . a:start_dir . '/' . curdir)
				let dirlist = dirlist . TlGetDirs(a:start_dir . '/' . curdir)
			endif
		endwhile
		exec "cd " . s:olddir
		return dirlist
	catch 344
		return ''
	endtry
	endfunc
