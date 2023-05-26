! wireframe.f90
!
! Double buffered software rendering of a 3-D wire-frame model. The model
! is loaded from a Wavefront OBJ file.
!
! Author:  Philipp Engel
! Licence: ISC
module vector
    implicit none

    real, parameter :: PI = acos(-1.0)

    public :: project
    public :: rotate_x
    public :: rotate_y
    public :: rotate_z

    type :: point2d
        real :: x, y
    end type point2d

    type :: point3d
        real :: x, y, z
    end type point3d
contains
    elemental type(point2d) function project(v, width, height, fov, distance) result(p)
        !! Transforms a 3-D vector to a 2-D vector by using perspective projection.
        type(point3d), intent(in) :: v
        integer,       intent(in) :: width
        integer,       intent(in) :: height
        real,          intent(in) :: fov
        real,          intent(in) :: distance
        real                      :: f

        f   = fov / (distance + v%z)
        p%x = v%x * f + width / 2
        p%y = -1 * v%y * f + height / 2
    end function project

    elemental real function rad(deg)
        !! Converts an angle from deg to rad.
        real, intent(in) :: deg

        rad = deg * PI / 180
    end function rad

    elemental type(point3d) function rotate_x(v, angle) result(r)
        !! Rotates vector in x.
        type(point3d), intent(in) :: v
        real,          intent(in) :: angle

        r%x = v%x
        r%y = v%y * cos(angle) - v%z * sin(angle)
        r%z = v%z * sin(angle) + v%z * cos(angle)
    end function rotate_x

    elemental type(point3d) function rotate_y(v, angle) result(r)
        !! Rotates vector in y.
        type(point3d), intent(in) :: v
        real,          intent(in) :: angle

        r%x = v%z * sin(angle) + v%x * cos(angle)
        r%y = v%y
        r%z = v%z * cos(angle) - v%x * sin(angle)
    end function rotate_y

    elemental type(point3d) function rotate_z(v, angle) result(r)
        !! Rotates vector in z.
        type(point3d), intent(in) :: v
        real,          intent(in) :: angle

        r%x = v%x * cos(angle) - v%y * sin(angle)
        r%y = v%x * sin(angle) - v%y * cos(angle)
        r%z = v%z
    end function rotate_z
end module vector

module obj
    !! Loads and stores a 3-D object.
    use :: vector
    implicit none

    type :: face
        integer :: v1, v2
    end type face

    type(point3d), allocatable :: vertices(:)
    type(face),    allocatable :: faces(:)

    public :: load_obj_file
contains
    subroutine load_obj_file(file_name)
        !! Loads a Wavefront OBJ file.
        character(len=*), intent(in) :: file_name

        character(len=100)         :: buffer
        character                  :: a
        integer                    :: v_size, f_size
        integer                    :: fu, rc
        type(point3d), allocatable :: tmp_vertices(:)
        type(face),    allocatable :: tmp_faces(:)

        allocate (vertices(1))
        allocate (faces(1))

        open (action='read', file=file_name, iostat=rc, newunit=fu)

        if (rc /= 0) then
            close (fu)
            print '(3a, i0)', 'Reading file "', file_name, '" failed: ', rc
            return
        end if

        do
            read (fu, '(a)', iostat=rc) buffer
            if (rc /= 0) exit

            select case (buffer(1:1))
                case ('v')
                    ! Read vertice.
                    v_size = size(vertices)
                    allocate (tmp_vertices(v_size + 1))
                    tmp_vertices(1:v_size) = vertices

                    read (buffer, *) a, &
                                     tmp_vertices(v_size)%x, &
                                     tmp_vertices(v_size)%y, &
                                     tmp_vertices(v_size)%z

                    call move_alloc(tmp_vertices, vertices)
                case ('f')
                    ! Read face.
                    f_size = size(faces)
                    allocate (tmp_faces(f_size + 1))
                    tmp_faces(1:f_size) = faces

                    read (buffer, *) a, &
                                     tmp_faces(f_size)%v1, &
                                     tmp_faces(f_size)%v2

                    call move_alloc(tmp_faces, faces)
                case default
                    continue
            end select
        end do

        close (fu)

        ! Resize the arrays to their actual sizes (ugly, I know ...).
        if (allocated(tmp_vertices)) deallocate (tmp_vertices)
        if (allocated(tmp_faces))    deallocate (tmp_faces)

        ! Actual array sizes.
        v_size = size(vertices) - 1
        f_size = size(faces) - 1

        allocate (tmp_vertices(v_size))
        allocate (tmp_faces(f_size))

        tmp_vertices = vertices(1:v_size)
        tmp_faces    = faces(1:f_size)

        call move_alloc(tmp_vertices, vertices)
        call move_alloc(tmp_faces, faces)
    end subroutine load_obj_file
end module obj

program main
    use, intrinsic :: iso_c_binding
    use :: xlib
    use :: obj
    use :: vector
    implicit none

    interface
        subroutine c_usleep(useconds) bind(c, name='usleep')
            !! Interface to usleep in libc.
            import :: c_int32_t
            implicit none
            integer(c_int32_t), value :: useconds
        end subroutine c_usleep
    end interface

    integer,          parameter :: WIDTH     = 640
    integer,          parameter :: HEIGHT    = 480
    character(len=*), parameter :: FILE_NAME = 'examples/wireframe/tie.obj'

    integer              :: rc, screen
    integer(kind=c_long) :: black, white
    integer(kind=c_long) :: colormap, double_buffer
    integer(kind=c_long) :: long(5), wm_delete_window
    integer(kind=c_long) :: root, window
    real                 :: angle_x, angle_y, angle_z
    type(c_ptr)          :: display, gc
    type(x_color)        :: color
    type(x_event)        :: event
    type(x_gc_values)    :: values
    type(x_size_hints)   :: size_hints

    type(point2d), allocatable :: transformed(:)

    call load_obj_file(FILE_NAME)

    if (.not. allocated(vertices) .or. .not. allocated(faces)) &
        stop

    ! Open display.
    display  = x_open_display(c_null_char)
    screen   = x_default_screen(display)
    root     = x_default_root_window(display)
    colormap = x_default_colormap(display, screen)

    ! Define colours.
    black = x_black_pixel(display, screen)
    white = x_white_pixel(display, screen)

    rc = x_alloc_named_color(display, colormap, 'SteelBlue' // c_null_char, color, color)

    if (rc == 0) then
        print *, 'XAllocNamedColor failed to allocate "SteelBlue" colour.'
        stop
    end if

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

    call x_set_background(display, gc, black)
    call x_set_foreground(display, gc, white)

    ! Create double buffer.
    double_buffer = x_create_pixmap(display, window, WIDTH, HEIGHT, 24)

    ! Show window.
    call x_select_input(display, window, ior(EXPOSURE_MASK, STRUCTURE_NOTIFY_MASK))
    call x_map_window(display, window)

    angle_x = 0.0
    angle_y = 0.0
    angle_z = 0.0

    do
        rc = x_pending(display)

        if (rc > 0) then
            call x_next_event(display, event)

            select case (event%type)
                case (expose)
                    ! call draw()
                case (client_message)
                    long = transfer(event%x_client_message%data, long)
                    if (long(1) == wm_delete_window) exit
            end select

            cycle
        end if

        call update(angle_x, angle_y, angle_z)
        call render()

        ! angle_x = angle_x + 1.0
        angle_y = angle_y + 1.0
        ! angle_z = angle_z + 1.0

        call draw()
        call c_usleep(25000)
    end do

    ! Clean up and close window.
    call x_free_colors(display, colormap, [ color%pixel ], 1, int(0, kind=c_long))
    call x_free_pixmap(display, double_buffer)
    call x_free_gc(display, gc)
    call x_destroy_window(display, window)
    call x_close_display(display)
contains
    subroutine update(angle_x, angle_y, angle_z)
        !! Rotates the 3-D object.
        real, intent(in) :: angle_x
        real, intent(in) :: angle_y
        real, intent(in) :: angle_z

        type(point3d) :: v
        integer       :: i

        if (.not. allocated(transformed)) allocate (transformed(size(vertices)))

        do i = 1, size(vertices, 1)
            v = vertices(i)
            v = rotate_x(v, rad(angle_x))
            v = rotate_y(v, rad(angle_y))
            v = rotate_z(v, rad(angle_z))
            transformed(i) = project(v, WIDTH, HEIGHT, 256.0, 8.0)
        end do
    end subroutine update

    subroutine render()
        !! Renders the scene on the double buffer.
        integer :: x1, y1, x2, y2
        integer :: i

        call x_set_foreground(display, gc, black)
        call x_fill_rectangle(display, double_buffer, gc, 0, 0, WIDTH, HEIGHT)
        call x_set_foreground(display, gc, color%pixel)

        do i = 1, size(faces, 1)
            x1 = int(transformed(faces(i)%v1)%x)
            y1 = int(transformed(faces(i)%v1)%y)
            x2 = int(transformed(faces(i)%v2)%x)
            y2 = int(transformed(faces(i)%v2)%y)

            call x_draw_line(display, double_buffer, gc, x1, y1, x2, y2)
        end do
    end subroutine render

    subroutine draw()
        !! Copies double buffer to window.
        call x_copy_area(display, double_buffer, window, gc, 0, 0, WIDTH, HEIGHT, 0, 0)
    end subroutine draw
end program main
