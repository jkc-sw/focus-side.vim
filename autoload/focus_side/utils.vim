
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
    call focus_side#utils#arg_check()
    let screen_width = str2float(&columns)
    let max_width = floor(g:focus_side_max_width_ratio * screen_width)
    let desired = function(g:focus_side_ratio_strategy)()
    if desired > max_width
        return float2nr(max_width)
    else
        return float2nr(desired)
    endif
endfunc

func! focus_side#utils#get_not_content_width()
    " Reference: https://stackoverflow.com/questions/26315925/get-usable-window-width-in-vim-script/26318602#26318602
    let width = winwidth(0)
    let numberwidth = max([&numberwidth, strlen(line('$')) + 1])
    let numwidth = (&number || &relativenumber) ? numberwidth : 0
    let foldwidth = &foldcolumn

    if &signcolumn == 'yes'
        let signwidth = 2
    elseif &signcolumn =~ 'yes'
        let signwidth = &signcolumn
        let signwidth = split(signwidth, ':')[1]
        let signwidth *= 2  " each signcolumn is 2-char wide
    elseif &signcolumn == 'auto'
        let supports_sign_groups = has('nvim-0.4.2') || has('patch-8.1.614')
        let signlist = execute(printf('sign place ' . (supports_sign_groups ? 'group=* ' : '') . 'buffer=%d', bufnr('')))
        let signlist = split(signlist, "\n")
        let signwidth = len(signlist) > 2 ? 2 : 0
    elseif &signcolumn =~ 'auto'
        let signwidth = 0
        if len(sign_getplaced(bufnr(),{'group':'*'})[0].signs)
            let signwidth = 0
            for l:sign in sign_getplaced(bufnr(),{'group':'*'})[0].signs
                let lnum = l:sign.lnum
                let signs = len(sign_getplaced(bufnr(),{'group':'*', 'lnum':lnum})[0].signs)
                let signwidth = (signs > signwidth ? signs : signwidth)
            endfor
        endif
        let signwidth *= 2   " each signcolumn is 2-char wide
    else
        let signwidth = 0
    endif

    return numwidth + foldwidth + signwidth
endfunc

" let screen_height = &lines - &cmdheight - 1 - ((tabpagenr('$') > 1) ? 1 : 0)
