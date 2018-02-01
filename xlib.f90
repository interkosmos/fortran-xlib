! xlib.f90
!
! Interface to xlib for Fortran 2003/2008.
!
! Author:  Philipp Engel
! Date:    2018-FEB-01
! Licence: ISC
module types
    use iso_c_binding
    implicit none

    type, public, bind(c) :: x_gc_values
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
end module types

module xlib
    implicit none

    interface
        function x_black_pixel(display, screen_number) bind(c, name="XBlackPixel")
            ! unsigned long XBlackPixel(Display *display, int screen_number)
            use iso_c_binding
            implicit none
            type(c_ptr),         intent(in), value :: display
            integer(kind=c_int), intent(in), value :: screen_number
            integer(kind=c_long)                   :: x_black_pixel
        end function x_black_pixel

        function x_create_gc(display, drawable, value_mask, values) bind(c, name="XCreateGC")
            ! GC XCreateGC(Display *display, Drawable d, unsigned long valuemask, XGCValues *values)
            use iso_c_binding
            use types
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
            use iso_c_binding
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
            use iso_c_binding
            implicit none
            type(c_ptr), intent(in), value :: display
            integer(kind=c_long)           :: x_default_root_window
        end function x_default_root_window

        function x_default_screen(display) bind(c, name="XDefaultScreen")
            ! int XDefaultScreen(Display *display)
            use iso_c_binding
            implicit none
            type(c_ptr), intent(in), value  :: display
            integer(kind=c_int)             :: x_default_screen
        end function x_default_screen

        function x_open_display(display_name) bind(c, name="XOpenDisplay")
            ! Display *XOpenDisplay (char *display_name)
            use iso_c_binding
            implicit none
            character(kind=c_char), dimension(*), intent(in) :: display_name
            type(c_ptr)                                      :: x_open_display
        end function x_open_display

        function x_white_pixel(display, screen_number) bind(c, name="XWhitePixel")
            ! unsigned long XWhitePixel(Display *display, int screen_number)
            use iso_c_binding
            implicit none
            type(c_ptr),         intent(in), value :: display
            integer(kind=c_int), intent(in), value :: screen_number
            integer(kind=c_long)                   :: x_white_pixel
        end function x_white_pixel

        subroutine x_clear_window(display, window) bind(c, name="XClearWindow")
            ! XClearWindow(Display *display, Window w)
            use iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: window
        end subroutine x_clear_window

        subroutine x_close_display(display) bind(c, name="XCloseDisplay")
            ! XCloseDisplay(Display *display)
            use iso_c_binding
            implicit none
            type(c_ptr), intent(in), value :: display
        end subroutine x_close_display

        subroutine x_destroy_window(display, window) bind(c, name="XDestroyWindow")
            ! XDestroyWindow(Display *display; Window w)
            use iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: window
        end subroutine x_destroy_window

        subroutine x_free_gc(display, gc) bind(c, name="XFreeGC")
            ! XFreeGC(Display *display, GC gc)
            use iso_c_binding
            implicit none
            type(c_ptr), intent(in), value :: display
            type(c_ptr), intent(in), value :: gc
        end subroutine x_free_gc

        subroutine x_map_window(display, window) bind(c, name="XMapWindow")
            ! XMapWindow(Display *display, Window w)
            use iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: window
        end subroutine

        subroutine x_set_background(display, gc, background) bind(c, name="XSetBackground")
            ! XSetBackground(Display *display, GC gc, unsigned long background)
            use iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_long), intent(in), value :: background
        end subroutine x_set_background

        subroutine x_set_foreground(display, gc, foreground) bind(c, name="XSetForeground")
            ! XSetForeground(Display *display, GC gc, unsigned long foreground)
            use iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_long), intent(in), value :: foreground
        end subroutine x_set_foreground

        subroutine x_sync(display, discard) bind(c, name="XSync")
            ! XSync(Display *display, Bool discard)
            use iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            logical(kind=c_bool), intent(in), value :: discard
        end subroutine
    end interface
end module xlib
