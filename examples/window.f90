! window.f90
!
! Simple example application to create a window with Xlib.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: xlib
    use :: xlib_consts
    use :: xlib_types
    implicit none
    type(c_ptr)        :: display
    type(c_ptr)        :: gc
    type(x_gc_values)  :: values
    type(x_size_hints) :: size_hints
    integer            :: screen
    integer            :: width  = 640
    integer            :: height = 480
    integer(kind=8)    :: root
    integer(kind=8)    :: window
    integer(kind=8)    :: black
    integer(kind=8)    :: white

    ! Create window.
    display = x_open_display(c_null_char)
    screen  = x_default_screen(display)
    root    = x_default_root_window(display)

    black = x_black_pixel(display, screen)
    white = x_white_pixel(display, screen)

    window = x_create_simple_window(display, root, 0, 0, width, height, 5, black, white)

    ! Prevent resizing.
    size_hints%flags      = ior(p_min_size, p_max_size)
    size_hints%min_width  = width
    size_hints%min_height = height
    size_hints%max_width  = width
    size_hints%max_height = height

    call x_set_wm_normal_hints(display, window, size_hints)

    ! Set window title.
    call x_store_name(display, window, c_char_'Fortran' // c_null_char)

    ! Create graphics context.
    gc = x_create_gc(display, window, 0, values)

    call x_set_background(display, gc, white)
    call x_set_foreground(display, gc, black)

    ! Show window.
    call x_map_window(display, window)
    call x_clear_window(display, window)
    call x_sync(display, .false._c_bool)

    call sleep(5)

    ! Clean up and close window.
    call x_free_gc(display, gc)
    call x_destroy_window(display, window)
    call x_close_display(display)
end program main
