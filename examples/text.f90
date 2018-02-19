! text.f90
!
! Example for text output.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: xlib
    use :: xlib_consts
    use :: xlib_types
    implicit none
    type(c_ptr)                   :: display
    type(c_ptr)                   :: gc
    type(x_color),   dimension(5) :: colors
    type(x_event)                 :: event
    type(x_gc_values)             :: values
    type(x_size_hints)            :: size_hints
    integer                       :: screen
    integer                       :: rc
    integer                       :: width             = 320
    integer                       :: height            = 200
    integer                       :: i
    integer(kind=8)               :: root
    integer(kind=8)               :: colormap
    integer(kind=8)               :: black
    integer(kind=8)               :: white
    integer(kind=8)               :: window
    integer(kind=8)               :: wm_delete_window
    type(x_font_struct)           :: font
    integer(kind=8), dimension(5) :: long
    integer(kind=8), dimension(5) :: pixels

    ! Open display.
    display  = x_open_display(c_null_char)
    screen   = x_default_screen(display)
    root     = x_default_root_window(display)
    colormap = x_default_colormap(display, screen)

    ! Define colours.
    black = x_black_pixel(display, screen)
    white = x_white_pixel(display, screen)

    rc = x_alloc_named_color(display, colormap, 'HotPink' // c_null_char, colors(1), colors(1))
    rc = x_alloc_named_color(display, colormap, 'Lime' // c_null_char, colors(2), colors(2))
    rc = x_alloc_named_color(display, colormap, 'Orange' // c_null_char, colors(3), colors(3))
    rc = x_alloc_named_color(display, colormap, 'Turquoise' // c_null_char, colors(4), colors(4))
    rc = x_alloc_named_color(display, colormap, 'SpringGreen' // c_null_char, colors(5), colors(5))

    do i = 1, size(colors)
        pixels(i) = colors(i)%pixel
    end do

    ! Create window.
    window = x_create_simple_window(display, root, 0, 0, width, height, 0, white, black)
    call x_store_name(display, window, 'Fortran' // c_null_char)

    wm_delete_window = x_intern_atom(display, 'WM_DELETE_WINDOW' // c_null_char, .false._c_bool)
    rc = x_set_wm_protocols(display, window, wm_delete_window, 1)

    ! Prevent resizing.
    size_hints%flags      = ior(p_min_size, p_max_size)
    size_hints%min_width  = width
    size_hints%min_height = height
    size_hints%max_width  = width
    size_hints%max_height = height

    call x_set_wm_normal_hints(display, window, size_hints)

    ! Create graphics context.
    gc = x_create_gc(display, window, 0, values)

    ! Load and set font.
    font = x_load_query_font(display, 'fixed' // c_null_char)
    call x_set_font(display, gc, font%fid)

    ! Show window.
    call x_select_input(display, window, ior(exposure_mask, structure_notify_mask));
    call x_map_window(display, window)

    ! Event loop.
    do
        call x_next_event(display, event)

        select case (event%type)
            case (expose)
                call draw()
            case (client_message)
                long = transfer(event%x_client_message%data, long)

                if (long(1) == wm_delete_window) &
                    exit
        end select
    end do

    ! Clean up and close window.
    call x_free_font(display, font)
    call x_free_colors(display, colormap, pixels, size(pixels), int8(0))
    call x_free_gc(display, gc)
    call x_destroy_window(display, window)
    call x_close_display(display)

    contains
        subroutine draw()
            use :: xlib_types
            implicit none
            character(len=*), parameter :: text  = 'FORTRAN FOREVER!'
            integer                     :: x, y
            integer                     :: direction
            integer                     :: ascent, descent
            integer                     :: i
            type(x_char_struct)         :: overall

            call x_text_extents(font, text, len(text), direction, ascent, descent, overall)

            do i = 1, size(pixels)
                call x_set_foreground(display, gc, pixels(i))
                call x_draw_string(display, window, gc, 25, 10 + (i * 15), text, len(text))
            end do

            do i = size(pixels), 1, -1
                call x_set_foreground(display, gc, pixels(i))
                call x_draw_string(display, window, gc, 125, 100 - (i * 15), text, len(text))
            end do
        end subroutine draw
end program main
