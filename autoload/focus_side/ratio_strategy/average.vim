func! focus_side#ratio_strategy#average#get_width_active_window()
    let curr_vis_line_start = line('w0')
    let curr_vis_line_end = line('w$')

    let screen_width = str2float(&columns)

    let sum = 0.0
    let non_empty_nlines = 0
    for lnum in range(curr_vis_line_start, curr_vis_line_end)
        let llen = strwidth(getline(lnum))
        if llen > 0
            let sum += llen
            let non_empty_nlines += 1
        endif
    endfor

    let content_width = (non_empty_nlines == 0) ? 0 : floor(sum / non_empty_nlines)
    let target_width = 0.5*(screen_width + content_width)

    return float2nr(target_width)
endfunc
