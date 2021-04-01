func! focus_side#ratio_strategy#fixed#get_width_active_window()
    return float2nr(floor(g:focus_side_max_width_ratio*str2float(&columns)))
endfunc
