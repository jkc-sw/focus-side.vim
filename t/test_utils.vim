
func! s:Test_arg_check()
    for Testfun in [function('focus_side#utils#arg_check'), function('focus_side#focusSide')]
        unlet! g:focus_side_max_width_ratio
        call testify#assert#equals(exists('g:focus_side_max_width_ratio'), 0)

        call Testfun()
        call testify#assert#not_equals(exists('g:focus_side_max_width_ratio'), 0)

        let g:focus_side_max_width_ratio = 1.3
        call Testfun()
        call testify#assert#equals(g:focus_side_max_width_ratio, 1)

        let g:focus_side_max_width_ratio = -1.3
        call Testfun()
        call testify#assert#equals(g:focus_side_max_width_ratio, 0)

        for ratio in [0, 0.21, 0.53, 0.77, 0.91]
            let g:focus_side_max_width_ratio = ratio
            call Testfun()
            call testify#assert#equals(g:focus_side_max_width_ratio, ratio)
        endfor

        unlet! g:focus_side_max_windows
        call testify#assert#equals(exists('g:focus_side_max_windows'), 0)

        call Testfun()
        call testify#assert#not_equals(exists('g:focus_side_max_windows'), 0)

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
    unlet! g:focus_side_max_width_ratio
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
call testify#it('Option are checked as expected', function('s:Test_opt_check'))

func! s:Test_get_not_content_width()
    set signcolumn=no
    set norelativenumber
    set nonumber
    set foldcolumn=0
    call testify#assert#equals(focus_side#utils#get_not_content_width(), 0)

    set signcolumn=yes
    set norelativenumber
    set nonumber
    set foldcolumn=0
    call testify#assert#equals(focus_side#utils#get_not_content_width(), 2)

    set signcolumn=yes:3
    set norelativenumber
    set nonumber
    set foldcolumn=0
    call testify#assert#equals(focus_side#utils#get_not_content_width(), 6)

    set signcolumn=no
    set relativenumber
    set nonumber
    set foldcolumn=0
    call testify#assert#equals(focus_side#utils#get_not_content_width(), &numberwidth)

    set signcolumn=no
    set norelativenumber
    set number
    set foldcolumn=0
    call testify#assert#equals(focus_side#utils#get_not_content_width(), &numberwidth)
endfunc
call testify#it('knows how many columns are not for content', function('s:Test_get_not_content_width'))
