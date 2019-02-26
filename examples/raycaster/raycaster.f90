! raycaster.f90
!
! Simple ray-casting engine for X11. Algorithm is taken from:
!     http://lodev.org/cgtutor/raycasting.html
! Use vi keys (h, j, k, l) for control.
!
! Author:  Philipp Engel
! Licence: ISC
module raycasting
    implicit none

    type :: point2d
        real :: x, y
    end type point2d

    integer, parameter :: map_width  = 12
    integer, parameter :: map_height = 12

    integer, dimension(map_width, map_height) :: map = reshape( &
        [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, &
          1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, &
          1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, &
          1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1, &
          1, 3, 3, 0, 0, 0, 0, 2, 0, 0, 3, 1, &
          1, 3, 3, 0, 0, 0, 0, 2, 0, 0, 3, 1, &
          1, 3, 3, 0, 0, 0, 0, 2, 0, 0, 3, 1, &
          1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1, &
          1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, &
          1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, &
          1, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 1, &
          1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1 ], &
        [ map_height, map_width ] )

    type(point2d) :: pos
    type(point2d) :: dir
    type(point2d) :: plane

    public :: init
    public :: cast_ray
contains
    subroutine init()
        implicit none

        pos%x  =  10.0; pos%y   = 2.0
        dir%x  =  -1.0; dir%y   = 0.0
        plane%x =  0.0; plane%y = 0.66
    end subroutine init

    subroutine cast_ray(width, height, x, y1, y2, wall, side)
        integer, intent(in)  :: width
        integer, intent(in)  :: height
        integer, intent(in)  :: x
        integer, intent(out) :: y1
        integer, intent(out) :: y2
        integer, intent(out) :: wall
        integer, intent(out) :: side
        integer              :: line_length
        integer              :: map_x, map_y
        integer              :: step_x, step_y
        real                 :: dist
        type(point2d)        :: camera
        type(point2d)        :: delta_dist
        type(point2d)        :: ray_dir
        type(point2d)        :: side_dist

        camera%x  = 2 * x / real(width) - 1
        ray_dir%x = dir%x + plane%x * camera%x
        ray_dir%y = dir%y + plane%y * camera%x

        map_x = int(pos%x)
        map_y = int(pos%y)

        delta_dist%x = abs(1 / ray_dir%x)
        delta_dist%y = abs(1 / ray_dir%y)

        if (ray_dir%x < 0) then
            step_x = -1
            side_dist%x = (pos%x - map_x) * delta_dist%x
        else
            step_x = 1
            side_dist%x = (map_x + 1.0 - pos%x) * delta_dist%x
        end if

        if (ray_dir%y < 0) then
            step_y = -1
            side_dist%y = (pos%y - map_y) * delta_dist%y
        else
            step_y = 1
            side_dist%y = (map_y + 1.0 - pos%y) * delta_dist%y
        end if

        do
            if (side_dist%x < side_dist%y) then
                side_dist%x = side_dist%x + delta_dist%x
                map_x       = map_x + step_x
                side        = 0
            else
                side_dist%y = side_dist%y + delta_dist%y
                map_y       = map_y + step_y
                side        = 1
            end if

            if (map(map_y + 1, map_x + 1) > 0) then
                wall = map(map_y + 1, map_x + 1)
                exit
            end if
        end do

        if (side == 0) then
            dist = (map_x - pos%x + (1 - step_x) / 2) / ray_dir%x
        else
            dist = (map_y - pos%y + (1 - step_y) / 2) / ray_dir%y
        end if

        line_length = int(height / dist)

        y1 = -line_length / 2 + height / 2

        if (y1 < 0) &
            y1 = 0

        y2 = line_length / 2 + height / 2

        if (y2 >= height) &
            y2 = height - 1
    end subroutine cast_ray
end module raycasting

program main
    use, intrinsic :: iso_c_binding, only: C_NULL_CHAR, c_bool, c_null_ptr, c_ptr
    use :: xlib
    use :: xpm
    use :: raycasting
    implicit none
    integer, parameter :: WIDTH  = 640
    integer, parameter :: HEIGHT = 450

    logical            :: done = .false.
    integer            :: rc
    integer            :: screen
    integer(kind=8)    :: root
    integer(kind=8)    :: window
    integer(kind=8)    :: double_buffer
    integer(kind=8)    :: wm_delete_window
    integer(kind=8)    :: colormap
    integer(kind=8)    :: black
    integer(kind=8)    :: white
    integer(kind=8)    :: long(5)
    integer(kind=8)    :: pixels(7)
    type(x_color)      :: palette(7)
    type(x_event)      :: event
    type(x_gc_values)  :: values
    type(x_size_hints) :: size_hints
    type(c_ptr)        :: display
    type(c_ptr)        :: gc
    real               :: time
    real               :: old_time
    real               :: min_time = 0.05

    interface
        subroutine usleep(useconds) bind(c)
            !! Interface to usleep in libc.
            use, intrinsic :: iso_c_binding, only: c_int32_t
            implicit none
            integer(c_int32_t), value :: useconds
        end subroutine
    end interface

    ! Open display.
    display  = x_open_display(C_NULL_CHAR)
    screen   = x_default_screen(display)
    root     = x_default_root_window(display)
    colormap = x_default_colormap(display, screen)

    ! Define colours.
    black = x_black_pixel(display, screen)
    white = x_white_pixel(display, screen)

    call alloc_colors()

    ! Create window.
    window = x_create_simple_window(display, root, 0, 0, WIDTH, HEIGHT, 0, white, black)
    call x_store_name(display, window, 'Fortran 3D' // C_NULL_CHAR)

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

    ! Show window.
    call x_select_input(display, window, ior(EXPOSURE_MASK, KEY_PRESS_MASK))
    call x_map_window(display, window)

    call init()

    ! Event loop.
    do while (.not. done)
        rc = x_pending(display)

        if (rc > 0) then
            call x_next_event(display, event)

            select case (event%type)
                case (client_message)
                    long = transfer(event%x_client_message%data, long)

                    if (long(1) == wm_delete_window) &
                        done = .true.
                case (expose)
                    ! call draw()
                case (key_press)
                    call key_down(event%x_key%keycode)
            end select
        else
            call render()
            call draw()
            call tick()
        end if
    end do

    call quit()
contains
    integer function wall_color(wall, side)
        !! Returns the wall's color index.
        implicit none
        integer, intent(in) :: wall
        integer, intent(in) :: side

        wall_color = 1 + (wall * 2)

        if (side == 1) &
            wall_color = wall_color - 1
    end function wall_color

    subroutine micro_sleep(t)
        !! Wrapper for usleep.
        implicit none
        integer, intent(in) :: t

        call usleep(int(t, c_int32_t))
    end subroutine micro_sleep

    subroutine quit()
        !! Clean up and close window.
        call x_free_colors(display, colormap, pixels, size(pixels), int(0, kind=8))
        call x_free_pixmap(display, double_buffer)
        call x_free_gc(display, gc)
        call x_destroy_window(display, window)
        call x_close_display(display)

        call exit(0)
    end subroutine quit

    subroutine alloc_colors()
        !! Allocates the colours.
        implicit none
        integer :: rc, i

        rc = x_alloc_named_color(display, colormap, 'DimGray'      // C_NULL_CHAR, palette(1), palette(1))
        rc = x_alloc_named_color(display, colormap, 'FireBrick'    // C_NULL_CHAR, palette(2), palette(2))
        rc = x_alloc_named_color(display, colormap, 'DarkRed'      // C_NULL_CHAR, palette(3), palette(4))
        rc = x_alloc_named_color(display, colormap, 'DarkBlue'     // C_NULL_CHAR, palette(4), palette(4))
        rc = x_alloc_named_color(display, colormap, 'MidnightBlue' // C_NULL_CHAR, palette(5), palette(5))
        rc = x_alloc_named_color(display, colormap, 'ForestGreen'  // C_NULL_CHAR, palette(6), palette(6))
        rc = x_alloc_named_color(display, colormap, 'DarkGreen'    // C_NULL_CHAR, palette(7), palette(7))

        do i = 1, size(palette)
            pixels(i) = palette(i)%pixel
        end do
    end subroutine

    subroutine key_down(key)
        !! Reacts to key down events.
        implicit none
        integer, intent(in) :: key
        real                :: speed = 0.25
        real                :: angle = 0.1

        ! print *, key

        select case (key)
            case (24) ! q
                done = .true.
            case (43) ! h
                call rotate(angle)
            case (44) ! j
                call move(speed)
            case (45) ! k
                call move(-speed)
            case (46) ! l
                call rotate(-angle)
        end select
    end subroutine key_down

    subroutine move(move_speed)
        !! Moves the player.
        implicit none
        real, intent(in) :: move_speed
        type(point2d)    :: next_pos

        next_pos%x = pos%x + dir%x * move_speed
        next_pos%y = pos%y + dir%y * move_speed

        if (next_pos%x <= 1 .or. next_pos%x >= map_width - 1 .or. &
            next_pos%y <= 1 .or. next_pos%y >= map_height - 1) &
            return

        if (map(int(next_pos%y) + 1, int(pos%x) + 1) == 0) &
            pos%y = next_pos%y

        if (map(int(pos%y) + 1, int(next_pos%x) + 1) == 0) &
            pos%x = next_pos%x
    end subroutine move

    subroutine rotate(angle)
        !! Rotates the player.
        implicit none
        real, intent(in) :: angle
        real             :: old_dir_x
        real             :: old_plane_x

        old_dir_x = dir%x
        dir%x = dir%x * cos(angle) - dir%y * sin(angle)
        dir%y = old_dir_x * sin(angle) + dir%y * cos(angle)

        old_plane_x = plane%x
        plane%x = plane%x * cos(angle) - plane%y * sin(angle)
        plane%y = old_plane_x * sin(angle) + plane%y * cos(angle)
    end subroutine rotate

    subroutine tick()
        !! Limits the number of frames per second.
        implicit none
        real :: fps
        real :: frame_time

        old_time = time
        call cpu_time(time)

        frame_time = time - old_time
        fps = 1 / frame_time

        if (fps > 60) then
            if (frame_time > min_time) &
                frame_time = 0

            call micro_sleep(int((min_time - frame_time) * 1000000))

            ! write (fps_str, '(a f8.1)') 'FPS: ', fps
            ! call x_set_foreground(display, gc, white)
            ! call x_draw_string(display, double_buffer, gc, 5, 15, fps_str, len(trim(fps_str)))
        end if
    end subroutine tick

    subroutine render()
        !! Renders the scene.
        implicit none
        integer :: x, y1, y2
        integer :: wall, side, color

        call x_set_foreground(display, gc, black)
        call x_fill_rectangle(display, double_buffer, gc, 0, 0, WIDTH, HEIGHT / 2)

        call x_set_foreground(display, gc, pixels(1))
        call x_fill_rectangle(display, double_buffer, gc, 0, HEIGHT / 2, WIDTH, HEIGHT)

        do x = 1, WIDTH
            call cast_ray(WIDTH, HEIGHT, x - 1, y1, y2, wall, side)

            if (wall == 0) &
                continue

            color = wall_color(wall, side)
            call x_set_foreground(display, gc, pixels(color))
            call x_draw_line(display, double_buffer, gc, x - 1, y1, x - 1, y2)
        end do
    end subroutine render

    subroutine draw()
        !! Copies double buffer to window.
        call x_copy_area(display, double_buffer, window, gc, 0, 0, WIDTH, HEIGHT, 0, 0)
    end subroutine draw
end program main
