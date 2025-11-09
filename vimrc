vim9script

###########################################################################               
#               
#               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
#               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
#               ██║   ██║██║██╔████╔██║██████╔╝██║     
#               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
#                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
#                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
#               
###########################################################################          


# USEFUL INFO & LINKS ----------------------------------------------------- {{{

# https://github.com/saccarosium/awesome-vim9 # Vim9 Script Plugins

# }}}

# GENERAL CONFIG ---------------------------------------------------------- {{{

# nice defaults from Bram and the The Vim Project 
source $VIMRUNTIME/defaults.vim

# set tab width for Vim files
autocmd FileType vim setlocal expandtab
autocmd FileType vim setlocal shiftwidth=2
autocmd FileType vim setlocal softtabstop=2

# ConfigSetENV on what OS does Vim run ----------i---------------- {{{

# The function needs to be near the top since it has to be known for later use

# Sets only once the value of g:Env to the running environment

def ConfigSetEnv()
  if exists('g:My_Env')
    return
  endif
  # win64 implies win32
  if has('win64') || has('win32')
    const g:My_Env = 'WINDOWS'
  elseif has('win32unix')
    const g:My_Env = 'WINDOWS32UNIX'
  elseif executable('uname')
    const g:My_Env = toupper(trim(system('uname')))
  else
    const g:My_Env = 'UNKNOWN'
    echoerr 'Config_setEnv: Unable to determine operating system.'
  endif
enddef

ConfigSetEnv()

# setting some variables depending on my OS

# var g:my_vimfiles_directory: string

if g:My_Env == 'WINDOWS'
  g:my_vimfiles_dir = expand('~/vimfiles')
elseif g:My_Env == 'DARWIN'
  g:my_vimfiles_dir = expand('~/.vim')
elseif g:My_Env == 'LINUX'
  g:my_vimfiles_dir = expand('~/.vim')
else
  g:my_vimfiles_dir = expand('~/.vim')
  echoerr 'Config_setEnv: Unable to set my_vimfiles_directory according to the OS.'
endif

# }}}

# }}}


# PLUGINS via PLUG ------------------------------------------------------- {{{

var my_plug_directory: string

if g:My_Env == 'WINDOWS'
  my_plug_directory = expand('~/vimfiles/plugged') 
else
  # probably needs modification on Linux and MacOS
  # works on Darwin, has to check on Linux
  my_plug_directory = expand('~/.vim/plugged')
endif

plug#begin(my_plug_directory)

 # which-key as first plugin to catch all other plugins mappings
 
Plug 'liuchengxu/vim-which-key'

# Set , as the leader key.
var mapleader = ","
nnoremap <silent> <leader> :WhichKey ','<CR>
# By default timeoutlen is 1000 ms
set timeoutlen=500
 
Plug 'bluz71/vim-mistfly-statusline'
# display indent status in statusline
g:mistflyWithIndentStatus = v:true
# display searchcount in statusline, requires hlsearch to be on
g:mistflyWithSearchCount = v:true
# Show the status on the second to last line.
set laststatus=2

# asyncrun to run shell commands without waiting for the finish and
# displaying the output in quickfix window
Plug 'skywind3000/asyncrun.vim'
  
# let asyncrun automatically open the quickfix window with 8 lines
# you can open it with :copen and close it with :cclose
g:asyncrun_open = 8

# highlights yanked text for a short duration
Plug 'machakann/vim-highlightedyank'

# Colorscheme

Plug 'ayu-theme/ayu-vim'
# enable true colors support
set termguicolors     
# ayucolor="light"
var ayucolor = "mirage"
# ayucolor="dark"

# colorscheme ayu has to be set outside of Plug


Plug 'jiangmiao/auto-pairs'

Plug 'lervag/vimtex'

Plug 'mhinz/vim-startify'

# using Obsession for automatically save session changes,
# also in use with Startify sessions
# :SLoad       load a session    startify-:SLoad
# :SSave[!]    save a session    startify-:SSave
# :SDelete[!]  delete a session  startify-:SDelete
# :SClose      close a session   startify-:SClose
Plug 'tpope/vim-obsession'

# defining Startify Bookmarks
# don't use mappings provide in startify-mappings
# e.g. q, e, i, b, s, v, t

if g:My_Env == 'WINDOWS'
  # to be defined
elseif g:My_Env == 'DARWIN'
  g:startify_bookmarks = [  
                            {'c': '~/repos/dotfiles-vim/vimrc'}, 
                            {'d': '~/repos/dotfiles-vim/'}, 
                            {'z': '~/.zshrc'}, 
                            {'l': '~/Library/Mobile Documents/com~apple~CloudDocs/!dh/dh-letters/' },
                            {'o': '~/vaults/' },
                            {'r': '~/repos/' },
                          ]
endif

# setting a custom footer
g:startify_custom_footer = ['Remember, ,v for editing .vimrc and ,u for updating it!']

# disable random quotes header for startify
g:startify_custom_header = []

Plug 'lervag/vimtex'

g:vimtex_view_method = 'SumatraPDF'


# org-mode
Plug 'jceb/vim-orgmode'
  
# org-mode recommend the following packages
  
# general support for text linking. The hyperlinks feature of vim-orgmode 
# depends on this plugin.
Plug 'vim-scripts/utl.vim'
  
# Repeat actions that would not be repeatable otherwise. This plugin is
# needed when you want to repeat the previous orgmode action.
Plug 'tpope/vim-repeat'

# Display tags for the currently edited file. Vim-orgmode ships with support
# for displaying the heading structure and hyperlinks in the taglist plugin.
Plug 'yegappan/taglist'

# large collection of language packs for Vim
# disable the Markdown support from Polyglot and load the newest one later
# instead
g:polyglot_disabled = ['markdown']
Plug 'sheerun/vim-polyglot'

# for the use of linters or ale with markdown have a look at
# https://codeinthehole.com/tips/writing-markdown-in-vim/
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'

# various Markdown settings

# Treat all .md files as markdown
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.txt set filetype=markdown

# Have lines wrap instead of continue off-screen
autocmd FileType markdown set linebreak

# Disable cursor line and column highlight
autocmd FileType markdown set nocursorline
autocmd FileType markdown set nocursorcolumn

# Use two spaces instead of tabs and for indents
autocmd FileType markdown set expandtab
autocmd FileType markdown set shiftwidth=2
autocmd FileType markdown set tabstop=2

# Keep cursor in approximately the middle of the screen
autocmd FileType markdown set scrolloff=12

# Enable folding.
g:vim_markdown_folding_disabled = 0

# Fold heading in with the contents.
g:vim_markdown_folding_style_pythonic = 1

# Don't use the shipped key bindings.
g:vim_markdown_no_default_key_mappings = 1

# Autoshrink TOCs.
g:vim_markdown_toc_autofit = 1

# Indentation for new lists. We don't insert bullets as it doesn't play
# nicely with `gq` formatting. It relies on a hack of treating bullets
# as comment characters.
# See https://github.com/plasticboy/vim-markdown/issues/232
g:vim_markdown_new_list_item_indent = 0
g:vim_markdown_auto_insert_bullets = 0

# Filetype names and aliases for fenced code blocks.
g:vim_markdown_fenced_languages = ['php', 'py=python', 'js=javascript', 'bash=sh', 'viml=vim']

# Highlight front matter (useful for Hugo posts) or my letter toml config.
g:vim_markdown_toml_frontmatter = 1
g:vim_markdown_json_frontmatter = 1
g:vim_markdown_frontmatter = 1

# Format strike-through text (wrapped in `~~`).
g:vim_markdown_strikethrough = 1


plug#end()

# }}}

# enabling the colorscheme loaded by Plug
#

colorscheme ayu


# VIMSCRIPT -------------------------------------------------------------- {{{

# Enable the marker method of folding.
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

# a function that inserts the date 
def Today()
  var today = strftime("%A %m\/%d\/%Y")
  exe "normal a" .. today
enddef
command! Today Today()


# a function that inserts the date 
def Heute()
  var heute = strftime("%A %m.%d.%Y")
  exe "normal a" .. heute
enddef
command! Heute Heute()

# Vim's swap, backup, and undo file storage
# Vim’s various temporary files look like this:
#
# foo.txt       <-- original file
# .foo.txt.swp  <-- Vim's swap file
# .foo.txt.un~  <-- Vim's undo file
# foo.txt~      <-- Vim's backup file

# set undodir=~/.vim/backup 
# set doesn't work with variables

var my_state_dir: string

if g:My_Env == "WINDOWS"
  my_state_dir = g:my_vimfiles_dir .. '/state'
else
  my_state_dir = expand('~/.local/state/vim')
endif

# setting undo dir
&undodir = my_state_dir .. '/undo/'
mkdir(&undodir, 'p')        # create the directory if missing

set undofile
set undoreload=10000

# setting swap directory, // at the end tells Vim to use unique filenames
&directory = my_state_dir .. '/swap//'
mkdir(&directory, 'p')        # create the directory if missing

# setting backup directory, // at the end tells Vim to use unique filenames
&backupdir = my_state_dir .. '/backup//'
mkdir(&backupdir, 'p')        # create the directory if missing
set backup


# You can split a window into sections by typing `:split` or `:vsplit`.
# Display cursorline and cursorcolumn ONLY in active window.
augroup cursor_off
    autocmd!
    autocmd WinLeave * set nocursorline nocursorcolumn
    autocmd WinEnter * set cursorline cursorcolumn
augroup END

# }}}


# MAPPINGS -------------------------------------------------------------- {{{
#

# MAPPINGS - VISUAL MODE ------------------------------------------------ {{{
#

# fix <BS>/<DEL> in Visual Block mode
vmap <BS> x

# }}}

# MAPPINGS - INSERT MODE ------------------------------------------------ {{{
#


# }}}

# MAPPINGS - NORMAL MODE ------------------------------------------------ {{{
#

# make folding easier for me - map space to za (toggle fold)
#

nnoremap <space> za

# }}}

# }}}

# GUI SETTINGS ------------------------------------------------------------ {{{


if has('gui_running')

    # Set the background tone.
    set background=dark

    # Set a custom font you have installed on your computer.
    # Syntax: <font_name>\ <weight>\ <size>
    # set guifont=CamingoCode:h14

    set guifont=BlexMono\ Nerd\ Font\ Mono:h14

    # Display more of the file by default.
    # Hide the toolbar.
    set guioptions-=T

    # Hide the the left-side scroll bar.
    set guioptions-=L

    # Hide the the left-side scroll bar.
    set guioptions-=r

    # Hide the the menu bar.
    set guioptions-=m

    # Hide the the bottom scroll bar.
    set guioptions-=b

    # Map the F4 key to toggle the menu, toolbar, and scroll bar.
    # <Bar> is the pipe character.
    # <CR> is the enter key.
    nnoremap <F4> :if &guioptions=~#'mTr'<Bar>
        \set guioptions-=mTr<Bar>
        \else<Bar>
        \set guioptions+=mTr<Bar>
        \endif<CR>

    # emter fullscreen in GUI Mode
    set fullscreen

endif

# }}}
