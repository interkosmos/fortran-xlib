! events.f90
!
! Example that shows the capture of events.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: xlib
    implicit none
    integer              :: rc, screen
    integer(kind=c_long) :: black, white
    integer(kind=c_long) :: long(5)
    integer(kind=c_long) :: root, window
    integer(kind=c_long) :: wm_delete_window
    type(c_ptr)          :: display, gc
    type(x_event)        :: event
    type(x_gc_values)    :: values

    ! Create window.
    display = x_open_display(c_null_char)
    screen  = x_default_screen(display)
    root    = x_default_root_window(display)

    black = x_black_pixel(display, screen)
    white = x_white_pixel(display, screen)

    window = x_create_simple_window(display, root, 0, 0, 300, 200, 0, black, white)

    ! Set window title.
    call x_store_name(display, window, 'Fortran' // c_null_char)

    ! Create graphics context.
    gc = x_create_gc(display, window, int(0, kind=c_long), values)

    call x_set_background(display, gc, white)
    call x_set_foreground(display, gc, black)

    ! Show window.
    call x_select_input(display, window, ior(EXPOSURE_MASK, ior(STRUCTURE_NOTIFY_MASK, KEY_PRESS_MASK)))
    call x_map_window(display, window)

    wm_delete_window = x_intern_atom(display, 'WM_DELETE_WINDOW' // c_null_char, .false._c_bool)
    rc = x_set_wm_protocols(display, window, wm_delete_window, 1)

    ! Event loop.
    do
        print '(a)', 'waiting for event ...'
        call x_next_event(display, event)

        select case (event%type)
            case (expose)
                print *, 'Expose'
            case (configure_notify)
                print *, 'ConfigureNotify'
                print *, 'width:  ', event%x_configure%width
                print *, 'height: ', event%x_configure%height
            case (client_message)
                print *, 'ClientMessage'
                long = transfer(event%x_client_message%data, long)
                if (long(1) == wm_delete_window) exit
            case (key_press)
                print *, 'KeyPress'
        end select
    end do

    ! Clean up and close window.
    call x_free_gc(display, gc)
    call x_destroy_window(display, window)
    call x_close_display(display)
end program main
