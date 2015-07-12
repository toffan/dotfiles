" toffan.vim

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "toffan"

" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLine         ctermbg=236
  hi CursorColumn       ctermbg=236
  hi MatchParen         ctermbg=59
  hi Pmenu	        ctermbg=242
  hi PmenuSel           ctermfg=0 ctermbg=184
endif


" General colors
hi Cursor	        ctermbg=0x241
hi Normal	        ctermfg=254
hi NonText              ctermfg=242
hi LineNr	        ctermfg=242
hi CursorLineNr	        ctermfg=202
hi Visual		ctermfg=186 ctermbg=238

" Syntax highlighting
hi Comment	        ctermfg=244
hi Todo                 ctermfg=245
hi Constant             ctermfg=159
hi String	        ctermfg=202
hi Identifier           ctermfg=202
hi Function             ctermfg=184
hi Type                 ctermfg=184
hi Statement            ctermfg=131
hi Keyword		ctermfg=184
hi PreProc              ctermfg=187
hi Number		ctermfg=187
hi Special		ctermfg=159

hi BadWhitespace        ctermbg=red

" YouCompleteMe highlighting
hi SignColumn           ctermbg=none
hi SyntasticErrorSign   ctermfg=160
hi SyntasticWarningSign ctermfg=162
hi SyntasticError       ctermfg=232 ctermbg=160
hi SyntasticWarning     ctermfg=232 ctermbg=162
