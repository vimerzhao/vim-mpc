syntax region mpdTitle matchgroup=mpdTitleSyn start=/@ti/ end=/ti@/ concealends
syntax region mpdArtist matchgroup=mpdArtistSyn start=/@ar/ end=/ar@/ concealends

highlight default mpdTitle ctermbg=234 ctermfg=lightblue
            \ guibg=#1c1c1c guifg=#ffafff
highlight default mpdArtist ctermbg=234 ctermfg=lightgreen
            \ guibg=#1c1c1c guifg=#5fff87
