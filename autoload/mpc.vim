function! mpc#DisplayPlaylist()
    let playlist = mpc#GetPlaylist()
    for track in playlist
        let output = track.position. " "
                    \ . track.title
                    \ . track.artist
        if(playlist[0].position == track.position)
            execute "normal! 1GdGI" . output
        else
            call append(line('$'), output)
        endif
    endfor
endfunction
function! mpc#GetPlaylist()
    let cmd = "mpc --format '%position% @%title% @(%artist%)' playlist"
    let [result, playlist]= [split(system(cmd), '\n'), []]
    let maxLen = {'position': [], 'title': []}
    for item in result
        call add(playlist, mpc#EncodeSong(item))
    endfor
    for track in playlist
        call add(maxLen['position'], len(track.position))
        call add(maxLen['title'], len(track.title))
    endfor

    call sort(maxLen.position, "LargestNumber")
    call sort(maxLen.title, "LargestNumber")

    for track in playlist
        if(maxLen.position[-1] + 1 > len(track.position))
            let track.position = repeat(' ',
                        \ maxLen.position[-1] - len(track.position))
                        \ . track.position
        endif
        let track.position .= ' '
        let track.title.= repeat(' ', maxLen['title'][-1] + 2 - len(track.title))
    endfor
    return playlist
endfunction

function! LargestNumber(no1, no2)
    return a:no1 == a:no2 ? 0 : a:no1 > a:no2 ? 1 : -1
endfunction

function! mpc#PlaySong(no)
    echo a:no
    let song = split(getline(a:no), " ")
    let result = split(system("mpc --format '%title% (%artist%)' play "
                \ . string(a:no)), "\n")
    let message = '[mpc] NOW PLAYING: ' . result[0]
    echomsg message
endfunction
function! mpc#EncodeSong(item)
    let item = split(a:item, " @")
    let song = {'position': item[0],
                \ 'title': '@ti' . item[1] . 'ti@',
                \ 'artist': '@ar' . item[2] . 'ar@'}
    return song
endfunction
function! mpc#DecodeSong(item) abort
    let line_items = split(substitute(a:item, ' \{2,}', ' ', 'g'), ' @')
    let song = {'position': line_items[0],
                \ 'title': line_items[1][2:-4],
                \ 'artist': line_items[2][2:-4]}
    return song
endfunction

function! mpc#TogglePlayback()
    let command = 'mpc toggle'
    let result = split(system(command), '\n')[1]
    let message = '[mpc] '
    let message .= split(result, ' ')[0] == '[paused]' ? 'PAUSED' : 'PLAYING'
    echomsg message
endfunction
function! mpc#ToggleRandom()
    let command = 'mpc random'
    let result = split(system(command), '\n')
    let status = len(result) == 3 ? result[2] : result[0]
    let message = split(status, ' ')[2] == 'random: off'
                \ ? '[mpc] RANDOM: OFF' : '[mpc] RANDOM: ON'
    echomsg message
endfunction
function! mpc#ToggleRepeat()
    let command = 'mpc repeat'
    let result = split(system(command), '\n')
    let status = len(result) == 3 ? result[2] : result[0]
    let message = split(status, ' ')[1] == 'repeat: off'
                \ ? '[mpc] REPEAT: OFF' : '[mpc] REPEAT: ON'
    echomsg message
endfunction
