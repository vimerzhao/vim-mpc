function! OpenMPC()
    if(bufexists('mpc.mpdv'))
        let mpcwin = bufwinnr('mpc.mpdv')
        if(mpcwin == -1)
            execute "sbuffer " . bufnr('mpc.mpdv')
        else
            execute mpcwin . 'wincmd w'
            return
        endif
    else
        execute "new mpc.mpdv"
        call mpc#DisplayPlaylist()
    endif
endfunction

command! MpcBrowser call OpenMPC()
command! TogglePlayback call mpc#TogglePlayback()