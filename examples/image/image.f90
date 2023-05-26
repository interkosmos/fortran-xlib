! image.f90
!
! Example that shows how to load an XPM image into a pixmap and draw it
! on the window.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding, only: c_null_char, c_bool, c_null_ptr, c_ptr
    use :: xlib
    use :: xpm
    implicit none
    integer,          parameter :: WIDTH     = 320
    integer,          parameter :: HEIGHT    = 240
    character(len=*), parameter :: FILE_NAME = 'examples/image/bsd_daemon.xpm'

    integer              :: rc, screen
    integer(kind=c_long) :: black, white
    integer(kind=c_long) :: colormap, pixmap, shape_mask
    integer(kind=c_long) :: root, window
    integer(kind=c_long) :: wm_delete_window
    type(c_ptr)          :: display, gc
    type(x_event)        :: event
    type(x_gc_values)    :: values

    ! Open display.
    display  = x_open_display(c_null_char)
    screen   = x_default_screen(display)
    root     = x_default_root_window(display)
    colormap = x_default_colormap(display, screen)

    pixmap     = 0
    shape_mask = 0

    ! Define colours.
    black = x_black_pixel(display, screen)
    white = x_white_pixel(display, screen)

    ! Create window.
    window = x_create_simple_window(display, root, 0, 0, WIDTH, HEIGHT, 0, black, white)
    call x_store_name(display, window, 'Fortran' // c_null_char)

    wm_delete_window = x_intern_atom(display, 'WM_DELETE_WINDOW' // c_null_char, .false._c_bool)
    rc = x_set_wm_protocols(display, window, wm_delete_window, 1)

    ! Create graphics context.
    gc = x_create_gc(display, window, int(0, kind=c_long), values)

    ! Read XPM image from file.
    rc = xpm_read_file_to_pixmap(display, window, FILE_NAME // c_null_char, pixmap, shape_mask, c_null_ptr)

    if (rc < 0) &
        call quit() ! Fatal error.

    ! Show window.
    call x_select_input(display, window, ior(EXPOSURE_MASK, STRUCTURE_NOTIFY_MASK))
    call x_map_window(display, window)

    ! Event loop.
    do
        call x_next_event(display, event)

        select case (event%type)
            case (expose)
                call draw()
            case (client_message)
                exit
        end select
    end do

    ! Quit gracefully.
    call quit()
contains
    subroutine quit()
        !! Cleans up and closes window.
        if (pixmap > 0) &
            call x_free_pixmap(display, pixmap)

        if (shape_mask > 0) &
            call x_free_pixmap(display, shape_mask)

        call x_free_gc(display, gc)
        call x_destroy_window(display, window)
        call x_close_display(display)

        stop
    end subroutine quit

    subroutine draw()
        !! Draws pixmap on the window.
        integer, parameter :: x = 50
        integer, parameter :: y = 50

        call x_clear_window(display, window)

        ! Set clipping mask for transparent pixels.
        call x_set_clip_origin(display, gc, x, y)
        call x_set_clip_mask(display, gc, shape_mask)

        ! Copy pixmap to window.
        call x_copy_area(display, pixmap, window, gc, 0, 0, 64, 64, x, y)
    end subroutine draw
end program main
