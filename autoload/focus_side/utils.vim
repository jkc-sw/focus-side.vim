
func! focus_side#utils#arg_check()
    if !exists('g:focus_side_max_width_ratio')
        let g:focus_side_max_width_ratio = 0.6
    endif
    if g:focus_side_max_width_ratio > 1
        let g:focus_side_max_width_ratio = 1
    elseif g:focus_side_max_width_ratio < 0
        let g:focus_side_max_width_ratio = 0
    endif

    if !exists('g:focus_side_ratio_strategy')
        let g:focus_side_ratio_strategy = 'focus_side#ratio_strategy#fixed#get_width_active_window'
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

func! focus_side#utils#get_width_active_window()
    let screen_width = str2float(&columns)
    let max_width = floor(g:focus_side_max_width_ratio * screen_width)
    let desired = function(g:focus_side_ratio_strategy)()
    if desired > max_width
        return float2nr(max_width)
    else
        return float2nr(desired)
    endif
endfunc

" let screen_height = &lines - &cmdheight - 1 - ((tabpagenr('$') > 1) ? 1 : 0)
