! window.f90
!
! Simple example application to create a window with Xlib.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding, only: c_null_char, c_bool, c_ptr
    use :: xlib
    implicit none
    integer, parameter :: WIDTH  = 640
    integer, parameter :: HEIGHT = 480

    type(c_ptr)        :: display
    type(c_ptr)        :: gc
    type(x_gc_values)  :: values
    type(x_size_hints) :: size_hints
    integer            :: screen
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

    window = x_create_simple_window(display, root, 0, 0, WIDTH, HEIGHT, 0, black, white)

    ! Prevent resizing.
    size_hints%flags      = ior(P_MIN_SIZE, P_MAX_SIZE)
    size_hints%min_width  = WIDTH
    size_hints%min_height = HEIGHT
    size_hints%max_width  = WIDTH
    size_hints%max_height = HEIGHT

    call x_set_wm_normal_hints(display, window, size_hints)

    ! Set window title.
    call x_store_name(display, window, 'Fortran' // c_null_char)

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
