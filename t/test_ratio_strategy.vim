func! s:Test_get_width_active_window_average()
    let screen_width = str2float(&columns)
    wincmd o

    for indt in [0, 2, 4, 8, 12, 16]
        for llen in [0, 10, 20, 33, 55, 79, 111, 167, 218, 336]
            for nline in [10, 33, 88, 1122]
                exec '%d'

                for lineidx in range(nline)
                    call append(0, repeat(' ', indt) . repeat('a', llen))
                endfor

                norm! 50%

                let got = focus_side#ratio_strategy#average#get_width_active_window()
                let content_width = indt + llen
                let expected = float2nr(0.5*(content_width + screen_width))

                call testify#assert#equals(got, expected)
            endfor
        endfor
    endfor
endfunc
call testify#it('Get the desired width for the active window by average ratio', function('s:Test_get_width_active_window_average'))
