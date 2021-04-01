func! focus_side#ratio_strategy#percentile#get_width_active_window()
    let curr_vis_line_start = line('w0')
    let curr_vis_line_end = line('w$')

    let elements = []
    for lnum in range(curr_vis_line_start, curr_vis_line_end)
        let llen = strwidth(getline(lnum))
        if llen > 0
            let elements += [llen]
        endif
    endfor

    let elements = sort(elements, 'n')
    let idx = float2nr(ceil(len(elements) * 0.5))

    let content_center = elements[-1]
    return content_center
endfunc
