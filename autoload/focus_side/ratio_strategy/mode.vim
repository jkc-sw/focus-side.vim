func! focus_side#ratio_strategy#mode#arg_check()
    if !exists('g:focus_side_mode_bin_width')
        let g:focus_side_mode_bin_width = 5
    endif

    if g:focus_side_mode_bin_width < 1
        let g:focus_side_mode_bin_width = 1
    endif
endfunc

func! focus_side#ratio_strategy#mode#get_width_active_window()
    call focus_side#ratio_strategy#mode#arg_check()
    let screen_width = str2float(&columns)

    let curr_vis_line_start = line('w0')
    let curr_vis_line_end = line('w$')

    let counter = {}
    for lnum in range(curr_vis_line_start, curr_vis_line_end)
        let llen = str2float(strwidth(getline(lnum)))
        if llen > 0
            let bin_idx = float2nr(ceil(llen / g:focus_side_mode_bin_width))
            if !has_key(counter, bin_idx)
                let counter[bin_idx] = 0
            endif
            let counter[bin_idx] += 1
        endif
    endfor

    if empty(counter)
        return focus_side#ratio_strategy#fixed#get_width_active_window()
    endif

    let bin_idx_max = -1
    let current_max = -1
    let ck = sort(keys(counter), 'N')
    for k in ck
        let v = counter[k]
        if v >= current_max
            let current_max = v
            let bin_idx_max = str2nr(k)
        endif
    endfor

    let content_width = bin_idx_max * g:focus_side_mode_bin_width

    let window_width = 0.5*(content_width + screen_width)

    return float2nr(window_width) + focus_side#utils#get_not_content_width()
endfunc
