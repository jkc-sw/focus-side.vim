
func! s:Test_arg_check()
    for Testfun in [function('focus_side#utils#arg_check'), function('focus_side#focusSide')]
        unlet! g:focus_side_ratio
        call testify#assert#equals(exists('g:focus_side_ratio'), 0)

        call Testfun()
        call testify#assert#equals(g:focus_side_ratio, 0.6)

        let g:focus_side_ratio = 1.3
        call Testfun()
        call testify#assert#equals(g:focus_side_ratio, 1)

        let g:focus_side_ratio = -1.3
        call Testfun()
        call testify#assert#equals(g:focus_side_ratio, 0)

        for ratio in [0, 0.21, 0.53, 0.77, 0.91]
            let g:focus_side_ratio = ratio
            call Testfun()
            call testify#assert#equals(g:focus_side_ratio, ratio)
        endfor

        unlet! g:focus_side_max_windows
        call testify#assert#equals(exists('g:focus_side_max_windows'), 0)

        call Testfun()
        call testify#assert#equals(g:focus_side_max_windows, 3)

        let g:focus_side_max_windows = 1
        call Testfun()
        call testify#assert#equals(g:focus_side_max_windows, 2)

        for numwin in range(2, 10)
            let g:focus_side_max_windows = numwin
            call Testfun()
            call testify#assert#equals(g:focus_side_max_windows, numwin)
        endfor
    endfor

    unlet! g:focus_side_max_windows
    unlet! g:focus_side_ratio
    call focus_side#focusSide()
endfunc
call testify#it('Arguments are working as expected', function('s:Test_arg_check'))

func! s:Test_opt_check()
    let default_opt = { 'toggle_enable': v:true, 'toggle_offset': -2 }
    let got = focus_side#utils#opt_check({})
    call testify#assert#equals(default_opt, got)

    for Testfun in [function('focus_side#utils#opt_check'), function('focus_side#focusSide')]
        " let default_opt = { 'toggle_enable': v:true, 'toggle_offset': -2 }
        " let got = Testfun({})
        " call testify#assert#equals(default_opt, Testfun({}))
    endfor
endfunc
" call testify#it('Option are checked as expected', function('s:Test_opt_check'))

func! s:Test_target_offset_active_window()
    for indt in [0, 2, 4, 8, 12, 16]
        for llen in [0, 10, 20, 33, 55, 79, 111, 167]
            for nline in [0, 10, 33, 88, 1122]
                exec '%d'

                for lineidx in range(nline)
                    call append(0, repeat(' ', indt) . repeat('a', llen))
                endfor

                norm! 50%
                let got = focus_side#utils#target_offset_active_window()
                call testify#assert#equals(got, (indt + llen) / 2)
            endfor
        endfor
    endfor
endfunc
" call testify#it('Get the currect width for the active window', function('s:Test_target_offset_active_window'))
