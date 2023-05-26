! drawing.f90
!
! Example that shows how to draw on the window.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: xlib
    implicit none
    integer              :: rc, screen
    integer(kind=c_long) :: black, white
    integer(kind=c_long) :: colormap, root, window
    integer(kind=c_long) :: wm_delete_window
    type(c_ptr)          :: display, gc
    type(x_color)        :: gold, orchid, turquoise
    type(x_event)        :: event
    type(x_gc_values)    :: values
    type(x_point)        :: points(3)

    ! The coordinates of the polygon.
    points(1)%x = 200
    points(1)%y = 170
    points(2)%x = 270
    points(2)%y = 230
    points(3)%x = 190
    points(3)%y = 290

    ! Open display.
    display  = x_open_display(c_null_char)
    screen   = x_default_screen(display)
    root     = x_default_root_window(display)
    colormap = x_default_colormap(display, screen)

    ! Define colours.
    black = x_black_pixel(display, screen)
    white = x_white_pixel(display, screen)

    ! See https://en.wikipedia.org/wiki/X11_color_names for more colours.
    rc = x_alloc_named_color(display, colormap, 'Gold' // c_null_char, gold, gold)
    if (rc == 0) print *, 'XAllocNamedColor failed to allocate "Gold" colour.'

    rc = x_alloc_named_color(display, colormap, 'Orchid' // c_null_char, orchid, orchid)
    if (rc == 0) print *, 'XAllocNamedColor failed to allocate "Orchid" colour.'

    rc = x_alloc_named_color(display, colormap, 'Turquoise' // c_null_char, turquoise, turquoise)
    if (rc == 0) print *, 'XAllocNamedColor failed to allocate "Turquoise" colour.'

    ! Create window.
    window = x_create_simple_window(display, root, 0, 0, 400, 300, 0, black, white)
    call x_store_name(display, window, 'Fortran' // c_null_char)

    wm_delete_window = x_intern_atom(display, 'WM_DELETE_WINDOW' // c_null_char, .false._c_bool)
    rc = x_set_wm_protocols(display, window, wm_delete_window, 1)

    ! Create graphics context.
    gc = x_create_gc(display, window, int(0, kind=c_long), values)

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

    ! Clean up and close window.
    call x_free_colors(display, colormap, [ gold%pixel, orchid%pixel, turquoise%pixel ], 3, int(0, kind=c_long))
    call x_free_gc(display, gc)
    call x_destroy_window(display, window)
    call x_close_display(display)
contains
    subroutine draw()
        ! Set background and foreground colour.
        call x_set_background(display, gc, white)
        call x_set_foreground(display, gc, black)

        ! Set (optional) drawing styles.
        call x_set_line_attributes(display, gc, 2, LINE_SOLID, CAP_BUTT, JOIN_BEVEL)
        call x_set_fill_style(display, gc, FILL_SOLID)

        ! Draw lines.
        call x_draw_line(display, window, gc, 10, 10, 200, 30)
        call x_draw_line(display, window, gc, 50, 250, 200, 50)

        ! Draw rectangles.
        call x_draw_rectangle(display, window, gc, 10, 50, 100, 100)
        call x_set_foreground(display, gc, turquoise%pixel)
        call x_fill_rectangle(display, window, gc, 30, 70, 100, 100)

        ! Draw circles.
        call x_set_foreground(display, gc, black)
        call x_draw_arc(display, window, gc, 200, 50, 100, 100, 0, 360 * 64)
        call x_set_foreground(display, gc, gold%pixel)
        call x_fill_arc(display, window, gc, 220, 70, 100, 100, 0, 360 * 64)

        ! Draw polygons.
        call x_set_foreground(display, gc, orchid%pixel)
        call x_fill_polygon(display, window, gc, points, 3, COMPLEX, COORD_MODE_ORIGIN)
    end subroutine draw
end program main
