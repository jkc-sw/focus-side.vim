
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

func! focus_side#utils#opt_check(args)
    let opts = (a:args == {}) ? { 'toggle_enable': v:true, 'toggle_offset': -2 } : a:args

    if !has_key(opts, 'toggle_enable')
        let opts['toggle_enable'] = v:true
    endif
    if !has_key(opts, 'toggle_offset')
        let opts['toggle_offset'] = -2
    endif

    if -1*opts['toggle_offset'] > g:focus_side_max_windows
        throw "The toggle_offset should not set higher than ".string(-1*g:focus_side_max_windows)
    endif

    return opts
endfunc

func! focus_side#utils#resize_active_window(width)
    silent exec 'vertical resize '.a:width
endfunc

func! focus_side#utils#target_offset_active_window()
    let screen_width = str2float(&columns)
    let screen_height = &lines - &cmdheight - 1 - ((tabpagenr('$') > 1) ? 1 : 0)
    let screen_center = float2nr(screen_width / 2.0)

    let curr_vis_line_start = line('w0')
    let curr_vis_line_end = line('w$')

    let sum = 0.0
    let non_empty_nlines = 0
    for lnum in range(curr_vis_line_start, curr_vis_line_end)
        let llen = strwidth(getline(lnum))
        if llen > 0
            let sum += llen / 2.0
            let non_empty_nlines += 1
        endif
    endfor

    let content_center = sum / non_empty_nlines
    return content_center
endfunc
