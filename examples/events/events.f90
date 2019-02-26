! events.f90
!
! Example that shows the capture of events.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding, only: C_NULL_CHAR, c_bool, c_ptr
    use :: xlib
    implicit none
    type(c_ptr)       :: display
    type(c_ptr)       :: gc
    type(x_event)     :: event
    type(x_gc_values) :: values
    integer           :: rc
    integer           :: screen
    integer(kind=8)   :: root
    integer(kind=8)   :: window
    integer(kind=8)   :: black
    integer(kind=8)   :: white
    integer(kind=8)   :: wm_delete_window
    integer(kind=8)   :: l(5)

    ! Create window.
    display = x_open_display(C_NULL_CHAR)
    screen  = x_default_screen(display)
    root    = x_default_root_window(display)

    black = x_black_pixel(display, screen)
    white = x_white_pixel(display, screen)

    window = x_create_simple_window(display, root, 0, 0, 300, 200, 0, black, white)

    ! Set window title.
    call x_store_name(display, window, 'Fortran' // C_NULL_CHAR)

    ! Create graphics context.
    gc = x_create_gc(display, window, 0, values)

    call x_set_background(display, gc, white)
    call x_set_foreground(display, gc, black)

    ! Show window.
    call x_select_input(display, window, ior(EXPOSURE_MASK, ior(STRUCTURE_NOTIFY_MASK, KEY_PRESS_MASK)))
    call x_map_window(display, window)

    wm_delete_window = x_intern_atom(display, 'WM_DELETE_WINDOW' // C_NULL_CHAR, .false._c_bool)
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
                l = transfer(event%x_client_message%data, l)

                if (l(1) == wm_delete_window) &
                    exit
            case (key_press)
                print *, 'KeyPress'
        end select
    end do

    ! Clean up and close window.
    call x_free_gc(display, gc)
    call x_destroy_window(display, window)
    call x_close_display(display)
end program main
