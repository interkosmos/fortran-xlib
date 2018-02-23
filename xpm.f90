! xpm.f90
!
! Interface to XPM for Fortran 2003/2008.
!
! Author:  Philipp Engel
! Licence: ISC
module xpm
    use, intrinsic :: iso_c_binding
    implicit none

    interface
        ! int XpmReadFileToPixmap(Display *display, Drawable d, char *filename, Pixmap *pixmap_return, Pixmap *shapemask_return, XpmAttributes *attributes)
        function xpm_read_file_to_pixmap(display, d, file_name, pixmap_return, shapemask_return, attributes) &
                bind(c, name='XpmReadFileToPixmap')
            use, intrinsic :: iso_c_binding
            implicit none
            type(c_ptr),            intent(in), value :: display
            integer(kind=c_long),   intent(in), value :: d
            character(kind=c_char), intent(in)        :: file_name
            integer(kind=c_long),   intent(out)       :: pixmap_return
            integer(kind=c_long),   intent(out)       :: shapemask_return
            type(c_ptr),            intent(in)        :: attributes                 ! TODO
            integer(kind=c_int)                       :: xpm_read_file_to_pixmap
        end function xpm_read_file_to_pixmap
    end interface
end module xpm
