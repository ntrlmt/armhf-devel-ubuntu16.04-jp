if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath^=/root/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('/root/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
" NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'taketwo/vim-ros'
"" neocomplcache
NeoBundle 'Shougo/neocomplcache'
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
     \ 'default' : ''
     \ }

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
inoremap <expr><CR>  pumvisible() ? neocomplcache#close_popup() : "<CR>"

" Jedi for python
NeoBundleLazy "davidhalter/jedi-vim", {
     \ "autoload": { "filetypes": [ "python", "python3", "djangohtml"] }}

if ! empty(neobundle#get("jedi-vim"))
   let g:jedi#auto_initialization = 1
   let g:jedi#auto_vim_configuration = 1

   nnoremap [jedi] <Nop>
   xnoremap [jedi] <Nop>
   nmap <Leader>j [jedi]
   xmap <Leader>j [jedi]

   let g:jedi#completions_command = "<C-Space>"    "補完キーの設定この場合はCtrl+Space
   let g:jedi#goto_assignments_command = "<C-g>"   "変数の宣言場所へジャンプ（Ctrl + g)
   let g:jedi#goto_definitions_command = "<C-d>"   "クラス、関数定義にジャンプ（Gtrl + d）
   let g:jedi#documentation_command = "<C-k>"      "Pydocを表示（Ctrl + k）
   let g:jedi#rename_command = "[jedi]r"
   let g:jedi#usages_command = "[jedi]n"
   let g:jedi#popup_select_first = 0
   let g:jedi#popup_on_dot = 0

   autocmd FileType python setlocal completeopt-=preview0

   " for w/ neocomplete
    if ! empty(neobundle#get("neocomplete.vim"))
        autocmd FileType python setlocal omnifunc=jedi#completions
        let g:jedi#completions_enabled = 0
        let g:jedi#auto_vim_configuration = 0                              
        let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*' 
    endif
endif


" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck


