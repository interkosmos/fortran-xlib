! drawing.f90
!
! Example that shows how to draw on the canvas.
!
! Author:  Philipp Engel
! Date:    2018-FEB-11
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: xlib
    use :: xlib_consts
    use :: xlib_types
    implicit none
    type(c_ptr)       :: display
    type(c_ptr)       :: gc
    type(x_color)     :: red
    type(x_event)     :: event
    type(x_gc_values) :: values
    integer           :: screen
    integer           :: rc
    integer(kind=8)   :: root
    integer(kind=8)   :: window
    integer(kind=8)   :: black
    integer(kind=8)   :: white
    integer(kind=8)   :: wm_delete_window
    integer(kind=8)   :: screen_colormap

    ! Create window.
    display = x_open_display(c_null_char)
    screen  = x_default_screen(display)
    root    = x_default_root_window(display)

    black = x_black_pixel(display, screen)
    white = x_white_pixel(display, screen)

    window = x_create_simple_window(display, root, 0, 0, 400, 300, 5, black, white)

    ! Set window title.
    call x_store_name(display, window, c_char_'Fortran' // c_null_char)

    ! Create graphics context.
    gc = x_create_gc(display, window, 0, values)

    call x_set_background(display, gc, white)
    call x_set_foreground(display, gc, black)

    ! Set drawing styles.
    call x_set_line_attributes(display, gc, 2, line_solid, cap_butt, join_bevel);
    call x_set_fill_style(display, gc, fill_solid)

    ! Define colours.
    screen_colormap = x_default_colormap(display, screen)
    rc = x_alloc_named_color(display, screen_colormap, "red", red, red)

    ! Show window.
    call x_select_input(display, window, ior(exposure_mask, structure_notify_mask));
    call x_map_window(display, window)

    ! Event loop.
    do
        call x_next_event(display, event)

        select case(event%type)
            case(expose)
                call draw(display, window, gc)
        end select
    end do

    ! Clean up and close window.
    call x_free_gc(display, gc)
    call x_destroy_window(display, window)
    call x_close_display(display)

    contains
        subroutine draw(display, window, gc)
            use :: xlib
            implicit none
            type(c_ptr),          intent(in) :: display
            integer(kind=c_long), intent(in) :: window
            type(c_ptr),          intent(in) :: gc

            call x_set_foreground(display, gc, black)
            call x_draw_line(display, window, gc, 10, 10, 200, 20)
            call x_draw_rectangle(display, window, gc, 10, 50, 100, 100)

            call x_set_foreground(display, gc, red%pixel)
            call x_fill_rectangle(display, window, gc, 30, 80, 100, 100)
        end subroutine draw
end program main
