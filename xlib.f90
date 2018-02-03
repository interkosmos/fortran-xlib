! xlib.f90
!
! Interface to xlib for Fortran 2003/2008.
!
! Author:  Philipp Engel
! Date:    2018-FEB-03
! Licence: ISC
module xlib_consts
    use, intrinsic :: iso_c_binding
    implicit none

    integer(kind=c_int), parameter :: key_press         = 2
    integer(kind=c_int), parameter :: key_release       = 3
    integer(kind=c_int), parameter :: button_press      = 4
    integer(kind=c_int), parameter :: button_release    = 5
    integer(kind=c_int), parameter :: motion_notify     = 6
    integer(kind=c_int), parameter :: enter_notify      = 7
    integer(kind=c_int), parameter :: leave_notify      = 8
    integer(kind=c_int), parameter :: focus_in          = 9
    integer(kind=c_int), parameter :: focus_out         = 10
    integer(kind=c_int), parameter :: keymap_notify     = 11
    integer(kind=c_int), parameter :: expose            = 12
    integer(kind=c_int), parameter :: graphics_expose   = 13
    integer(kind=c_int), parameter :: no_expose         = 14
    integer(kind=c_int), parameter :: visibility_notify = 15
    integer(kind=c_int), parameter :: create_notify     = 16
    integer(kind=c_int), parameter :: destroy_notify    = 17
    integer(kind=c_int), parameter :: unmap_notify      = 18
    integer(kind=c_int), parameter :: map_notify        = 19
    integer(kind=c_int), parameter :: map_request       = 20
    integer(kind=c_int), parameter :: reparent_notify   = 21
    integer(kind=c_int), parameter :: configure_notify  = 22
    integer(kind=c_int), parameter :: configure_request = 23
    integer(kind=c_int), parameter :: gravity_notify    = 24
    integer(kind=c_int), parameter :: resize_request    = 25
    integer(kind=c_int), parameter :: circulate_notify  = 26
    integer(kind=c_int), parameter :: circulate_request = 27
    integer(kind=c_int), parameter :: property_notify   = 28
    integer(kind=c_int), parameter :: selection_clear   = 29
    integer(kind=c_int), parameter :: selection_request = 30
    integer(kind=c_int), parameter :: selection_notify  = 31
    integer(kind=c_int), parameter :: colormap_notify   = 32
    integer(kind=c_int), parameter :: client_message    = 33
    integer(kind=c_int), parameter :: mapping_notify    = 34
    integer(kind=c_int), parameter :: generic_event     = 35

    integer(kind=c_int), parameter :: shift_mask   = z'01'
    integer(kind=c_int), parameter :: lock_mask    = z'02'
    integer(kind=c_int), parameter :: control_mask = z'04'

    integer(kind=c_long), parameter :: no_event_mask              = z'00000000'
    integer(kind=c_long), parameter :: key_press_mask             = z'00000001'
    integer(kind=c_long), parameter :: key_release_mask           = z'00000002'
    integer(kind=c_long), parameter :: button_press_mask          = z'00000004'
    integer(kind=c_long), parameter :: button_release_mask        = z'00000008'
    integer(kind=c_long), parameter :: enter_window_mask          = z'00000010'
    integer(kind=c_long), parameter :: leave_window_mask          = z'00000020'
    integer(kind=c_long), parameter :: button1_motion_mask        = z'00000100'
    integer(kind=c_long), parameter :: button2_motion_mask        = z'00000200'
    integer(kind=c_long), parameter :: button3_motion_mask        = z'00000400'
    integer(kind=c_long), parameter :: button4_motion_mask        = z'00000800'
    integer(kind=c_long), parameter :: button5_motion_mask        = z'00001000'
    integer(kind=c_long), parameter :: button_motion_mask         = z'00002000'
    integer(kind=c_long), parameter :: keymap_state_mask          = z'00004000'
    integer(kind=c_long), parameter :: exposure_mask              = z'00008000'
    integer(kind=c_long), parameter :: visibility_change_mask     = z'00010000'
    integer(kind=c_long), parameter :: structure_notify_mask      = z'00020000'
    integer(kind=c_long), parameter :: resize_redirect_mask       = z'00040000'
    integer(kind=c_long), parameter :: substructure_notify_mask   = z'00080000'
    integer(kind=c_long), parameter :: substructure_redirect_mask = z'00100000'
    integer(kind=c_long), parameter :: focus_change_mask          = z'00200000'
end module xlib_consts

module xlib_types
    use, intrinsic :: iso_c_binding
    implicit none

    type, bind(c) :: x_event
        integer(kind=c_int)                 :: type
        integer(kind=c_long), dimension(24) :: pad
    end type x_event

    type, bind(c) :: x_gc_values
        integer(kind=c_int)           :: logical_operation
        integer(kind=c_long)          :: plane_mask
        integer(kind=c_long)          :: foreground
        integer(kind=c_long)          :: background
        integer(kind=c_int)           :: line_width
        integer(kind=c_int)           :: line_style
        integer(kind=c_int)           :: cap_style
        integer(kind=c_int)           :: join_style
        integer(kind=c_int)           :: fill_style
        integer(kind=c_int)           :: fill_rule
        integer(kind=c_int)           :: arc_mode
        type(c_ptr)                   :: tile
        type(c_ptr)                   :: stipple
        integer(kind=c_int)           :: ts_x_origin
        integer(kind=c_int)           :: ts_y_origin
        type(c_ptr)                   :: font
        integer(kind=c_int)           :: subwindow_mode
        logical(kind=c_bool)          :: graphics_exposures
        integer(kind=c_int)           :: clip_x_origin
        integer(kind=c_int)           :: clip_y_origin
        type(c_ptr)                   :: clip_mask
        integer(kind=c_int)           :: dash_offset
        character(kind=c_char, len=1) :: dashes
    end type x_gc_values
end module xlib_types

module xlib
    implicit none

    interface
        function x_black_pixel(display, screen_number) bind(c, name="XBlackPixel")
            ! unsigned long XBlackPixel(Display *display, int screen_number)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),         intent(in), value :: display
            integer(kind=c_int), intent(in), value :: screen_number
            integer(kind=c_long)                   :: x_black_pixel
        end function x_black_pixel

        function x_create_gc(display, drawable, value_mask, values) bind(c, name="XCreateGC")
            ! GC XCreateGC(Display *display, Drawable d, unsigned long valuemask, XGCValues *values)
            use, intrinsic :: iso_c_binding
            use xlib_types
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: drawable
            integer(kind=c_int),  intent(in), value :: value_mask
            type(x_gc_values),    intent(in)        :: values
            type(c_ptr)                             :: x_create_gc
        end function x_create_gc

        function x_create_simple_window(display, parent, &
                                        x, y, &
                                        width, height, &
                                        border_width, &
                                        border, background) bind(c, name="XCreateSimpleWindow")
            ! Window XCreateSimpleWindow(Display *display, Window parent, int x, int y, unsigned int width, unsigned int height, unsigned int border_width, unsigned long border, unsigned long background)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: parent
            integer(kind=c_int),  intent(in), value :: x
            integer(kind=c_int),  intent(in), value :: y
            integer(kind=c_int),  intent(in), value :: width
            integer(kind=c_int),  intent(in), value :: height
            integer(kind=c_int),  intent(in), value :: border_width
            integer(kind=c_long), intent(in), value :: border
            integer(kind=c_long), intent(in), value :: background
            integer(kind=c_long)                    :: x_create_simple_window
        end function x_create_simple_window

        function x_default_root_window(display) bind(c, name="XDefaultRootWindow")
            ! Window XDefaultRootWindow(Display *display)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr), intent(in), value :: display
            integer(kind=c_long)           :: x_default_root_window
        end function x_default_root_window

        function x_default_screen(display) bind(c, name="XDefaultScreen")
            ! int XDefaultScreen(Display *display)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr), intent(in), value  :: display
            integer(kind=c_int)             :: x_default_screen
        end function x_default_screen

        function x_open_display(display_name) bind(c, name="XOpenDisplay")
            ! Display *XOpenDisplay (char *display_name)
            use, intrinsic :: iso_c_binding
            implicit none
            character(kind=c_char), dimension(*), intent(in) :: display_name
            type(c_ptr)                                      :: x_open_display
        end function x_open_display

        function x_white_pixel(display, screen_number) bind(c, name="XWhitePixel")
            ! unsigned long XWhitePixel(Display *display, int screen_number)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),         intent(in), value :: display
            integer(kind=c_int), intent(in), value :: screen_number
            integer(kind=c_long)                   :: x_white_pixel
        end function x_white_pixel

        subroutine x_clear_window(display, w) bind(c, name="XClearWindow")
            ! XClearWindow(Display *display, Window w)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: w
        end subroutine x_clear_window

        subroutine x_close_display(display) bind(c, name="XCloseDisplay")
            ! XCloseDisplay(Display *display)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr), intent(in), value :: display
        end subroutine x_close_display

        subroutine x_destroy_window(display, w) bind(c, name="XDestroyWindow")
            ! XDestroyWindow(Display *display; Window w)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: w
        end subroutine x_destroy_window

        subroutine x_free_gc(display, gc) bind(c, name="XFreeGC")
            ! XFreeGC(Display *display, GC gc)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr), intent(in), value :: display
            type(c_ptr), intent(in), value :: gc
        end subroutine x_free_gc

        subroutine x_map_window(display, w) bind(c, name="XMapWindow")
            ! XMapWindow(Display *display, Window w)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: w
        end subroutine

        subroutine x_next_event(display, event_return) bind(c, name="XNextEvent")
            ! XNextEvent(Display *display, XEvent *event_return)
            use, intrinsic :: iso_c_binding
            use xlib_types
            implicit none
            type(c_ptr), intent(in), value :: display
            type(c_ptr), intent(in), value :: event_return
        end subroutine x_next_event

        subroutine x_select_input(display, w, event_mask) bind(c, name="XSelectInput")
            ! XSelectInput(Display *display, Window w, long event_mask)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: w
            integer(kind=c_long), intent(in), value :: event_mask
        end subroutine

        subroutine x_set_background(display, gc, background) bind(c, name="XSetBackground")
            ! XSetBackground(Display *display, GC gc, unsigned long background)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_long), intent(in), value :: background
        end subroutine x_set_background

        subroutine x_set_foreground(display, gc, foreground) bind(c, name="XSetForeground")
            ! XSetForeground(Display *display, GC gc, unsigned long foreground)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_long), intent(in), value :: foreground
        end subroutine x_set_foreground

        subroutine x_store_name(display, w, window_name) bind(c, name="XStoreName")
            ! XStoreName(Display *display, Window w, char *window_name)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),                   intent(in), value :: display
            integer(kind=c_long),          intent(in), value :: w
            character(kind=c_char, len=1), intent(in)        :: window_name
        end subroutine x_store_name

        subroutine x_sync(display, discard) bind(c, name="XSync")
            ! XSync(Display *display, Bool discard)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            logical(kind=c_bool), intent(in), value :: discard
        end subroutine
    end interface
end module xlib
