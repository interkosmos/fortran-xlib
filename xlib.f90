! xlib.f90
!
! Interface to Xlib for Fortran 2003/2008.
!
! Author:  Philipp Engel
! Licence: ISC
module xlib_consts
    use, intrinsic :: iso_c_binding
    implicit none

    ! XSizeHint flags.
    integer(kind=c_long), parameter :: us_position   = ishft(1, 0)
    integer(kind=c_long), parameter :: us_size       = ishft(1, 1)
    integer(kind=c_long), parameter :: p_position    = ishft(1, 2)
    integer(kind=c_long), parameter :: p_size        = ishft(1, 3)
    integer(kind=c_long), parameter :: p_min_size    = ishft(1, 4)
    integer(kind=c_long), parameter :: p_max_size    = ishft(1, 5)
    integer(kind=c_long), parameter :: p_resize_inc  = ishft(1, 6)
    integer(kind=c_long), parameter :: p_aspect      = ishft(1, 7)
    integer(kind=c_long), parameter :: p_base_size   = ishft(1, 8)
    integer(kind=c_long), parameter :: p_win_gravity = ishft(1, 9)
    integer(kind=c_long), parameter :: p_all_hints   = ior(p_position, &
                                                       ior(p_size, &
                                                       ior(p_min_size, &
                                                       ior(p_max_size, &
                                                       ior(p_resize_inc, p_aspect)))))

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

    ! XEvent masks.
    integer(kind=c_long), parameter :: no_event_mask              = z'00000000'
    integer(kind=c_long), parameter :: key_press_mask             = z'00000001'
    integer(kind=c_long), parameter :: key_release_mask           = z'00000002'
    integer(kind=c_long), parameter :: button_press_mask          = z'00000004'
    integer(kind=c_long), parameter :: button_release_mask        = z'00000008'
    integer(kind=c_long), parameter :: enter_window_mask          = z'00000010'
    integer(kind=c_long), parameter :: leave_window_mask          = z'00000020'
    integer(kind=c_long), parameter :: pointer_motion_mask        = z'00000040'
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

    integer(kind=c_int), parameter :: line_solid       = 0
    integer(kind=c_int), parameter :: line_on_off_dash = 1
    integer(kind=c_int), parameter :: line_double_dash = 2

    integer(kind=c_int), parameter :: cap_not_last   = 0
    integer(kind=c_int), parameter :: cap_butt       = 1
    integer(kind=c_int), parameter :: cap_round      = 2
    integer(kind=c_int), parameter :: cap_projecting = 3

    integer(kind=c_int), parameter :: join_miter = 0
    integer(kind=c_int), parameter :: join_round = 1
    integer(kind=c_int), parameter :: join_bevel = 2

    integer(kind=c_int), parameter :: fill_solid           = 0
    integer(kind=c_int), parameter :: fill_tiles           = 1
    integer(kind=c_int), parameter :: fill_stippled        = 2
    integer(kind=c_int), parameter :: fill_opaque_stippled = 3

end module xlib_consts

module xlib_types
    use, intrinsic :: iso_c_binding
    implicit none

    ! XAnyEvent
    type, bind(c) :: x_any_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: window
    end type x_any_event

    ! XKeyEvent
    type, bind(c) :: x_key_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: window
        integer(kind=c_long) :: root
        integer(kind=c_long) :: subwindow
        integer(kind=c_long) :: time
        integer(kind=c_int)  :: x
        integer(kind=c_int)  :: y
        integer(kind=c_int)  :: x_root
        integer(kind=c_int)  :: y_root
        integer(kind=c_int)  :: state
        integer(kind=c_int)  :: keycode
        logical(kind=c_bool) :: same_screen
    end type x_key_event

    ! XButtonEvent
    type, bind(c) :: x_button_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: window
        integer(kind=c_long) :: root
        integer(kind=c_long) :: subwindow
        integer(kind=c_long) :: time
        integer(kind=c_int)  :: x
        integer(kind=c_int)  :: y
        integer(kind=c_int)  :: x_root
        integer(kind=c_int)  :: y_root
        integer(kind=c_int)  :: state
        integer(kind=c_int)  :: button
        logical(kind=c_bool) :: same_screen
    end type x_button_event

    ! XMotionEvent
    type, bind(c) :: x_motion_event
        integer(kind=c_int)           :: type
        integer(kind=c_long)          :: serial
        logical(kind=c_bool)          :: send_event
        type(c_ptr)                   :: display
        integer(kind=c_long)          :: window
        integer(kind=c_long)          :: root
        integer(kind=c_long)          :: subwindow
        integer(kind=c_long)          :: time
        integer(kind=c_int)           :: x
        integer(kind=c_int)           :: y
        integer(kind=c_int)           :: x_root
        integer(kind=c_int)           :: y_root
        integer(kind=c_int)           :: state
        character(kind=c_char, len=1) :: is_hint
        logical(kind=c_bool)          :: same_screen
    end type x_motion_event

    ! XCrossingEvent
    type, bind(c) :: x_crossing_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: window
        integer(kind=c_long) :: root
        integer(kind=c_long) :: subwindow
        integer(kind=c_long) :: time
        integer(kind=c_int)  :: x
        integer(kind=c_int)  :: y
        integer(kind=c_int)  :: x_root
        integer(kind=c_int)  :: y_root
        integer(kind=c_int)  :: mode
        integer(kind=c_int)  :: detail
        logical(kind=c_bool) :: same_screen
        logical(kind=c_bool) :: focus
        integer(kind=c_int)  :: state
    end type x_crossing_event

    ! XFocusChangeEvent
    type, bind(c) :: x_focus_change_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: window
        integer(kind=c_int)  :: mode
        integer(kind=c_int)  :: detail
    end type x_focus_change_event

    ! XExposeEvent
    type, bind(c) :: x_expose_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: window
        integer(kind=c_int)  :: x
        integer(kind=c_int)  :: y
        integer(kind=c_int)  :: width
        integer(kind=c_int)  :: height
        integer(kind=c_int)  :: count
    end type x_expose_event

    ! XGraphicsExposeEvent
    type, bind(c) :: x_graphics_expose_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: drawable
        integer(kind=c_int)  :: x
        integer(kind=c_int)  :: y
        integer(kind=c_int)  :: width
        integer(kind=c_int)  :: height
        integer(kind=c_int)  :: count
        integer(kind=c_int)  :: major_code
        integer(kind=c_int)  :: minor_code
    end type x_graphics_expose_event

    ! XGraphicsExposeEvent
    type, bind(c) :: x_no_expose_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: drawable
        integer(kind=c_int)  :: major_code
        integer(kind=c_int)  :: minor_code
    end type x_no_expose_event

    ! XVisibilityEvent
    type, bind(c) :: x_visibility_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: window
        integer(kind=c_int)  :: state
    end type x_visibility_event

    ! XCreateWindowEvent
    type, bind(c) :: x_create_window_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: parent
        integer(kind=c_long) :: window
        integer(kind=c_int)  :: x
        integer(kind=c_int)  :: y
        integer(kind=c_int)  :: width
        integer(kind=c_int)  :: height
        integer(kind=c_int)  :: border_width
        logical(kind=c_bool) :: override_redirect
    end type x_create_window_event

    ! XDestroyWindowEvent
    type, bind(c) :: x_destroy_window_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: event
        integer(kind=c_long) :: window
    end type x_destroy_window_event

    ! XUnmapEvent
    type, bind(c) :: x_unmap_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: event
        integer(kind=c_long) :: window
        logical(kind=c_bool) :: from_configure
    end type x_unmap_event

    ! XMapEvent
    type, bind(c) :: x_map_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: event
        integer(kind=c_long) :: window
        logical(kind=c_bool) :: override_redirect
    end type x_map_event

    ! XMapRequestEvent
    type, bind(c) :: x_map_request_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: parent
        integer(kind=c_long) :: window
    end type x_map_request_event

    ! XReparentEvent
    type, bind(c) :: x_reparent_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: event
        integer(kind=c_long) :: window
        integer(kind=c_long) :: parent
        integer(kind=c_int)  :: x
        integer(kind=c_int)  :: y
        logical(kind=c_bool) :: override_redirect
    end type x_reparent_event

    ! XConfigureEvent
    type, bind(c) :: x_configure_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: event
        integer(kind=c_long) :: window
        integer(kind=c_int)  :: x
        integer(kind=c_int)  :: y
        integer(kind=c_int)  :: width
        integer(kind=c_int)  :: height
        integer(kind=c_int)  :: border_width
        integer(kind=c_long) :: above
        logical(kind=c_bool) :: override_redirect
    end type x_configure_event

    ! XGravityEvent
    type, bind(c) :: x_gravity_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: event
        integer(kind=c_long) :: window
        integer(kind=c_int)  :: x
        integer(kind=c_int)  :: y
    end type x_gravity_event

    ! XResizeRequestEvent
    type, bind(c) :: x_resize_request_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: window
        integer(kind=c_int)  :: width
        integer(kind=c_int)  :: height
    end type x_resize_request_event

    ! XConfigureRequestEvent
    type, bind(c) :: x_configure_request_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: parent
        integer(kind=c_long) :: window
        integer(kind=c_int)  :: x
        integer(kind=c_int)  :: y
        integer(kind=c_int)  :: width
        integer(kind=c_int)  :: height
        integer(kind=c_int)  :: border_width
        integer(kind=c_long) :: above
        integer(kind=c_int)  :: detail
        integer(kind=c_long) :: value_mask
    end type x_configure_request_event

    ! XCircularEvent
    type, bind(c) :: x_circulate_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: event
        integer(kind=c_long) :: window
        integer(kind=c_int)  :: place
    end type x_circulate_event

    ! XCircularRequestEvent
    type, bind(c) :: x_circulate_request_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: parent
        integer(kind=c_long) :: window
        integer(kind=c_int)  :: place
    end type x_circulate_request_event

    ! XPropertyEvent
    type, bind(c) :: x_property_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: window
        integer(kind=c_long) :: atom
        integer(kind=c_long) :: time
        integer(kind=c_int)  :: state
    end type x_property_event

    ! XSelectionClearEvent
    type, bind(c) :: x_selection_clear_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: window
        integer(kind=c_long) :: selection
        integer(kind=c_long) :: time
    end type x_selection_clear_event

    ! XSelectionRequestEvent
    type, bind(c) :: x_selection_request_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: owner
        integer(kind=c_long) :: requestor
        integer(kind=c_long) :: selection
        integer(kind=c_long) :: target
        integer(kind=c_long) :: property
        integer(kind=c_long) :: time
    end type x_selection_request_event

    ! XSelectionEvent
    type, bind(c) :: x_selection_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: requestor
        integer(kind=c_long) :: selection
        integer(kind=c_long) :: target
        integer(kind=c_long) :: property
        integer(kind=c_long) :: time
    end type x_selection_event

    ! XColormapEvent
    type, bind(c) :: x_colormap_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: window
        integer(kind=c_long) :: colormap
        logical(kind=c_bool) :: new
        integer(kind=c_int)  :: state
    end type x_colormap_event

    ! XClientMessageEvent
    type, bind(c) :: x_client_message_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: window
        integer(kind=c_long) :: message_type
        integer(kind=c_int)  :: format
        type(c_ptr)          :: data
    end type x_client_message_event

    ! XMappingEvent
    type, bind(c) :: x_mapping_event
        integer(kind=c_int)  :: type
        integer(kind=c_long) :: serial
        logical(kind=c_bool) :: send_event
        type(c_ptr)          :: display
        integer(kind=c_long) :: window
        integer(kind=c_int)  :: request
        integer(kind=c_int)  :: first_keycode
        integer(kind=c_int)  :: count
    end type x_mapping_event

    ! XErrorEvent
    type, bind(c) :: x_error_event
        integer(kind=c_int)           :: type
        type(c_ptr)                   :: display
        integer(kind=c_long)          :: resourceid
        integer(kind=c_long)          :: serial
        character(kind=c_signed_char) :: error_code
        character(kind=c_signed_char) :: request_code
        character(kind=c_signed_char) :: minor_code
    end type x_error_event

    ! XKeymapEvent
    type, bind(c) :: x_keymap_event
        integer(kind=c_int)                   :: type
        integer(kind=c_long)                  :: serial
        logical(kind=c_bool)                  :: send_event
        type(c_ptr)                           :: display
        integer(kind=c_long)                  :: window
        character(kind=c_char), dimension(32) :: key_vector
    end type x_keymap_event

    ! XEvent
    type, bind(c) :: x_event
        integer(kind=c_int)                 :: type
        integer(kind=c_long), dimension(24) :: pad
    end type x_event

    ! XGCValues
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

    type, bind(c) :: aspect_ratio
        integer(kind=c_int) :: x
        integer(kind=c_int) :: y
    end type aspect_ratio

    ! XSizeHints
    type, bind(c) :: x_size_hints
        integer(kind=c_long) :: flags
        integer(kind=c_int)  :: x
        integer(kind=c_int)  :: y
        integer(kind=c_int)  :: width
        integer(kind=c_int)  :: height
        integer(kind=c_int)  :: min_width
        integer(kind=c_int)  :: min_height
        integer(kind=c_int)  :: max_width
        integer(kind=c_int)  :: max_height
        type(aspect_ratio)   :: min_aspect
        type(aspect_ratio)   :: max_aspect
        integer(kind=c_int)  :: base_width
        integer(kind=c_int)  :: base_height
        integer(kind=c_int)  :: win_gravity
    end type x_size_hints

    ! XColor
    type, bind(c) :: x_color
        integer(kind=c_long)   :: pixel
        integer(kind=c_short)  :: red
        integer(kind=c_short)  :: green
        integer(kind=c_short)  :: blue
        character(kind=c_char) :: flags
        character(kind=c_char) :: pad
    end type x_color
end module xlib_types

module xlib
    implicit none

    interface
        function x_alloc_named_color(display, colormap, color_name, screen_def_return, exact_def_return) &
                bind(c, name="XAllocNamedColor")
            ! Status XAllocNamedColor(Display *display, Colormap colormap, char *color_name, XColor *screen_def_return, XColor *exact_def_return)
            use, intrinsic :: iso_c_binding
            use xlib_types
            implicit none
            type(c_ptr),            intent(in), value :: display
            integer(kind=c_long),   intent(in), value :: colormap
            character(kind=c_char), intent(in)        :: color_name
            type(x_color),          intent(inout)     :: screen_def_return
            type(x_color),          intent(inout)     :: exact_def_return
            integer(kind=c_int)                       :: x_alloc_named_color
        end function x_alloc_named_color

        function x_alloc_size_hints() bind(c, name="XAllocSizeHints")
            ! XSizeHints *XAllocSizeHints()
            use, intrinsic :: iso_c_binding
            use xlib_types
            implicit none
            type(x_size_hints) :: x_alloc_size_hints
        end function x_alloc_size_hints

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

        function x_create_simple_window(display, parent, x, y, width, height, border_width, border, background) &
                bind(c, name="XCreateSimpleWindow")
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

        function x_default_colormap(display, screen_number) bind(c, name="XDefaultColormap")
            ! Colormap XDefaultColormap(Display *display, int screen_number)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_int),  intent(in), value :: screen_number
            integer(kind=c_long)                    :: x_default_colormap
        end function x_default_colormap

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
            type(c_ptr), intent(in), value :: display
            integer(kind=c_int)            :: x_default_screen
        end function x_default_screen

        function x_intern_atom(display, atom_name, only_if_exists) bind(c, name="XInternAtom")
            ! Atom XInternAtom(Display *display, char *atom_name, Bool only_if_exists)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),            intent(in), value :: display
            character(kind=c_char), intent(in)        :: atom_name
            logical(kind=c_bool),   intent(in), value :: only_if_exists
            integer(kind=c_long)                      :: x_intern_atom
        end function x_intern_atom

        function x_open_display(display_name) bind(c, name="XOpenDisplay")
            ! Display *XOpenDisplay (char *display_name)
            use, intrinsic :: iso_c_binding
            implicit none
            character(kind=c_char, len=1), intent(in) :: display_name
            type(c_ptr)                               :: x_open_display
        end function x_open_display

        function x_set_wm_protocols(display, w, protocols, count) bind(c, name="XSetWMProtocols")
            ! Status XSetWMProtocols(Display *display, Window w, Atom *protocols, int count)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: w
            integer(kind=c_long), intent(in)        :: protocols
            integer(kind=c_int),  intent(in), value :: count
            integer(kind=c_int)                     :: x_set_wm_protocols
        end function x_set_wm_protocols

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

        subroutine x_draw_arc(display, d, gc, x, y, width, height, angle1, angle2) bind(c, name="XDrawArc")
            ! XDrawArc(Display *display, Drawable d, GC gc, int x, int y, unsigned int width, unsigned int height, int angle1, int angle2)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: d
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_int),  intent(in), value :: x
            integer(kind=c_int),  intent(in), value :: y
            integer(kind=c_int),  intent(in), value :: width
            integer(kind=c_int),  intent(in), value :: height
            integer(kind=c_int),  intent(in), value :: angle1
            integer(kind=c_int),  intent(in), value :: angle2
        end subroutine x_draw_arc

        subroutine x_draw_line(display, d, gc, x1, y1, x2, y2) bind(c, name="XDrawLine")
            ! XDrawLine(Display *display, Drawable d, GC gc, int x1, int y1, int x2, int y2)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: d
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_int),  intent(in), value :: x1
            integer(kind=c_int),  intent(in), value :: y1
            integer(kind=c_int),  intent(in), value :: x2
            integer(kind=c_int),  intent(in), value :: y2
        end subroutine x_draw_line

        subroutine x_draw_point(display, d, gc, x, y) bind(c, name="XDrawPoint")
            ! XDrawPoint(Display *display, Drawable d, GC gc, int x, int y)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: d
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_int),  intent(in), value :: x
            integer(kind=c_int),  intent(in), value :: y
        end subroutine x_draw_point

        subroutine x_draw_rectangle(display, d, gc, x, y, width, height) bind(c, name="XDrawRectangle")
            ! XDrawRectangle(Display *display, Drawable d, GC gc, int x, int y, unsigned int width, unsigned int height)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: d
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_int),  intent(in), value :: x
            integer(kind=c_int),  intent(in), value :: y
            integer(kind=c_int),  intent(in), value :: width
            integer(kind=c_int),  intent(in), value :: height
        end subroutine x_draw_rectangle

        subroutine x_fill_rectangle(display, d, gc, x, y, width, height) bind(c, name="XFillRectangle")
            ! XFillRectangle(Display *display, Drawable d, GC gc, int x, int y, unsigned int width, unsigned int height)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: d
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_int),  intent(in), value :: x
            integer(kind=c_int),  intent(in), value :: y
            integer(kind=c_int),  intent(in), value :: width
            integer(kind=c_int),  intent(in), value :: height
        end subroutine x_fill_rectangle

        subroutine x_flush(display) bind(c, name="XFlush")
            ! XFlush(Display *display)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr), intent(in), value :: display
        end subroutine x_flush

        subroutine x_free(data) bind(c, name="XFree")
            ! XFree(void *data)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr), intent(in), value :: data
        end subroutine x_free

        subroutine x_free_colors(display, colormap, pixels, npixels, planes) bind(c, name="XFreeColors")
            ! XFreeColors(Display *display, Colormap colormap, unsigned long pixels[], int npixels, unsigned long planes)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),                        intent(in), value :: display
            integer(kind=c_long),               intent(in), value :: colormap
            integer(kind=c_long), dimension(*), intent(in)        :: pixels
            integer(kind=c_int),                intent(in), value :: npixels
            integer(kind=c_long),               intent(in), value :: planes
        end subroutine x_free_colors

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
            type(c_ptr),   intent(in), value :: display
            type(x_event), intent(inout)     :: event_return
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

        subroutine x_set_fill_style(display, gc, fill_style) bind(c, name="XSetFillStyle")
            ! XSetFillStyle(Display *display, GC gc, int fill_style)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),         intent(in), value :: display
            type(c_ptr),         intent(in), value :: gc
            integer(kind=c_int), intent(in), value :: fill_style
        end subroutine x_set_fill_style

        subroutine x_set_line_attributes(display, gc, line_width, line_style, cap_style, join_style) &
                bind(c, name="XSetLineAttributes")
            ! XSetLineAttributes(Display *display, GC gc, unsigned int line_width, int line_style, int cap_style, int join_style)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),         intent(in), value :: display
            type(c_ptr),         intent(in), value :: gc
            integer(kind=c_int), intent(in), value :: line_width
            integer(kind=c_int), intent(in), value :: line_style
            integer(kind=c_int), intent(in), value :: cap_style
            integer(kind=c_int), intent(in), value :: join_style
        end subroutine x_set_line_attributes

        subroutine x_set_foreground(display, gc, foreground) bind(c, name="XSetForeground")
            ! XSetForeground(Display *display, GC gc, unsigned long foreground)
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),          intent(in), value :: display
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_long), intent(in), value :: foreground
        end subroutine x_set_foreground

        subroutine x_set_wm_normal_hints(display, w, hints) bind(c, name="XSetWMNormalHints")
            ! XSetWMNormalHints(Display *display, Window w, XSizeHints *hints)
            use, intrinsic :: iso_c_binding
            use xlib_types
            implicit none
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: w
            type(x_size_hints),   intent(in)        :: hints
        end subroutine x_set_wm_normal_hints

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
