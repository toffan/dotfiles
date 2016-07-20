" toffan.vim

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "toffan"

" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLine         ctermbg=236  cterm=none
  hi CursorColumn       ctermbg=236  cterm=none
  hi MatchParen         ctermbg=59   cterm=none
  hi Pmenu              ctermbg=242  cterm=none
  hi PmenuSel           ctermfg=0    ctermbg=184
endif


" General colors
hi Cursor               ctermbg=241  cterm=none
hi Normal               ctermfg=254  cterm=none
hi NonText              ctermfg=242  cterm=none
hi LineNr               ctermfg=242  cterm=none
hi CursorLineNr         ctermfg=202  cterm=none
hi Visual               ctermbg=232  cterm=reverse
hi Folded               ctermfg=187  ctermbg=234

" Syntax
hi Comment              ctermfg=244  cterm=none

hi Constant             ctermfg=25   cterm=none
hi String               ctermfg=25   cterm=none
hi Number               ctermfg=187  cterm=none
hi Boolean              ctermfg=187  cterm=none

hi Identifier           ctermfg=184  cterm=none

hi Statement            ctermfg=125  cterm=none

hi PreProc              ctermfg=187  cterm=none

hi Type                 ctermfg=81   cterm=none

hi Special              ctermfg=26   cterm=none

hi Todo                 ctermfg=245  cterm=none

" Syntastic
hi SignColumn           ctermbg=none
hi SyntasticErrorSign   ctermfg=160
hi SyntasticWarningSign ctermfg=202
hi SyntasticError       ctermfg=160  cterm=underline
hi SyntasticWarning     ctermfg=202  cterm=underline

" Vimdiff
hi DiffAdd              ctermbg=235  cterm=bold
hi DiffDelete           ctermbg=235  cterm=bold
hi DiffChange           ctermbg=235  cterm=bold
hi DiffText             ctermbg=160  cterm=bold

" Git
hi diffAdded            ctermfg=2
hi diffRemoved          ctermfg=1

" Spell
hi clear SpellBad
hi SpellBad             ctermfg=203  cterm=underline
