
func! focus_side#focusSide(...)

    call focus_side#utils#arg_check()
    let opts = focus_side#utils#opt_check((a:0 > 0) ? a:1 : {})

    let buffers_orig = tabpagebuflist()
    let curr_buffer = bufnr()
    let right_width = float2nr(floor(g:focus_side_ratio*str2float(&columns)))
    let right_height = &lines - &cmdheight - 1 - ((tabpagenr('$') > 1) ? 1 : 0)
    let curr_width = winwidth(0)
    let curr_height = winheight(0)

    let bufs = []
    for idx in range(len(buffers_orig)-1, 0, -1)
        let b = buffers_orig[idx]

        if len(bufs) >= g:focus_side_max_windows
            break
        endif

        if !buflisted(b)
            continue
        endif

        if index(bufs, b) == -1
            let bufs = insert(bufs, b)
        endif
    endfor

    if len(buffers_orig) == 1
        silent vertical botright split
        call focus_side#utils#resize_active_window(right_width)
    else
        if len(bufs) == 1
            silent exec 'buffer '.bufs[0]
            silent only!
        else
            let curr_buff_index = index(bufs, curr_buffer)

            let toggle_enable = opts['toggle_enable']
                \ && len(bufs) > 1
                \ && len(bufs) >= (-1*opts['toggle_offset'])
                \ && curr_buff_index == (len(bufs) - 1)
                \ && curr_width == right_width
                \ && curr_height == right_height

            if toggle_enable
                let curr_buffer = bufs[opts['toggle_offset']]
                let bufs[opts['toggle_offset']] = bufs[-1]
                let bufs[-1] = curr_buffer
            endif

            let cleared = v:false
            for w in range(0, len(bufs) - 1)
                if w == curr_buff_index
                    continue
                endif

                if !cleared
                    silent exec 'buffer '.bufs[w]
                    silent only!
                    let cleared = v:true
                else
                    silent exec 'belowright sbuffer '.bufs[w]
                endif
            endfor
        endif

        silent exec 'vertical botright sbuffer '.curr_buffer
        call focus_side#utils#resize_active_window(right_width)
    endif
endfun
