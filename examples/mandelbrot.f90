! mandelbrot.f90
!
! Example that shows the drawing of the Mandelbrot set.
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
    type(x_event)                 :: event
    type(x_gc_values)             :: values
    type(x_size_hints)            :: size_hints
    type(x_color)                 :: midnight_blue
    type(x_color)                 :: indigo
    type(x_color)                 :: purple
    integer                       :: screen
    integer                       :: rc
    integer                       :: width             = 800
    integer                       :: height            = 600
    integer(kind=8)               :: root
    integer(kind=8)               :: colormap
    integer(kind=8)               :: black
    integer(kind=8)               :: white
    integer(kind=8)               :: window
    integer(kind=8)               :: double_buffer
    integer(kind=8)               :: wm_delete_window
    integer(kind=8), dimension(5) :: long

    ! Open display.
    display  = x_open_display(c_null_char)
    screen   = x_default_screen(display)
    root     = x_default_root_window(display)
    colormap = x_default_colormap(display, screen)

    ! Define colours.
    black = x_black_pixel(display, screen)
    white = x_white_pixel(display, screen)

    rc = x_alloc_named_color(display, colormap, 'MidnightBlue' // c_null_char, midnight_blue, midnight_blue)
    rc = x_alloc_named_color(display, colormap, 'Indigo' // c_null_char, indigo, indigo)
    rc = x_alloc_named_color(display, colormap, 'Purple' // c_null_char, purple, purple)

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

    ! Create double buffer.
    double_buffer = x_create_pixmap(display, window, width, height, 24)

    call x_set_foreground(display, gc, black)
    call x_fill_rectangle(display, double_buffer, gc, 0, 0, width, height)

    ! Render Mandelbrot set.
    call render()

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
    call x_free_colors(display, colormap, (/ midnight_blue%pixel, indigo%pixel, purple%pixel /), 3, int8(0))
    call x_free_pixmap(display, double_buffer)
    call x_free_gc(display, gc)
    call x_destroy_window(display, window)
    call x_close_display(display)

    contains
        integer function mandelbrot(c, max_iter, threshold)
            !! Calculates Mandelbrot set.
            complex, intent(in) :: c
            integer, intent(in) :: max_iter
            real,    intent(in) :: threshold
            complex             :: z

            z = (0.0, 0.0)

            do mandelbrot = 0, max_iter
                z = z**2 + c

                if (abs(z) > threshold) &
                    exit
            end do
        end function mandelbrot

        subroutine render()
            !! Renders Mandelbrot set.
            integer, parameter :: max_iter  = 50
            real,    parameter :: threshold = 2.0
            integer            :: n
            integer            :: x, y
            real               :: re, im
            real               :: t1, t2

            call cpu_time(t1)

            do y = 0, height
                im = -1.5 + real(y) * 3.0 / real(height)

                do x = 0, width
                    re = -2.0 + real(x) * 3.0 / real(width)
                    n = mandelbrot(cmplx(re, im), max_iter, threshold)

                    if (n >= 15) then
                        if (n >= 15 .and. n < 20) &
                            call x_set_foreground(display, gc, purple%pixel)

                        if (n >= 20 .and. n < 30) &
                            call x_set_foreground(display, gc, indigo%pixel)

                        if (n >= 30 .and. n < max_iter) &
                            call x_set_foreground(display, gc, midnight_blue%pixel)

                        if (n >= max_iter) &
                            call x_set_foreground(display, gc, black)

                        call x_draw_point(display, double_buffer, gc, x, y)
                    end if
                end do
            end do

            call cpu_time(t2)

            write(*, '(a f7.5 a)') 'rendering time: ', t2 - t1, ' s'
        end subroutine render

        subroutine draw()
            !! Copies double buffer to window.
            call x_copy_area(display, double_buffer, window, gc, 0, 0, width, height, 0, 0)
        end subroutine draw
end program main
