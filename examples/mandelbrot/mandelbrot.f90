! mandelbrot.f90
!
! Example that shows the drawing of the Mandelbrot set.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding, only: C_NULL_CHAR, c_bool, c_ptr
    use :: xlib
    implicit none
    integer, parameter :: WIDTH  = 800
    integer, parameter :: HEIGHT = 600

    type(c_ptr)        :: display
    type(c_ptr)        :: gc
    type(x_event)      :: event
    type(x_gc_values)  :: values
    type(x_size_hints) :: size_hints
    type(x_color)      :: midnight_blue
    type(x_color)      :: indigo
    type(x_color)      :: purple
    integer            :: screen
    integer            :: rc
    integer(kind=8)    :: root
    integer(kind=8)    :: colormap
    integer(kind=8)    :: black
    integer(kind=8)    :: white
    integer(kind=8)    :: window
    integer(kind=8)    :: double_buffer
    integer(kind=8)    :: wm_delete_window
    integer(kind=8)    :: long(5)

    ! Open display.
    display  = x_open_display(C_NULL_CHAR)
    screen   = x_default_screen(display)
    root     = x_default_root_window(display)
    colormap = x_default_colormap(display, screen)

    ! Define colours.
    black = x_black_pixel(display, screen)
    white = x_white_pixel(display, screen)

    rc = x_alloc_named_color(display, colormap, 'MidnightBlue' // C_NULL_CHAR, midnight_blue, midnight_blue)
    rc = x_alloc_named_color(display, colormap, 'Indigo' // C_NULL_CHAR, indigo, indigo)
    rc = x_alloc_named_color(display, colormap, 'Purple' // C_NULL_CHAR, purple, purple)

    ! Create window.
    window = x_create_simple_window(display, root, 0, 0, WIDTH, HEIGHT, 0, white, black)
    call x_store_name(display, window, 'Fortran' // C_NULL_CHAR)

    wm_delete_window = x_intern_atom(display, 'WM_DELETE_WINDOW' // C_NULL_CHAR, .false._c_bool)
    rc = x_set_wm_protocols(display, window, wm_delete_window, 1)

    ! Prevent resizing.
    size_hints%flags      = ior(P_MIN_SIZE, P_MAX_SIZE)
    size_hints%min_width  = WIDTH
    size_hints%min_height = HEIGHT
    size_hints%max_width  = WIDTH
    size_hints%max_height = HEIGHT

    call x_set_wm_normal_hints(display, window, size_hints)

    ! Create graphics context.
    gc = x_create_gc(display, window, 0, values)

    ! Create double buffer.
    double_buffer = x_create_pixmap(display, window, WIDTH, HEIGHT, 24)

    call x_set_foreground(display, gc, black)
    call x_fill_rectangle(display, double_buffer, gc, 0, 0, WIDTH, HEIGHT)

    ! Render Mandelbrot set.
    call render()

    ! Show window.
    call x_select_input(display, window, ior(EXPOSURE_MASK, STRUCTURE_NOTIFY_MASK))
    call x_map_window(display, window)

    ! Event loop.
    do
        call x_next_event(display, event)

        select case (event%type)
            case (expose)
                ! Copies double buffer to window.
                call x_copy_area(display, double_buffer, window, gc, 0, 0, WIDTH, HEIGHT, 0, 0)
            case (client_message)
                long = transfer(event%x_client_message%data, long)

                if (long(1) == wm_delete_window) &
                    exit
        end select
    end do

    ! Clean up and close window.
    call x_free_colors(display, colormap, [ midnight_blue%pixel, indigo%pixel, purple%pixel ], 3, int(0, kind=8))
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

        do y = 0, HEIGHT
            im = -1.5 + real(y) * 3.0 / real(HEIGHT)

            do x = 0, WIDTH
                re = -2.0 + real(x) * 3.0 / real(WIDTH)
                n = mandelbrot(cmplx(re, im), max_iter, threshold)

                if (n < 15) cycle

                select case (n)
                    case (15:19)
                        call x_set_foreground(display, gc, purple%pixel)

                    case (20:29)
                        call x_set_foreground(display, gc, indigo%pixel)

                    case (30:max_iter - 1)
                        call x_set_foreground(display, gc, midnight_blue%pixel)

                    case (max_iter:)
                        call x_set_foreground(display, gc, black)
                end select

                call x_draw_point(display, double_buffer, gc, x, y)
            end do
        end do

        call cpu_time(t2)

        print '("time: ", f7.5, " s")', t2 - t1
    end subroutine render
end program main
