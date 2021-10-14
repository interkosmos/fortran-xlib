! xlib.f90
!
! Interface to Xlib for Fortran 2003.
!
! Author:  Philipp Engel
! Licence: ISC
module xlib
    use, intrinsic :: iso_c_binding
    implicit none

    ! Type aliases.
    integer, parameter :: c_uint8_t            = c_int8_t
    integer, parameter :: c_uint16_t           = c_int16_t
    integer, parameter :: c_uint32_t           = c_int32_t
    integer, parameter :: c_uint64_t           = c_int64_t
    integer, parameter :: c_unsigned           = c_int
    integer, parameter :: c_unsigned_char      = c_signed_char
    integer, parameter :: c_unsigned_long      = c_long
    integer, parameter :: c_unsigned_long_long = c_long_long
    integer, parameter :: c_unsigned_short     = c_short

    ! XSizeHint flags.
    integer(kind=c_long), parameter :: US_POSITION   = ishft(1, 0)
    integer(kind=c_long), parameter :: US_SIZE       = ishft(1, 1)
    integer(kind=c_long), parameter :: P_POSITION    = ishft(1, 2)
    integer(kind=c_long), parameter :: P_SIZE        = ishft(1, 3)
    integer(kind=c_long), parameter :: P_MIN_SIZE    = ishft(1, 4)
    integer(kind=c_long), parameter :: P_MAX_SIZE    = ishft(1, 5)
    integer(kind=c_long), parameter :: P_RESIZE_INC  = ishft(1, 6)
    integer(kind=c_long), parameter :: P_ASPECT      = ishft(1, 7)
    integer(kind=c_long), parameter :: P_BASE_SIZE   = ishft(1, 8)
    integer(kind=c_long), parameter :: P_WIN_GRAVITY = ishft(1, 9)
    integer(kind=c_long), parameter :: P_ALL_HINTS   = ior(P_POSITION, &
                                                           ior(P_SIZE, &
                                                           ior(P_MIN_SIZE, &
                                                           ior(P_MAX_SIZE, &
                                                           ior(P_RESIZE_INC, P_ASPECT)))))

    integer(kind=c_int), parameter :: KEY_PRESS         = 2
    integer(kind=c_int), parameter :: KEY_RELEASE       = 3
    integer(kind=c_int), parameter :: BUTTON_PRESS      = 4
    integer(kind=c_int), parameter :: BUTTON_RELEASE    = 5
    integer(kind=c_int), parameter :: MOTION_NOTIFY     = 6
    integer(kind=c_int), parameter :: ENTER_NOTIFY      = 7
    integer(kind=c_int), parameter :: LEAVE_NOTIFY      = 8
    integer(kind=c_int), parameter :: FOCUS_IN          = 9
    integer(kind=c_int), parameter :: FOCUS_OUT         = 10
    integer(kind=c_int), parameter :: KEYMAP_NOTIFY     = 11
    integer(kind=c_int), parameter :: EXPOSE            = 12
    integer(kind=c_int), parameter :: GRAPHICS_EXPOSE   = 13
    integer(kind=c_int), parameter :: NO_EXPOSE         = 14
    integer(kind=c_int), parameter :: VISIBILITY_NOTIFY = 15
    integer(kind=c_int), parameter :: CREATE_NOTIFY     = 16
    integer(kind=c_int), parameter :: DESTROY_NOTIFY    = 17
    integer(kind=c_int), parameter :: UNMAP_NOTIFY      = 18
    integer(kind=c_int), parameter :: MAP_NOTIFY        = 19
    integer(kind=c_int), parameter :: MAP_REQUEST       = 20
    integer(kind=c_int), parameter :: REPARENT_NOTIFY   = 21
    integer(kind=c_int), parameter :: CONFIGURE_NOTIFY  = 22
    integer(kind=c_int), parameter :: CONFIGURE_REQUEST = 23
    integer(kind=c_int), parameter :: GRAVITY_NOTIFY    = 24
    integer(kind=c_int), parameter :: RESIZE_REQUEST    = 25
    integer(kind=c_int), parameter :: CIRCULATE_NOTIFY  = 26
    integer(kind=c_int), parameter :: CIRCULATE_REQUEST = 27
    integer(kind=c_int), parameter :: PROPERTY_NOTIFY   = 28
    integer(kind=c_int), parameter :: SELECTION_CLEAR   = 29
    integer(kind=c_int), parameter :: SELECTION_REQUEST = 30
    integer(kind=c_int), parameter :: SELECTION_NOTIFY  = 31
    integer(kind=c_int), parameter :: COLORMAP_NOTIFY   = 32
    integer(kind=c_int), parameter :: CLIENT_MESSAGE    = 33
    integer(kind=c_int), parameter :: MAPPING_NOTIFY    = 34
    integer(kind=c_int), parameter :: GENERIC_EVENT     = 35

    integer(kind=c_int), parameter :: SHIFT_MASK   = int(z'01')
    integer(kind=c_int), parameter :: LOCK_MASK    = int(z'02')
    integer(kind=c_int), parameter :: CONTROL_MASK = int(z'04')

    ! XEvent masks.
    integer(kind=c_long), parameter :: NO_EVENT_MASK              = int(z'00000000')
    integer(kind=c_long), parameter :: KEY_PRESS_MASK             = int(z'00000001')
    integer(kind=c_long), parameter :: KEY_RELEASE_MASK           = int(z'00000002')
    integer(kind=c_long), parameter :: BUTTON_PRESS_MASK          = int(z'00000004')
    integer(kind=c_long), parameter :: BUTTON_RELEASE_MASK        = int(z'00000008')
    integer(kind=c_long), parameter :: ENTER_WINDOW_MASK          = int(z'00000010')
    integer(kind=c_long), parameter :: LEAVE_WINDOW_MASK          = int(z'00000020')
    integer(kind=c_long), parameter :: POINTER_MOTION_MASK        = int(z'00000040')
    integer(kind=c_long), parameter :: BUTTON1_MOTION_MASK        = int(z'00000100')
    integer(kind=c_long), parameter :: BUTTON2_MOTION_MASK        = int(z'00000200')
    integer(kind=c_long), parameter :: BUTTON3_MOTION_MASK        = int(z'00000400')
    integer(kind=c_long), parameter :: BUTTON4_MOTION_MASK        = int(z'00000800')
    integer(kind=c_long), parameter :: BUTTON5_MOTION_MASK        = int(z'00001000')
    integer(kind=c_long), parameter :: BUTTON_MOTION_MASK         = int(z'00002000')
    integer(kind=c_long), parameter :: KEYMAP_STATE_MASK          = int(z'00004000')
    integer(kind=c_long), parameter :: EXPOSURE_MASK              = int(z'00008000')
    integer(kind=c_long), parameter :: VISIBILITY_CHANGE_MASK     = int(z'00010000')
    integer(kind=c_long), parameter :: STRUCTURE_NOTIFY_MASK      = int(z'00020000')
    integer(kind=c_long), parameter :: RESIZE_REDIRECT_MASK       = int(z'00040000')
    integer(kind=c_long), parameter :: SUBSTRUCTURE_NOTIFY_MASK   = int(z'00080000')
    integer(kind=c_long), parameter :: SUBSTRUCTURE_REDIRECT_MASK = int(z'00100000')
    integer(kind=c_long), parameter :: FOCUS_CHANGE_MASK          = int(z'00200000')

    integer(kind=c_int), parameter :: LINE_SOLID       = 0
    integer(kind=c_int), parameter :: LINE_ON_OFF_DASH = 1
    integer(kind=c_int), parameter :: LINE_DOUBLE_DASH = 2

    integer(kind=c_int), parameter :: CAP_NOT_LAST   = 0
    integer(kind=c_int), parameter :: CAP_BUTT       = 1
    integer(kind=c_int), parameter :: CAP_ROUND      = 2
    integer(kind=c_int), parameter :: CAP_PROJECTING = 3

    integer(kind=c_int), parameter :: JOIN_MITER = 0
    integer(kind=c_int), parameter :: JOIN_ROUND = 1
    integer(kind=c_int), parameter :: JOIN_BEVEL = 2

    integer(kind=c_int), parameter :: FILL_SOLID           = 0
    integer(kind=c_int), parameter :: FILL_TILES           = 1
    integer(kind=c_int), parameter :: FILL_STIPPLED        = 2
    integer(kind=c_int), parameter :: FILL_OPAQUE_STIPPLED = 3

    integer(kind=c_int), parameter :: COMPLEX   = 0
    integer(kind=c_int), parameter :: NONCONVEX = 1
    integer(kind=c_int), parameter :: CONVEX    = 2

    integer(kind=c_int), parameter :: COORD_MODE_ORIGIN   = 0
    integer(kind=c_int), parameter :: COORD_MODE_PREVIOUS = 1

    integer(kind=c_int), parameter :: XY_BITMAP = 0
    integer(kind=c_int), parameter :: XY_PIXMAP = 1
    integer(kind=c_int), parameter :: Z_PIXMAP  = 2

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
        integer(kind=c_int)           :: type
        integer(kind=c_unsigned_long) :: serial
        logical(kind=c_bool)          :: send_event
        type(c_ptr)                   :: display
        integer(kind=c_long)          :: window
        integer(kind=c_long)          :: colormap
        logical(kind=c_bool)          :: new
        integer(kind=c_int)           :: state
    end type x_colormap_event

    ! XClientMessageEvent
    type, bind(c) :: x_client_message_event
        integer(kind=c_int)           :: type
        integer(kind=c_unsigned_long) :: serial
        logical(kind=c_bool)          :: send_event
        type(c_ptr)                   :: display
        integer(kind=c_long)          :: window
        integer(kind=c_long)          :: message_type
        integer(kind=c_int)           :: format
        type(c_ptr)                   :: data
    end type x_client_message_event

    ! XMappingEvent
    type, bind(c) :: x_mapping_event
        integer(kind=c_int)           :: type
        integer(kind=c_unsigned_long) :: serial
        logical(kind=c_bool)          :: send_event
        type(c_ptr)                   :: display
        integer(kind=c_long)          :: window
        integer(kind=c_int)           :: request
        integer(kind=c_int)           :: first_keycode
        integer(kind=c_int)           :: count
    end type x_mapping_event

    ! XErrorEvent
    type, bind(c) :: x_error_event
        integer(kind=c_int)             :: type
        type(c_ptr)                     :: display
        integer(kind=c_unsigned_long)   :: serial
        character(kind=c_unsigned_char) :: error_code
        character(kind=c_unsigned_char) :: request_code
        character(kind=c_unsigned_char) :: minor_code
        integer(kind=c_long)            :: resource_id
    end type x_error_event

    ! XKeymapEvent
    type, bind(c) :: x_keymap_event
        integer(kind=c_int)           :: type
        integer(kind=c_unsigned_long) :: serial
        logical(kind=c_bool)          :: send_event
        type(c_ptr)                   :: display
        integer(kind=c_long)          :: window
        character(kind=c_char)        :: key_vector(32)
    end type x_keymap_event

    ! XEvent
    type, bind(c) :: x_event
        integer(kind=c_int)             :: type
        type(x_any_event)               :: x_any
        type(x_key_event)               :: x_key
        type(x_button_event)            :: x_button
        type(x_motion_event)            :: x_motion
        type(x_crossing_event)          :: x_crossing
        type(x_focus_change_event)      :: x_focus
        type(x_expose_event)            :: x_expose
        type(x_graphics_expose_event)   :: x_graphics_expose
        type(x_no_expose_event)         :: x_no_expose
        type(x_visibility_event)        :: x_visibility
        type(x_create_window_event)     :: x_create_window
        type(x_destroy_window_event)    :: x_destroy_window
        type(x_unmap_event)             :: x_unmap
        type(x_map_event)               :: x_map
        type(x_map_request_event)       :: x_map_request
        type(x_reparent_event)          :: x_reparent
        type(x_configure_event)         :: x_configure
        type(x_gravity_event)           :: x_gravity
        type(x_resize_request_event)    :: x_resize_request
        type(x_configure_request_event) :: x_configure_request
        type(x_circulate_event)         :: x_circulate
        type(x_circulate_request_event) :: x_circulate_request
        type(x_property_event)          :: x_property
        type(x_selection_clear_event)   :: x_selection_clear
        type(x_selection_request_event) :: x_selection_request
        type(x_selection_event)         :: x_selection
        type(x_colormap_event)          :: x_colormap
        type(x_client_message_event)    :: x_client_message
        type(x_mapping_event)           :: x_mapping
        type(x_error_event)             :: x_error
        type(x_keymap_event)            :: x_keymap
        integer(kind=c_long)            :: pad(24)
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

    ! XPoint
    type, bind(c) :: x_point
        integer(kind=c_short) :: x
        integer(kind=c_short) :: y
    end type x_point

    ! XCharStruct
    type, bind(c) :: x_char_struct
        integer(kind=c_short) :: lbearing
        integer(kind=c_short) :: rbearing
        integer(kind=c_short) :: width
        integer(kind=c_short) :: ascent
        integer(kind=c_short) :: descent
        integer(kind=c_short) :: attributes
    end type x_char_struct

    ! XFontStruct
    type, bind(c) :: x_font_struct
        type(c_ptr)          :: ext_data
        integer(kind=c_long) :: fid
        integer(kind=c_int)  :: direction
        integer(kind=c_int)  :: min_char_or_byte2
        integer(kind=c_int)  :: max_char_or_byte2
        integer(kind=c_int)  :: min_byte1
        integer(kind=c_int)  :: max_byte1
        logical(kind=c_bool) :: all_chars_exist
        integer(kind=c_int)  :: default_char
        integer(kind=c_int)  :: n_properties
        type(c_ptr)          :: properties
        type(x_char_struct)  :: min_bounds
        type(x_char_struct)  :: max_bounds
        type(c_ptr)          :: per_char
        integer(kind=c_int)  :: ascent
        integer(kind=c_int)  :: descent
    end type x_font_struct

    type, bind(c) :: funcs
        type(c_funptr) :: create_image
        type(c_funptr) :: destroy_image
        type(c_funptr) :: get_pixel
        type(c_funptr) :: put_pixel
        type(c_funptr) :: sub_image
        type(c_funptr) :: add_pixel
    end type funcs

    ! XImage
    type, bind(c) :: x_image
        integer(kind=c_int)  :: width
        integer(kind=c_int)  :: height
        integer(kind=c_int)  :: xoffset
        integer(kind=c_int)  :: format
        type(c_ptr)          :: data
        integer(kind=c_int)  :: byte_order
        integer(kind=c_int)  :: bitmap_unit
        integer(kind=c_int)  :: bitmap_bit_order
        integer(kind=c_int)  :: bitmap_pad
        integer(kind=c_int)  :: depth
        integer(kind=c_int)  :: bytes_per_line
        integer(kind=c_int)  :: bits_per_pixel
        integer(kind=c_long) :: red_mask
        integer(kind=c_long) :: green_mask
        integer(kind=c_long) :: blue_mask
        type(c_ptr)          :: obdata
        type(funcs)          :: f
    end type x_image

    ! C bindings.
    public :: x_alloc_named_color
    public :: x_alloc_size_hints
    public :: x_black_pixel
    public :: x_create_gc
    public :: x_create_image_
    public :: x_create_pixmap
    public :: x_create_simple_window
    public :: x_default_colormap
    public :: x_default_depth
    public :: x_default_visual
    public :: x_default_root_window
    public :: x_default_screen
    public :: x_get_pixel
    public :: x_init_threads
    public :: x_intern_atom
    public :: x_load_query_font_
    public :: x_open_display
    public :: x_pending
    public :: x_set_wm_protocols
    public :: x_white_pixel
    public :: x_clear_window
    public :: x_close_display
    public :: x_copy_area
    public :: x_destroy_image
    public :: x_destroy_window
    public :: x_draw_arc
    public :: x_draw_line
    public :: x_draw_point
    public :: x_draw_rectangle
    public :: x_draw_string
    public :: x_fill_arc
    public :: x_fill_polygon
    public :: x_fill_rectangle
    public :: x_flush
    public :: x_free
    public :: x_free_colors
    public :: x_free_font
    public :: x_free_gc
    public :: x_free_pixmap
    public :: x_map_window
    public :: x_next_event_
    public :: x_put_image
    public :: x_put_pixel
    public :: x_resize_window
    public :: x_select_input
    public :: x_set_background
    public :: x_set_clip_mask
    public :: x_set_clip_origin
    public :: x_set_fill_style
    public :: x_set_font
    public :: x_set_foreground
    public :: x_set_line_attributes
    public :: x_set_stipple
    public :: x_set_ts_origin
    public :: x_set_wm_normal_hints
    public :: x_store_name
    public :: x_sync
    public :: x_text_extents
    public :: x_unload_font

    ! Wrapper functions and routines.
    public :: x_create_image
    public :: x_load_query_font
    public :: x_next_event

    interface
        ! Status XAllocNamedColor(Display *display, Colormap colormap, char *color_name, XColor *screen_def_return, XColor *exact_def_return)
        function x_alloc_named_color(display, colormap, color_name, screen_def_return, exact_def_return) &
                bind(c, name='XAllocNamedColor')
            import :: c_char, c_int, c_long, c_ptr, x_color
            type(c_ptr),            intent(in), value :: display
            integer(kind=c_long),   intent(in), value :: colormap
            character(kind=c_char), intent(in)        :: color_name
            type(x_color),          intent(inout)     :: screen_def_return
            type(x_color),          intent(inout)     :: exact_def_return
            integer(kind=c_int)                       :: x_alloc_named_color
        end function x_alloc_named_color

        ! void XSizeHints *XAllocSizeHints()
        function x_alloc_size_hints() bind(c, name='XAllocSizeHints')
            import :: x_size_hints
            type(x_size_hints) :: x_alloc_size_hints
        end function x_alloc_size_hints

        ! unsigned long XBlackPixel(Display *display, int screen_number)
        function x_black_pixel(display, screen_number) bind(c, name='XBlackPixel')
            import :: c_int, c_long, c_ptr
            type(c_ptr),         intent(in), value :: display
            integer(kind=c_int), intent(in), value :: screen_number
            integer(kind=c_long)                   :: x_black_pixel
        end function x_black_pixel

        ! GC XCreateGC(Display *display, Drawable d, unsigned long valuemask, XGCValues *values)
        function x_create_gc(display, d, value_mask, values) bind(c, name='XCreateGC')
            import :: c_int, c_long, c_ptr, x_gc_values
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: d
            integer(kind=c_int),  intent(in), value :: value_mask
            type(x_gc_values),    intent(in)        :: values
            type(c_ptr)                             :: x_create_gc
        end function x_create_gc

        ! void XImage *XCreateImage(Display *display, Visual *visual, int depth, int format, int offset, char *data, int width, int height, int bitmap_pad, int bytes_per_line)
        function x_create_image_(display, visual, depth, format, offset, data, width, height, bitmap_pad, bytes_per_line) &
                bind(c, name='XCreateImage')
            import :: c_char, c_int, c_ptr
            type(c_ptr),            intent(in), value :: display
            type(c_ptr),            intent(in), value :: visual
            integer(kind=c_int),    intent(in), value :: depth
            integer(kind=c_int),    intent(in), value :: format
            integer(kind=c_int),    intent(in), value :: offset
            character(kind=c_char), intent(in)        :: data
            integer(kind=c_int),    intent(in), value :: width
            integer(kind=c_int),    intent(in), value :: height
            integer(kind=c_int),    intent(in), value :: bitmap_pad
            integer(kind=c_int),    intent(in), value :: bytes_per_line
            type(c_ptr)                               :: x_create_image_
        end function x_create_image_

        ! Pixmap XCreatePixmap(Display *display, Drawable d, unsigned int width, unsigned int height, unsigned int depth)
        function x_create_pixmap(display, d, width, height, depth) bind(c, name='XCreatePixmap')
            import :: c_int, c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: d
            integer(kind=c_int),  intent(in), value :: width
            integer(kind=c_int),  intent(in), value :: height
            integer(kind=c_int),  intent(in), value :: depth
            integer(kind=c_long)                    :: x_create_pixmap
        end function x_create_pixmap

        ! Window XCreateSimpleWindow(Display *display, Window parent, int x, int y, unsigned int width, unsigned int height, unsigned int border_width, unsigned long border, unsigned long background)
        function x_create_simple_window(display, parent, x, y, width, height, border_width, border, background) &
                bind(c, name='XCreateSimpleWindow')
            import :: c_int, c_long, c_ptr
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

        ! Colormap XDefaultColormap(Display *display, int screen_number)
        function x_default_colormap(display, screen_number) bind(c, name='XDefaultColormap')
            import :: c_int, c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_int),  intent(in), value :: screen_number
            integer(kind=c_long)                    :: x_default_colormap
        end function x_default_colormap

        ! int XDefaultDepth(Display *display, int screen_number)
        function x_default_depth(display, screen_number) bind(c, name='XDefaultDepth')
            import :: c_int, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_int),  intent(in), value :: screen_number
            integer(kind=c_int)                     :: x_default_depth
        end function x_default_depth

        ! Visual *XDefaultVisual(Display *display, int screen_number)
        function x_default_visual(display, screen_number) bind(c, name='XDefaultVisual')
            import :: c_int, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_int),  intent(in), value :: screen_number
            type(c_ptr)                             :: x_default_visual
        end function x_default_visual

        ! Window XDefaultRootWindow(Display *display)
        function x_default_root_window(display) bind(c, name='XDefaultRootWindow')
            import :: c_long, c_ptr
            type(c_ptr), intent(in), value :: display
            integer(kind=c_long)           :: x_default_root_window
        end function x_default_root_window

        ! int XDefaultScreen(Display *display)
        function x_default_screen(display) bind(c, name='XDefaultScreen')
            import :: c_int, c_ptr
            type(c_ptr), intent(in), value :: display
            integer(kind=c_int)            :: x_default_screen
        end function x_default_screen

        ! unsigned long XGetPixel(XImage *ximage, int x, int y)
        function x_get_pixel(ximage, x, y) bind(c, name='XGetPixel')
            import :: c_int, c_long, x_image
            type(x_image),       intent(in)        :: ximage
            integer(kind=c_int), intent(in), value :: x
            integer(kind=c_int), intent(in), value :: y
            integer(kind=c_long)                   :: x_get_pixel
        end function x_get_pixel

        ! Status XInitThreads()
        function x_init_threads() bind(c, name='XInitThreads')
            import :: c_int
            integer(c_int) :: x_init_threads
        end function

        ! Atom XInternAtom(Display *display, char *atom_name, Bool only_if_exists)
        function x_intern_atom(display, atom_name, only_if_exists) bind(c, name='XInternAtom')
            import :: c_bool, c_char, c_long, c_ptr
            type(c_ptr),            intent(in), value :: display
            character(kind=c_char), intent(in)        :: atom_name
            logical(kind=c_bool),   intent(in), value :: only_if_exists
            integer(kind=c_long)                      :: x_intern_atom
        end function x_intern_atom

        ! void XFontStruct *XLoadQueryFont(Display *display, char *name)
        function x_load_query_font_(display, name) bind(c, name='XLoadQueryFont')
            import :: c_char, c_ptr
            type(c_ptr),            intent(in), value :: display
            character(kind=c_char), intent(in)        :: name
            type(c_ptr)                               :: x_load_query_font_
        end function x_load_query_font_

        ! Display *XOpenDisplay (char *display_name)
        function x_open_display(display_name) bind(c, name='XOpenDisplay')
            import :: c_char, c_ptr
            character(kind=c_char), intent(in) :: display_name
            type(c_ptr)                        :: x_open_display
        end function x_open_display

        ! int XPending(Display *display)
        function x_pending(display) bind(c, name='XPending')
            import :: c_int, c_ptr
            type(c_ptr), intent(in), value :: display
            integer(kind=c_int)            :: x_pending
        end function x_pending

        ! Status XSetWMProtocols(Display *display, Window w, Atom *protocols, int count)
        function x_set_wm_protocols(display, w, protocols, count) bind(c, name='XSetWMProtocols')
            import :: c_int, c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: w
            integer(kind=c_long), intent(in)        :: protocols
            integer(kind=c_int),  intent(in), value :: count
            integer(kind=c_int)                     :: x_set_wm_protocols
        end function x_set_wm_protocols

        ! unsigned long XWhitePixel(Display *display, int screen_number)
        function x_white_pixel(display, screen_number) bind(c, name='XWhitePixel')
            import :: c_int, c_long, c_ptr
            type(c_ptr),         intent(in), value :: display
            integer(kind=c_int), intent(in), value :: screen_number
            integer(kind=c_long)                   :: x_white_pixel
        end function x_white_pixel

        ! void XClearWindow(Display *display, Window w)
        subroutine x_clear_window(display, w) bind(c, name='XClearWindow')
            import :: c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: w
        end subroutine x_clear_window

        ! void XCloseDisplay(Display *display)
        subroutine x_close_display(display) bind(c, name='XCloseDisplay')
            import :: c_ptr
            type(c_ptr), intent(in), value :: display
        end subroutine x_close_display

        ! void XCopyArea(Display *display, Drawable src, Drawable dest, GC gc, int src_x, int src_y, unsigned int width, unsigned int height, int dest_x, int dest_y)
        subroutine x_copy_area(display, src, dest, gc, src_x, src_y, width, height, dest_x, dest_y) &
                bind(c, name='XCopyArea')
            import :: c_int, c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: src
            integer(kind=c_long), intent(in), value :: dest
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_int),  intent(in), value :: src_x
            integer(kind=c_int),  intent(in), value :: src_y
            integer(kind=c_int),  intent(in), value :: width
            integer(kind=c_int),  intent(in), value :: height
            integer(kind=c_int),  intent(in), value :: dest_x
            integer(kind=c_int),  intent(in), value :: dest_y
        end subroutine x_copy_area

        ! void XDestroyImage(XImage *ximage)
        subroutine x_destroy_image(ximage) bind(c, name='XDestroyImage')
            import :: x_image
            type(x_image), intent(in) :: ximage
        end subroutine x_destroy_image

        ! void XDestroyWindow(Display *display; Window w)
        subroutine x_destroy_window(display, w) bind(c, name='XDestroyWindow')
            import :: c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: w
        end subroutine x_destroy_window

        ! void XDrawArc(Display *display, Drawable d, GC gc, int x, int y, unsigned int width, unsigned int height, int angle1, int angle2)
        subroutine x_draw_arc(display, d, gc, x, y, width, height, angle1, angle2) bind(c, name='XDrawArc')
            import :: c_int, c_long, c_ptr
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

        ! void XDrawLine(Display *display, Drawable d, GC gc, int x1, int y1, int x2, int y2)
        subroutine x_draw_line(display, d, gc, x1, y1, x2, y2) bind(c, name='XDrawLine')
            import :: c_int, c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: d
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_int),  intent(in), value :: x1
            integer(kind=c_int),  intent(in), value :: y1
            integer(kind=c_int),  intent(in), value :: x2
            integer(kind=c_int),  intent(in), value :: y2
        end subroutine x_draw_line

        ! void XDrawPoint(Display *display, Drawable d, GC gc, int x, int y)
        subroutine x_draw_point(display, d, gc, x, y) bind(c, name='XDrawPoint')
            import :: c_int, c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: d
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_int),  intent(in), value :: x
            integer(kind=c_int),  intent(in), value :: y
        end subroutine x_draw_point

        ! void XDrawRectangle(Display *display, Drawable d, GC gc, int x, int y, unsigned int width, unsigned int height)
        subroutine x_draw_rectangle(display, d, gc, x, y, width, height) bind(c, name='XDrawRectangle')
            import :: c_int, c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: d
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_int),  intent(in), value :: x
            integer(kind=c_int),  intent(in), value :: y
            integer(kind=c_int),  intent(in), value :: width
            integer(kind=c_int),  intent(in), value :: height
        end subroutine x_draw_rectangle

        ! void XDrawString(Display *display, Drawable d, GC gc, int x, int y, char *string, int length)
        subroutine x_draw_string(display, d, gc, x, y, string, length) bind(c, name='XDrawString')
            import :: c_char, c_int, c_long, c_ptr
            type(c_ptr),            intent(in), value :: display
            integer(kind=c_long),   intent(in), value :: d
            type(c_ptr),            intent(in), value :: gc
            integer(kind=c_int),    intent(in), value :: x
            integer(kind=c_int),    intent(in), value :: y
            character(kind=c_char), intent(in)        :: string
            integer(kind=c_int),    intent(in), value :: length
        end subroutine x_draw_string

        ! void XFillArc(Display *display, Drawable d, GC gc, int x, int y, unsigned int width, unsigned int height, int angle1, int angle2)
        subroutine x_fill_arc(display, d, gc, x, y, width, height, angle1, angle2) bind(c, name='XFillArc')
            import :: c_int, c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: d
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_int),  intent(in), value :: x
            integer(kind=c_int),  intent(in), value :: y
            integer(kind=c_int),  intent(in), value :: width
            integer(kind=c_int),  intent(in), value :: height
            integer(kind=c_int),  intent(in), value :: angle1
            integer(kind=c_int),  intent(in), value :: angle2
        end subroutine x_fill_arc

        ! void XFillPolygon(Display *display, Drawable d, GC gc, XPoint *points, int npoints, int shape, int mode)
        subroutine x_fill_polygon(display, d, gc, points, npoints, shape, mode) bind(c, name='XFillPolygon')
            import :: c_int, c_long, c_ptr, x_point
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: d
            type(c_ptr),          intent(in), value :: gc
            type(x_point),        intent(in)        :: points(*)
            integer(kind=c_int),  intent(in), value :: npoints
            integer(kind=c_int),  intent(in), value :: shape
            integer(kind=c_int),  intent(in), value :: mode
        end subroutine x_fill_polygon

        ! void XFillRectangle(Display *display, Drawable d, GC gc, int x, int y, unsigned int width, unsigned int height)
        subroutine x_fill_rectangle(display, d, gc, x, y, width, height) bind(c, name='XFillRectangle')
            import :: c_int, c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: d
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_int),  intent(in), value :: x
            integer(kind=c_int),  intent(in), value :: y
            integer(kind=c_int),  intent(in), value :: width
            integer(kind=c_int),  intent(in), value :: height
        end subroutine x_fill_rectangle

        ! void XFlush(Display *display)
        subroutine x_flush(display) bind(c, name='XFlush')
            import :: c_ptr
            type(c_ptr), intent(in), value :: display
        end subroutine x_flush

        ! void XFree(void *data)
        subroutine x_free(data) bind(c, name='XFree')
            import :: c_ptr
            type(c_ptr), intent(in), value :: data
        end subroutine x_free

        ! void XFreeColors(Display *display, Colormap colormap, unsigned long pixels[], int npixels, unsigned long planes)
        subroutine x_free_colors(display, colormap, pixels, npixels, planes) bind(c, name='XFreeColors')
            import :: c_int, c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: colormap
            integer(kind=c_long), intent(in)        :: pixels(*)
            integer(kind=c_int),  intent(in), value :: npixels
            integer(kind=c_long), intent(in), value :: planes
        end subroutine x_free_colors

        ! void XFreeFont(Display *display, XFontStruct font_struct)
        subroutine x_free_font(display, font_struct) bind(c, name='XFreeFont')
            import :: c_ptr, x_font_struct
            type(c_ptr),         intent(in), value :: display
            type(x_font_struct), intent(in)        :: font_struct
        end subroutine x_free_font

        ! void XFreeGC(Display *display, GC gc)
        subroutine x_free_gc(display, gc) bind(c, name='XFreeGC')
            import :: c_ptr
            type(c_ptr), intent(in), value :: display
            type(c_ptr), intent(in), value :: gc
        end subroutine x_free_gc

        ! void XFreePixmap(Display *display, Pixmap pixmap)
        subroutine x_free_pixmap(display, pixmap) bind(c, name='XFreePixmap')
            import :: c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: pixmap
        end subroutine x_free_pixmap

        ! void XMapWindow(Display *display, Window w)
        subroutine x_map_window(display, w) bind(c, name='XMapWindow')
            import :: c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: w
        end subroutine

        ! void XNextEvent(Display *display, XEvent *event_return)
        subroutine x_next_event_(display, event_return) bind(c, name='XNextEvent')
            import :: c_ptr, x_event
            type(c_ptr),   intent(in), value :: display
            type(x_event), intent(inout)     :: event_return
        end subroutine x_next_event_

        ! void XPutImage(Display *display, Drawable d, GC gc, XImage *image, int src_x, int src_y, int dest_x, int dest_y, int width, int height)
        subroutine x_put_image(display, d, gc, image, src_x, src_y, dest_x, dest_y, width, height) &
                bind(c, name='XPutImage')
            import :: c_int, c_long, c_ptr, x_image
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: d
            type(c_ptr),          intent(in), value :: gc
            type(x_image),        intent(in)        :: image
            integer(kind=c_int),  intent(in), value :: src_x
            integer(kind=c_int),  intent(in), value :: src_y
            integer(kind=c_int),  intent(in), value :: dest_x
            integer(kind=c_int),  intent(in), value :: dest_y
            integer(kind=c_int),  intent(in), value :: width
            integer(kind=c_int),  intent(in), value :: height
        end subroutine x_put_image

        ! void XPutPixel(XImage* ximage, int x, int y, unsigned long pixel)
        subroutine x_put_pixel(ximage, x, y, pixel) bind(c, name='XPutPixel')
            import :: c_int, c_long, x_image
            type(x_image),        intent(in)        :: ximage
            integer(kind=c_int),  intent(in), value :: x
            integer(kind=c_int),  intent(in), value :: y
            integer(kind=c_long), intent(in), value :: pixel
        end subroutine x_put_pixel

        ! void XResizeWindow(Display *display, Window w, unsigned int width, unsigned int height)
        subroutine x_resize_window(display, w, width, height) bind(c, name='XResizeWindow')
            import :: c_int, c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: w
            integer(kind=c_int),  intent(in), value :: width
            integer(kind=c_int),  intent(in), value :: height
        end subroutine x_resize_window

        ! void XSelectInput(Display *display, Window w, long event_mask)
        subroutine x_select_input(display, w, event_mask) bind(c, name='XSelectInput')
            import :: c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: w
            integer(kind=c_long), intent(in), value :: event_mask
        end subroutine

        ! void XSetBackground(Display *display, GC gc, unsigned long background)
        subroutine x_set_background(display, gc, background) bind(c, name='XSetBackground')
            import :: c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_long), intent(in), value :: background
        end subroutine x_set_background

        ! void XSetClipMask(Display *display, GC gc, Pixmap pixmap)
        subroutine x_set_clip_mask(display, gc, pixmap) bind(c, name='XSetClipMask')
            import :: c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_long), intent(in), value :: pixmap
        end subroutine x_set_clip_mask

        ! void XSetClipOrigin(Display *display, GC gc, int clip_x_origin, int clip_y_origin)
        subroutine x_set_clip_origin(display, gc, clip_x_origin, clip_y_origin) bind(c, name='XSetClipOrigin')
            import :: c_int, c_ptr
            type(c_ptr),         intent(in), value :: display
            type(c_ptr),         intent(in), value :: gc
            integer(kind=c_int), intent(in), value :: clip_x_origin
            integer(kind=c_int), intent(in), value :: clip_y_origin
        end subroutine x_set_clip_origin

        ! void XSetFillStyle(Display *display, GC gc, int fill_style)
        subroutine x_set_fill_style(display, gc, fill_style) bind(c, name='XSetFillStyle')
            import :: c_int, c_ptr
            type(c_ptr),         intent(in), value :: display
            type(c_ptr),         intent(in), value :: gc
            integer(kind=c_int), intent(in), value :: fill_style
        end subroutine x_set_fill_style

        ! void XSetFont(Display *display, GC gc, Font font)
        subroutine x_set_font(display, gc, font) bind(c, name='XSetFont')
            import :: c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_long), intent(in), value :: font
        end subroutine x_set_font

        ! void XSetForeground(Display *display, GC gc, unsigned long foreground)
        subroutine x_set_foreground(display, gc, foreground) bind(c, name='XSetForeground')
            import :: c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_long), intent(in), value :: foreground
        end subroutine x_set_foreground

        ! void XSetLineAttributes(Display *display, GC gc, unsigned int line_width, int line_style, int cap_style, int join_style)
        subroutine x_set_line_attributes(display, gc, line_width, line_style, cap_style, join_style) &
                bind(c, name='XSetLineAttributes')
            import :: c_int, c_ptr
            type(c_ptr),         intent(in), value :: display
            type(c_ptr),         intent(in), value :: gc
            integer(kind=c_int), intent(in), value :: line_width
            integer(kind=c_int), intent(in), value :: line_style
            integer(kind=c_int), intent(in), value :: cap_style
            integer(kind=c_int), intent(in), value :: join_style
        end subroutine x_set_line_attributes

        ! void XSetStipple(Display *display, GC gc, Pixmap stipple)
        subroutine x_set_stipple(display, gc, stipple) bind(c, name='XSetStipple')
            import :: c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            type(c_ptr),          intent(in), value :: gc
            integer(kind=c_long), intent(in), value :: stipple
        end subroutine x_set_stipple

        ! void XSetTSOrigin(Display *display, GC gc, int ts_x_origin, int ts_y_origin)
        subroutine x_set_ts_origin(display, gc, ts_x_origin, ts_y_origin) bind(c, name='XSetTSOrigin')
            import :: c_int, c_ptr
            type(c_ptr),         intent(in), value :: display
            type(c_ptr),         intent(in), value :: gc
            integer(kind=c_int), intent(in), value :: ts_x_origin
            integer(kind=c_int), intent(in), value :: ts_y_origin
        end subroutine x_set_ts_origin

        ! void XSetWMNormalHints(Display *display, Window w, XSizeHints *hints)
        subroutine x_set_wm_normal_hints(display, w, hints) bind(c, name='XSetWMNormalHints')
            import :: c_long, c_ptr, x_size_hints
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long), intent(in), value :: w
            type(x_size_hints),   intent(in)        :: hints
        end subroutine x_set_wm_normal_hints

        ! void XStoreName(Display *display, Window w, char *window_name)
        subroutine x_store_name(display, w, window_name) bind(c, name='XStoreName')
            import :: c_char, c_long, c_ptr
            type(c_ptr),            intent(in), value :: display
            integer(kind=c_long),   intent(in), value :: w
            character(kind=c_char), intent(in)        :: window_name
        end subroutine x_store_name

        ! void XSync(Display *display, Bool discard)
        subroutine x_sync(display, discard) bind(c, name='XSync')
            import :: c_bool, c_ptr
            type(c_ptr),          intent(in), value :: display
            logical(kind=c_bool), intent(in), value :: discard
        end subroutine

        ! void XTextExtents(XFontStruct *font_struct, char *string, int nchars, int *direction_return, int *font_ascent_return, int *font_descrent_return, XCharStruct *overall_return)
        subroutine x_text_extents(font_struct, string, nchars, direction_return, font_ascent_return, &
                font_descent_return, overall_return) bind(c, name='XTextExtents')
            import :: c_char, c_int, x_char_struct, x_font_struct
            type(x_font_struct)           :: font_struct
            character(kind=c_char)        :: string
            integer(kind=c_int),    value :: nchars
            integer(kind=c_int)           :: direction_return
            integer(kind=c_int)           :: font_ascent_return
            integer(kind=c_int)           :: font_descent_return
            type(x_char_struct)           :: overall_return
        end subroutine x_text_extents

        ! void XUnloadFont(Display *display, Font font)
        subroutine x_unload_font(display, font) bind(c, name='XUnloadFont')
            import :: c_long, c_ptr
            type(c_ptr),          intent(in), value :: display
            integer(kind=c_long)                    :: font
        end subroutine x_unload_font
    end interface
contains
    function x_create_image(display, visual, depth, format, offset, data, width, height, bitmap_pad, bytes_per_line)
        type(c_ptr),            intent(in), value :: display
        type(c_ptr),            intent(in), value :: visual
        integer(kind=c_int),    intent(in), value :: depth
        integer(kind=c_int),    intent(in), value :: format
        integer(kind=c_int),    intent(in), value :: offset
        character(kind=c_char), intent(in)        :: data
        integer(kind=c_int),    intent(in), value :: width
        integer(kind=c_int),    intent(in), value :: height
        integer(kind=c_int),    intent(in), value :: bitmap_pad
        integer(kind=c_int),    intent(in), value :: bytes_per_line
        type(c_ptr)                               :: ptr
        type(x_image), pointer                    :: x_create_image

        ptr = x_create_image_(display, visual, depth, format, offset, data, width, height, bitmap_pad, bytes_per_line)
        call c_f_pointer(ptr, x_create_image)
    end function x_create_image

    function x_load_query_font(display, name)
        !! Returns XFontStruct from C pointer.
        type(c_ptr),            intent(in), value :: display
        character(kind=c_char), intent(in)        :: name
        type(c_ptr)                               :: ptr
        type(x_font_struct), pointer              :: x_load_query_font

        ptr = x_load_query_font_(display, name)
        call c_f_pointer(ptr, x_load_query_font)
    end function x_load_query_font

    subroutine x_next_event(display, event_return)
        type(c_ptr),   intent(in)    :: display
        type(x_event), intent(inout) :: event_return

        call x_next_event_(display, event_return)

        select case (event_return%type)
            case (button_press)     ! XButtonEvent
                event_return%x_button = transfer(event_return, event_return%x_button)

            case (button_release)   ! XButtonEvent
                event_return%x_button = transfer(event_return, event_return%x_button)

            case (client_message)   ! XClientMessageEvent
                event_return%x_client_message = transfer(event_return, event_return%x_client_message)

            case (configure_notify) ! XConfigureNotifyEvent
                event_return%x_configure = transfer(event_return, event_return%x_configure)

            case (expose)           ! XExposeEvent
                event_return%x_expose = transfer(event_return, event_return%x_expose)

            case (key_press)        ! XKeyEvent
                event_return%x_key = transfer(event_return, event_return%x_key)

            case (key_release)      ! XKeyEvent
                event_return%x_key = transfer(event_return, event_return%x_key)

            case (motion_notify)    ! XMotionEvent
                event_return%x_motion= transfer(event_return, event_return%x_motion)
        end select
    end subroutine x_next_event
end module xlib
