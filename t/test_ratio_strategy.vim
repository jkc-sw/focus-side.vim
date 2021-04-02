func! s:Test_get_width_active_window_fixed()
    set signcolumn=no
    set norelativenumber
    set nonumber
    set foldcolumn=0

    let g:focus_side_ratio_strategy = 'focus_side#ratio_strategy#fixed#get_width_active_window'
    let g:focus_side_max_width_ratio = 0.5
    let screen_width = str2float(&columns)
    silent wincmd o

    for indt in [0, 2, 4, 8, 12, 16]
        for llen in [0, 10, 20, 33, 55, 79, 111, 167, 218, 336]
            for nline in [0, 10, 33, 88, 1122]
                exec '%d'

                for lineidx in range(nline)
                    call append(0, repeat(' ', indt) . repeat('a', llen))
                endfor

                norm! 50%

                let got = focus_side#utils#get_width_active_window()
                let expected = float2nr(g:focus_side_max_width_ratio*screen_width)
                call testify#assert#equals(got, expected)
            endfor
        endfor
    endfor
endfunc
call testify#it('Get the desired width for the active window by fixed ratio', function('s:Test_get_width_active_window_fixed'))

func! s:Test_get_width_active_window_average()
    set signcolumn=no
    set norelativenumber
    set nonumber
    set foldcolumn=0

    let g:focus_side_ratio_strategy = 'focus_side#ratio_strategy#average#get_width_active_window'
    let g:focus_side_max_width_ratio = 0.9
    let screen_width = str2float(&columns)
    silent wincmd o

    for indt in [0, 2, 4, 8, 12, 16]
        for llen in [0, 10, 20, 33, 55, 79, 111, 167, 218, 336]
            for nline in [10, 33, 88, 1122]
                exec '%d'

                for lineidx in range(nline)
                    call append(0, repeat(' ', indt) . repeat('a', llen))
                endfor

                norm! 50%

                let got = focus_side#utils#get_width_active_window()

                let content_width = indt + llen
                let expected = float2nr(0.5*(content_width + screen_width)) + focus_side#utils#get_not_content_width()

                let max_width = float2nr(g:focus_side_max_width_ratio*screen_width)
                let expected = (expected < max_width) ? expected : max_width

                call testify#assert#equals(got, expected)
            endfor
        endfor
    endfor
endfunc
call testify#it('Get the desired width for the active window by average ratio', function('s:Test_get_width_active_window_average'))

func! s:Test_get_width_active_window_mode()
    unlet! g:focus_side_mode_bin_width
    call testify#assert#equals(exists('g:focus_side_mode_bin_width'), 0)

    call focus_side#ratio_strategy#mode#arg_check()
    call testify#assert#not_equals(exists('g:focus_side_mode_bin_width'), 0)

    set signcolumn=no
    set norelativenumber
    set nonumber
    set foldcolumn=0

    let g:focus_side_ratio_strategy = 'focus_side#ratio_strategy#mode#get_width_active_window'
    let g:focus_side_max_width_ratio = 0.9
    let screen_width = str2float(&columns)

    silent wincmd o
    exec '%d'
    call append(line('$'), '    33')
    call append(line('$'), '    33')
    let g:focus_side_mode_bin_width = 1

    let got = focus_side#utils#get_width_active_window()
    let expected = float2nr(0.5*(6 + screen_width)) + focus_side#utils#get_not_content_width()

    silent wincmd o
    exec '%d'
    call append(line('$'), '    33')
    call append(line('$'), '    33')
    call append(line('$'), '    337777777777')
    call append(line('$'), '    337777777777')
    call append(line('$'), '    337777777777')
    call append(line('$'), '    337777777777')
    call append(line('$'), '    337777777777')
    call append(line('$'), '    337777777777')
    call append(line('$'), '    3355')
    call append(line('$'), '    3355')
    call append(line('$'), '    3355')
    call append(line('$'), '    3355')
    let g:focus_side_mode_bin_width = 5

    let got = focus_side#utils#get_width_active_window()
    let expected = float2nr(0.5*(20 + screen_width)) + focus_side#utils#get_not_content_width()

    let max_width = float2nr(g:focus_side_max_width_ratio*screen_width)
    let expected = (expected < max_width) ? expected : max_width

    call testify#assert#equals(got, expected)
endfunc
call testify#it('Get the desired width for the active window by mode', function('s:Test_get_width_active_window_mode'))

func! s:Test_get_width_active_window_turbo_mode()
    unlet! g:focus_side_mode_bin_width
    call testify#assert#equals(exists('g:focus_side_mode_bin_width'), 0)

    call focus_side#ratio_strategy#turbo_mode#arg_check()
    call testify#assert#not_equals(exists('g:focus_side_mode_bin_width'), 0)

    set signcolumn=no
    set norelativenumber
    set nonumber
    set foldcolumn=0

    let g:focus_side_ratio_strategy = 'focus_side#ratio_strategy#turbo_mode#get_width_active_window'
    let g:focus_side_max_width_ratio = 0.9
    let screen_width = str2float(&columns)

    silent wincmd o
    exec '%d'
    call append(line('$'), '    333333')
    call append(line('$'), '        33')
    call append(line('$'), '        33')
    let g:focus_side_mode_bin_width = 1

    let got = focus_side#utils#get_width_active_window()
    let expected = float2nr(0.5*(15 + 8 + screen_width)) + focus_side#utils#get_not_content_width()

    silent wincmd o
    exec '%d'
    call append(line('$'), '    33')
    call append(line('$'), '    33')
    call append(line('$'), '    337777777777')
    call append(line('$'), '    337777777777')
    call append(line('$'), '    337777777777')
    call append(line('$'), '        33557777')
    call append(line('$'), '        33557777')
    call append(line('$'), '        33557777')
    call append(line('$'), '        33557777')
    call append(line('$'), '        33557777')
    call append(line('$'), '        33557777')
    call append(line('$'), '        33557777')
    let g:focus_side_mode_bin_width = 5

    let got = focus_side#utils#get_width_active_window()

    let expected = float2nr(0.5*(20 + 8 + screen_width)) + focus_side#utils#get_not_content_width()

    let max_width = float2nr(g:focus_side_max_width_ratio*screen_width)
    let expected = (expected < max_width) ? expected : max_width

    call testify#assert#equals(got, expected)
endfunc
call testify#it('Get the desired width for the active window by turbo mode', function('s:Test_get_width_active_window_turbo_mode'))
