
command! -nargs=0 FocusSide         call focus_side#focusSide()
command! -nargs=0 FocusSideNoToggle call focus_side#focusSide({'toggle_enable': v:false})
command! -nargs=1 FocusSideOffset   call focus_side#focusSide({'toggle_offset': str2nr(<q-args>)})
