! events.f90
!
! Example that shows the capture of events.
!
! Author:  Philipp Engel
! Date:    2018-FEB-03
! Licence: ISC
!
! Build with:
! $ gfortran8 -o events -Wl,-rpath=/usr/local/lib/gcc8/ -I/usr/local/include/ -L/usr/local/lib/ -lX11 events.f90 xlib.o
program main
    use, intrinsic :: iso_c_binding
    use xlib
    use xlib_consts
    use xlib_types
    implicit none
    type(c_ptr)       :: display
    type(c_ptr)       :: gc
    type(x_event)     :: event
    type(x_gc_values) :: values
    integer           :: screen
    integer           :: status
    integer(kind=8)   :: root
    integer(kind=8)   :: window
    integer(kind=8)   :: black
    integer(kind=8)   :: white
    integer(kind=8)   :: wm_delete_window

    ! Create window.
    display = x_open_display(c_null_char)
    screen  = x_default_screen(display)
    root    = x_default_root_window(display)

    black = x_black_pixel(display, screen)
    white = x_white_pixel(display, screen)

    window = x_create_simple_window(display, root, 0, 0, 300, 200, 5, black, white)

    ! Set window title.
    call x_store_name(display, window, c_char_'Fortran' // c_null_char)

    ! Create graphics context.
    gc = x_create_gc(display, window, 0, values)

    call x_set_background(display, gc, white)
    call x_set_foreground(display, gc, black)

    ! Show window.
    call x_select_input(display, window, ior(exposure_mask, ior(structure_notify_mask, key_press_mask)));
    call x_map_window(display, window)

    wm_delete_window = x_intern_atom(display, 'WM_DELETE_WINDOW', .false._c_bool)
    status           = x_set_wm_protocols(display, window, wm_delete_window, 1)

    ! Event loop.
    do
        write(*, '(a)') 'waiting for event ...'
        call x_next_event(display, event)

        select case(event%type)
            case(expose)
                write(*, *) 'Expose'
            case(configure_notify)
                write(*, *) 'ConfigureNotify'
                write(*, *) 'width:  ', event%xconfigure%width
                write(*, *) 'height: ', event%xconfigure%height
            case(client_message)
                write(*, *) 'ClientMessage'
            case(key_press)
                write(*, *) 'KeyPress'
        end select
    end do

    ! Clean up and close window.
    call x_free_gc(display, gc)
    call x_destroy_window(display, window)
    call x_close_display(display)
end program main
