! starfield.f90
!
! Simple starfield demo for X11.
!
! Author:  Philipp Engel
! Licence: ISC
module starfield
    implicit none
    integer, parameter :: NUM_STARS = 64
    integer, parameter :: MAX_DEPTH = 512

    type :: point3d
        real :: x, y, z
    end type point3d

    type(point3d) :: stars(NUM_STARS)

    public :: init
    public :: move
contains
    subroutine init()
        integer :: i
        real    :: r(3)

        do i = 1, size(stars)
            call random_number(r)

            stars(i)%x = 100.0 - (r(1) * 200.0)
            stars(i)%y = 100.0 - (r(2) * 200.0)
            stars(i)%z = r(3) * MAX_DEPTH
        end do
    end subroutine init

    subroutine move()
        integer :: i
        real    :: r(2)

        do i = 1, size(stars)
            stars(i)%z = stars(i)%z - 0.15

            if (stars(i)%z < 0.0) then
                call random_number(r)

                stars(i)%x = 100.0 - (r(1) * 200.0)
                stars(i)%y = 100.0 - (r(2) * 200.0)
                stars(i)%z = MAX_DEPTH
            end if
        end do
    end subroutine move
end module starfield

program main
    use, intrinsic :: iso_c_binding
    use :: xlib
    use :: starfield
    implicit none

    interface
        subroutine c_usleep(useconds) bind(c, name='usleep')
            !! Interface to usleep in libc.
            import :: c_int32_t
            implicit none
            integer(c_int32_t), value :: useconds
        end subroutine c_usleep
    end interface

    integer, parameter :: WIDTH  = 640
    integer, parameter :: HEIGHT = 480

    integer              :: rc, screen
    integer(kind=c_long) :: black, white
    integer(kind=c_long) :: colormap, double_buffer
    integer(kind=c_long) :: long(5)
    integer(kind=c_long) :: root, window, wm_delete_window
    type(c_ptr)          :: display, gc
    type(x_event)        :: event
    type(x_gc_values)    :: values
    type(x_size_hints)   :: size_hints

    ! Open display.
    display  = x_open_display(c_null_char)
    screen   = x_default_screen(display)
    root     = x_default_root_window(display)
    colormap = x_default_colormap(display, screen)

    ! Define colours.
    black = x_black_pixel(display, screen)
    white = x_white_pixel(display, screen)

    ! Create window.
    window = x_create_simple_window(display, root, 0, 0, WIDTH, HEIGHT, 0, white, black)
    call x_store_name(display, window, 'Fortran' // c_null_char)

    wm_delete_window = x_intern_atom(display, 'WM_DELETE_WINDOW' // c_null_char, .false._c_bool)
    rc = x_set_wm_protocols(display, window, wm_delete_window, 1)

    ! Prevent resizing.
    size_hints%flags      = ior(P_MIN_SIZE, P_MAX_SIZE)
    size_hints%min_width  = WIDTH
    size_hints%min_height = HEIGHT
    size_hints%max_width  = WIDTH
    size_hints%max_height = HEIGHT

    call x_set_wm_normal_hints(display, window, size_hints)

    ! Create graphics context.
    gc = x_create_gc(display, window, int(0, kind=c_long), values)

    ! Create double buffer.
    double_buffer = x_create_pixmap(display, window, WIDTH, HEIGHT, 24)

    call x_set_background(display, gc, black)
    call x_set_foreground(display, gc, white)
    call x_fill_rectangle(display, double_buffer, gc, 0, 0, WIDTH, HEIGHT)

    ! Show window.
    call x_select_input(display, window, ior(EXPOSURE_MASK, STRUCTURE_NOTIFY_MASK))
    call x_map_window(display, window)

    ! Init the starfield.
    call init()

    do
        rc = x_pending(display)

        if (rc > 0) then
            call x_next_event(display, event)
        else
            select case(event%type)
                case(client_message)
                    long = transfer(event%x_client_message%data, long)
                    if (long(1) == wm_delete_window) exit
            end select

            call move()
            call render()
            call draw()
            call c_usleep(1000)
        end if
    end do

    ! Clean up and close window.
    call x_free_pixmap(display, double_buffer)
    call x_free_gc(display, gc)
    call x_destroy_window(display, window)
    call x_close_display(display)
contains
    subroutine render()
        !! Renders the stars.
        integer :: origin_x, origin_y
        integer :: i, x, y
        real    :: k

        origin_x = WIDTH / 2
        origin_y = HEIGHT / 2

        call x_set_foreground(display, gc, black)
        call x_fill_rectangle(display, double_buffer, gc, 0, 0, WIDTH, HEIGHT)

        call x_set_foreground(display, gc, white)

        do i = 1, size(stars)
            k = 128.0 / stars(i)%z
            x = int(stars(i)%x * k + origin_x)
            y = int(stars(i)%y * k + origin_y)

            call x_draw_point(display, double_buffer, gc, x, y)
        end do
    end subroutine render

    subroutine draw()
        !! Copies double buffer to window.
        call x_copy_area(display, double_buffer, window, gc, 0, 0, WIDTH, HEIGHT, 0, 0)
    end subroutine draw
end program main
