
command! -nargs=0 FS         call focus_side#focusSide()
command! -nargs=0 FSNoToggle call focus_side#focusSide({'toggle_enable': v:false})
command! -nargs=1 FSOffset   call focus_side#focusSide({'toggle_offset': str2nr(<q-args>)})
