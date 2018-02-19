! starfield.f90
!
! Simple starfield demo for X11.
!
! Author:  Philipp Engel
! Licence: ISC
module starfield
    implicit none
    integer, parameter :: num_stars = 64
    integer, parameter :: max_depth = 512

    type :: point3d
        real :: x, y, z
    end type point3d

    type(point3d), dimension(num_stars) :: stars

    public :: init
    public :: move

    contains
        subroutine init()
            implicit none
            integer :: i
            integer :: x, y, z
            real    :: r1, r2, r3

            do i = 1, size(stars)
                call random_number(r1)
                call random_number(r2)
                call random_number(r3)

                stars(i)%x = 100.0 - (r1 * 200.0)
                stars(i)%y = 100.0 - (r2 * 200.0)
                stars(i)%z = r3 * max_depth
            end do
        end subroutine init

        subroutine move()
            implicit none
            integer :: i
            real    :: r1, r2

            do i = 1, size(stars)
                stars(i)%z = stars(i)%z - 0.15

                if (stars(i)%z < 0.0) then
                    call random_number(r1)
                    call random_number(r2)

                    stars(i)%x = 100.0 - (r1 * 200.0)
                    stars(i)%y = 100.0 - (r2 * 200.0)
                    stars(i)%z = max_depth
                end if
            end do
        end subroutine move
end module starfield

program main
    use, intrinsic :: iso_c_binding
    use :: xlib
    use :: xlib_consts
    use :: xlib_types
    use :: starfield
    implicit none
    type(c_ptr)                   :: display
    type(c_ptr)                   :: gc
    type(x_event)                 :: event
    type(x_gc_values)             :: values
    type(x_size_hints)            :: size_hints
    integer                       :: screen
    integer                       :: rc
    integer                       :: width  = 640
    integer                       :: height = 480
    integer(kind=8)               :: root
    integer(kind=8)               :: colormap
    integer(kind=8)               :: black
    integer(kind=8)               :: white
    integer(kind=8)               :: window
    integer(kind=8)               :: double_buffer
    integer(kind=8)               :: wm_delete_window
    integer(kind=8), dimension(5) :: long

    interface
        subroutine usleep(useconds) bind(c)
            !! Interface to usleep in libc.
            use iso_c_binding
            implicit none
            integer(c_int32_t), value :: useconds
        end subroutine
    end interface

    ! Open display.
    display  = x_open_display(c_null_char)
    screen   = x_default_screen(display)
    root     = x_default_root_window(display)
    colormap = x_default_colormap(display, screen)

    ! Define colours.
    black = x_black_pixel(display, screen)
    white = x_white_pixel(display, screen)

    ! Create window.
    window = x_create_simple_window(display, root, 0, 0, width, height, 5, white, black)
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

    call x_set_background(display, gc, black)
    call x_set_foreground(display, gc, white)

    call x_fill_rectangle(display, double_buffer, gc, 0, 0, width, height)

    ! Show window.
    call x_select_input(display, window, ior(exposure_mask, structure_notify_mask));
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

                    if (long(1) == wm_delete_window) &
                        exit
            end select

            call move()
            call render()
            call draw()
            call microsleep(1000)
        end if
    end do

    ! Clean up and close window.
    call x_free_pixmap(display, double_buffer)
    call x_free_gc(display, gc)
    call x_destroy_window(display, window)
    call x_close_display(display)

    contains
        subroutine microsleep(t)
            !! Wrapper for usleep.
            implicit none
            integer, intent(in) :: t

            call usleep(int(t, c_int32_t))
        end subroutine microsleep

        subroutine render()
            implicit none
            integer :: origin_x
            integer :: origin_y
            integer :: i
            integer :: x, y
            real    :: k

            origin_x = width / 2
            origin_y = height / 2

            call x_set_foreground(display, gc, black)
            call x_fill_rectangle(display, double_buffer, gc, 0, 0, width, height)

            call x_set_foreground(display, gc, white)

            do i = 1, size(stars)
                k = 128.0 / stars(i)%z
                x = int(stars(i)%x * k + origin_x)
                y = int(stars(i)%y * k + origin_y)

                call x_draw_point(display, double_buffer, gc, x, y)
            end do
        end subroutine render

        subroutine draw()
            call x_copy_area(display, double_buffer, window, gc, 0, 0, width, height, 0, 0)
        end subroutine draw
end program main
