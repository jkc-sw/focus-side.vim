
func! focus_side#focusSide(...)
    call focus_side#utils#arg_check()

    let opt = (a:0 > 0)? a:1 : { 'toggle_enable': v:true, 'toggle_offset': -2 }
    if !has_key(opt, 'toggle_enable')
        let opt['toggle_enable'] = v:true
    endif
    if !has_key(opt, 'toggle_offset')
        let opt['toggle_offset'] = -2
    endif

    if -1*opt['toggle_offset'] > g:focus_side_max_windows
        throw "The toggle_offset should not set higher than ".string(-1*g:focus_side_max_windows)
    endif

    let buffers_orig = tabpagebuflist()
    let curr_buffer = bufnr()
    let right_width = float2nr(floor(g:focus_side_ratio*str2float(&columns)))
    let right_height = &lines - &cmdheight - 1
    let curr_width = winwidth(0)
    let curr_height = winheight(0)

    let buffers = []
    for idx in range(len(buffers_orig)-1, 0, -1)
        let b = buffers_orig[idx]

        if len(buffers) >= g:focus_side_max_windows
            break
        endif

        if !buflisted(b)
            continue
        endif

        if index(buffers, b) == -1
            let buffers = insert(buffers, b)
        endif
    endfor

    if len(buffers_orig) == 1
        silent exec 'vertical botright split | vertical resize '.right_width
    else
        if len(buffers) == 1
            silent exec 'buffer '.buffers[0]
            silent only!
        else
            let curr_buff_index = index(buffers, curr_buffer)

            let toggle_enable = opt['toggle_enable']
                \ && len(buffers) > 1
                \ && len(buffers) >= (-1*opt['toggle_offset'])
                \ && curr_buff_index == (len(buffers) - 1)
                \ && curr_width == right_width
                \ && curr_height == right_height

            if toggle_enable
                let curr_buffer = buffers[opt['toggle_offset']]
                let buffers[opt['toggle_offset']] = buffers[-1]
                let buffers[-1] = curr_buffer
            endif

            let cleared = v:false
            for w in range(0, len(buffers) - 1)
                if w == curr_buff_index
                    continue
                endif

                if !cleared
                    silent exec 'buffer '.buffers[w]
                    silent only!
                    let cleared = v:true
                else
                    silent exec 'belowright sbuffer '.buffers[w]
                endif
            endfor
        endif

        silent exec 'vertical botright sbuffer '.curr_buffer.' | vertical resize '.right_width
    endif
endfun
