
func! focus_side#utils#arg_check()
    if !exists('g:focus_side_ratio')
        let g:focus_side_ratio = 0.6
    endif
    if g:focus_side_ratio > 1
        let g:focus_side_ratio = 1
    elseif g:focus_side_ratio < 0
        let g:focus_side_ratio = 0
    endif

    if !exists('g:focus_side_max_windows')
        let g:focus_side_max_windows = 3
    endif
    if g:focus_side_max_windows < 2
        let g:focus_side_max_windows = 2
    endif
endfunc
