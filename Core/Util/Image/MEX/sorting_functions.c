//--
// DOUBLE SORTING FUNCTIONS
//--

//--
// MACROS
//--

#define ELEM_SWAP_D(a,b) { double temp = (a);(a) = (b);(b) = temp; }
#define ELEM_SORT_D(a,b) { if ((a) > (b)) ELEM_SWAP_D((a),(b)); }

//--
// FUNCTIONS
//--


/*---------------------------------------------------------------------------
   Function :   kth_smallest_double()
   In       :   array of elements, # of elements in the array, rank k
   Out      :   one element
   Job      :   find the kth smallest element in the array
   Notice   :   use the median() macro defined below to get the median. 

                Reference:

                  Author: Wirth, Niklaus 
                   Title: Algorithms + data structures = programs 
               Publisher: Englewood Cliffs: Prentice-Hall, 1976 
    Physical description: 366 p. 
                  Series: Prentice-Hall Series in Automatic Computation 

 ---------------------------------------------------------------------------*/

double kth_smallest_double(double a[], int n, int k);

double kth_smallest_double(double a[], int n, int k)
{
     register int i,j,l,m ;
     double x ;

    l=0 ; m=n-1 ;
    while (l<m) {
        x=a[k] ;
        i=l ;
        j=m ;
        do {
            while (a[i]<x) i++ ;
            while (x<a[j]) j-- ;
            if (i<=j) {
                ELEM_SWAP_D(a[i],a[j]) ;
                i++ ; j-- ;
            }
        } while (i<=j) ;
        if (j<k) l=i ;
        if (k<i) m=j ;
    }
    return a[k] ;
}

#define median_double(a,n) kth_smallest_double(a,n,(((n)&1)?((n)/2):(((n)/2)-1)))


/*----------------------------------------------------------------------------
 * Function :   opt_med3_double()
 * In       :   pointer to array of 3 pixel values
 * Out      :   a double
 * Job      :   optimized search of the median of 3 pixel values
 * Notice   :   found on sci.image.processing
 *              cannot go faster unless assumptions are made
 *              on the nature of the input signal.
 *--------------------------------------------------------------------------*/

double
opt_med3_double(
    double  * p, int n
);

double
opt_med3_double(
    double  * p, int n
)
{
    ELEM_SORT_D(p[0],p[1]) ; ELEM_SORT_D(p[1],p[2]) ; ELEM_SORT_D(p[0],p[1]) ;
    return(p[1]) ;
}


/*----------------------------------------------------------------------------
 * Function :   opt_med5_double()
 * In       :   pointer to array of 5 pixel values
 * Out      :   a double
 * Job      :   optimized search of the median of 5 pixel values
 * Notice   :   found on sci.image.processing
 *              cannot go faster unless assumptions are made
 *              on the nature of the input signal.
 *--------------------------------------------------------------------------*/

double
opt_med5_double(
    double  * p, int n
);

double
opt_med5_double(
    double  * p, int n
)
{
    ELEM_SORT_D(p[0],p[1]) ; ELEM_SORT_D(p[3],p[4]) ; ELEM_SORT_D(p[0],p[3]) ;
    ELEM_SORT_D(p[1],p[4]) ; ELEM_SORT_D(p[1],p[2]) ; ELEM_SORT_D(p[2],p[3]) ;
    ELEM_SORT_D(p[1],p[2]) ; return(p[2]) ;
}


/*----------------------------------------------------------------------------
 * Function :   opt_med7_double()
 * In       :   pointer to array of 7 pixel values
 * Out      :   a double
 * Job      :   optimized search of the median of 7 pixel values
 * Notice   :   found on sci.image.processing
 *              cannot go faster unless assumptions are made
 *              on the nature of the input signal.
 *--------------------------------------------------------------------------*/

double
opt_med7_double(
    double  * p, int n
);

double
opt_med7_double(
    double  * p, int n
)
{
    ELEM_SORT_D(p[0], p[5]) ; ELEM_SORT_D(p[0], p[3]) ; ELEM_SORT_D(p[1], p[6]) ;
    ELEM_SORT_D(p[2], p[4]) ; ELEM_SORT_D(p[0], p[1]) ; ELEM_SORT_D(p[3], p[5]) ;
    ELEM_SORT_D(p[2], p[6]) ; ELEM_SORT_D(p[2], p[3]) ; ELEM_SORT_D(p[3], p[6]) ;
    ELEM_SORT_D(p[4], p[5]) ; ELEM_SORT_D(p[1], p[4]) ; ELEM_SORT_D(p[1], p[3]) ;
    ELEM_SORT_D(p[3], p[4]) ; return (p[3]) ;
}


/*----------------------------------------------------------------------------
 * Function :   opt_med9_double()
 * In       :   pointer to an array of 9 pixelvalues
 * Out      :   a double
 * Job      :   optimized search of the median of 9 pixelvalues
 * Notice   :   in theory, cannot go faster without assumptions on the
 *              signal.
 *              Formula from:
 *              XILINX XCELL magazine, vol. 23 by John L. Smith
 *
 *              The input array is modified in the process
 *              The result array is guaranteed to contain the median
 *              value
 *              in middle position, but other elements are NOT sorted.
 *--------------------------------------------------------------------------*/

double
opt_med9_double(
    double  * p, int n
);

double
opt_med9_double(
    double  * p, int n
)
{
    ELEM_SORT_D(p[1], p[2]) ; ELEM_SORT_D(p[4], p[5]) ; ELEM_SORT_D(p[7], p[8]) ;
    ELEM_SORT_D(p[0], p[1]) ; ELEM_SORT_D(p[3], p[4]) ; ELEM_SORT_D(p[6], p[7]) ;
    ELEM_SORT_D(p[1], p[2]) ; ELEM_SORT_D(p[4], p[5]) ; ELEM_SORT_D(p[7], p[8]) ;
    ELEM_SORT_D(p[0], p[3]) ; ELEM_SORT_D(p[5], p[8]) ; ELEM_SORT_D(p[4], p[7]) ;
    ELEM_SORT_D(p[3], p[6]) ; ELEM_SORT_D(p[1], p[4]) ; ELEM_SORT_D(p[2], p[5]) ;
    ELEM_SORT_D(p[4], p[7]) ; ELEM_SORT_D(p[4], p[2]) ; ELEM_SORT_D(p[6], p[4]) ;
    ELEM_SORT_D(p[4], p[2]) ; return(p[4]) ;
}


/*
 *  This Quickselect routine is based on the algorithm described in
 *  "Numerical recipies in C", Second Edition,
 *  Cambridge University Press, 1992, Section 8.5, ISBN 0-521-43108-5
 */

double quick_select_double (double arr[], int n);

double quick_select_double (double arr[], int n) 
{
    int low, high ;
    int median;
    int middle, ll, hh;

    low = 0 ; high = n-1 ; median = (low + high) / 2;
    for (;;) {
        if (high <= low) /* One element only */
            return arr[median] ;

        if (high == low + 1) {  /* Two elements only */
            if (arr[low] > arr[high])
                ELEM_SWAP_D(arr[low], arr[high]) ;
            return arr[median] ;
        }

    /* Find median of low, middle and high items; swap into position low */
    middle = (low + high) / 2;
    if (arr[middle] > arr[high])    ELEM_SWAP_D(arr[middle], arr[high]) ;
    if (arr[low] > arr[high])       ELEM_SWAP_D(arr[low], arr[high]) ;
    if (arr[middle] > arr[low])     ELEM_SWAP_D(arr[middle], arr[low]) ;

    /* Swap low item (now in position middle) into position (low+1) */
    ELEM_SWAP_D(arr[middle], arr[low+1]) ;

    /* Nibble from each end towards middle, swapping items when stuck */
    ll = low + 1;
    hh = high;
    for (;;) {
        do ll++; while (arr[low] > arr[ll]) ;
        do hh--; while (arr[hh]  > arr[low]) ;

        if (hh < ll)
        break;

        ELEM_SWAP_D(arr[ll], arr[hh]) ;
    }

    /* Swap middle item (in position low) back into correct position */
    ELEM_SWAP_D(arr[low], arr[hh]) ;

    /* Re-set active partition */
    if (hh <= median)
        low = ll;
        if (hh >= median)
        high = hh - 1;
    }
}

#undef ELEM_SORT_D
#undef ELEM_SWAP_D


//--
// UNSIGNED CHAR FUNCTIONS
//--

//--
// MACROS
//--

#define ELEM_SWAP_U8(a,b) { unsigned char temp = (a);(a) = (b);(b) = temp; }
#define ELEM_SORT_U8(a,b) { if ((a) > (b)) ELEM_SWAP_U8((a),(b)); }

//--
// FUNCTIONS
//--


/*---------------------------------------------------------------------------
   Function :   kth_smallest_uint8()
   In       :   array of elements, # of elements in the array, rank k
   Out      :   one element
   Job      :   find the kth smallest element in the array
   Notice   :   use the median() macro defined below to get the median. 

                Reference:

                  Author: Wirth, Niklaus 
                   Title: Algorithms + data structures = programs 
               Publisher: Englewood Cliffs: Prentice-Hall, 1976 
    Physical description: 366 p. 
                  Series: Prentice-Hall Series in Automatic Computation 

 ---------------------------------------------------------------------------*/

unsigned char kth_smallest_uint8(unsigned char a[], int n, int k);

unsigned char kth_smallest_uint8(unsigned char a[], int n, int k)
{
     register int i,j,l,m ;
     unsigned char x ;

    l=0 ; m=n-1 ;
    while (l<m) {
        x=a[k] ;
        i=l ;
        j=m ;
        do {
            while (a[i]<x) i++ ;
            while (x<a[j]) j-- ;
            if (i<=j) {
                ELEM_SWAP_U8(a[i],a[j]) ;
                i++ ; j-- ;
            }
        } while (i<=j) ;
        if (j<k) l=i ;
        if (k<i) m=j ;
    }
    return a[k] ;
}

#define median_uint8(a,n) kth_smallest_uint8(a,n,(((n)&1)?((n)/2):(((n)/2)-1)))


/*----------------------------------------------------------------------------
 * Function :   opt_med3_uint8()
 * In       :   pointer to array of 3 pixel values
 * Out      :   a unsigned char
 * Job      :   optimized search of the median of 3 pixel values
 * Notice   :   found on sci.image.processing
 *              cannot go faster unless assumptions are made
 *              on the nature of the input signal.
 *--------------------------------------------------------------------------*/

unsigned char
opt_med3_uint8(
    unsigned char  *p, int n
);

unsigned char
opt_med3_uint8(
    unsigned char  *p, int n
)
{
    ELEM_SORT_U8(p[0],p[1]) ; ELEM_SORT_U8(p[1],p[2]) ; ELEM_SORT_U8(p[0],p[1]) ;
    return(p[1]) ;
}


/*----------------------------------------------------------------------------
 * Function :   opt_med5_uint8()
 * In       :   pointer to array of 5 pixel values
 * Out      :   a unsigned char
 * Job      :   optimized search of the median of 5 pixel values
 * Notice   :   found on sci.image.processing
 *              cannot go faster unless assumptions are made
 *              on the nature of the input signal.
 *--------------------------------------------------------------------------*/

unsigned char
opt_med5_uint8(
    unsigned char  *p, int n
);

unsigned char
opt_med5_uint8(
    unsigned char  *p, int n
)
{
    ELEM_SORT_U8(p[0],p[1]) ; ELEM_SORT_U8(p[3],p[4]) ; ELEM_SORT_U8(p[0],p[3]) ;
    ELEM_SORT_U8(p[1],p[4]) ; ELEM_SORT_U8(p[1],p[2]) ; ELEM_SORT_U8(p[2],p[3]) ;
    ELEM_SORT_U8(p[1],p[2]) ; return(p[2]) ;
}


/*----------------------------------------------------------------------------
 * Function :   opt_med7_uint8()
 * In       :   pointer to array of 7 pixel values
 * Out      :   a unsigned char
 * Job      :   optimized search of the median of 7 pixel values
 * Notice   :   found on sci.image.processing
 *              cannot go faster unless assumptions are made
 *              on the nature of the input signal.
 *--------------------------------------------------------------------------*/

unsigned char
opt_med7_uint8(
    unsigned char  *p, int n
);

unsigned char
opt_med7_uint8(
    unsigned char  *p, int n
)
{
    ELEM_SORT_U8(p[0], p[5]) ; ELEM_SORT_U8(p[0], p[3]) ; ELEM_SORT_U8(p[1], p[6]) ;
    ELEM_SORT_U8(p[2], p[4]) ; ELEM_SORT_U8(p[0], p[1]) ; ELEM_SORT_U8(p[3], p[5]) ;
    ELEM_SORT_U8(p[2], p[6]) ; ELEM_SORT_U8(p[2], p[3]) ; ELEM_SORT_U8(p[3], p[6]) ;
    ELEM_SORT_U8(p[4], p[5]) ; ELEM_SORT_U8(p[1], p[4]) ; ELEM_SORT_U8(p[1], p[3]) ;
    ELEM_SORT_U8(p[3], p[4]) ; return (p[3]) ;
}


/*----------------------------------------------------------------------------
 * Function :   opt_med9_uint8()
 * In       :   pointer to an array of 9 pixelvalues
 * Out      :   a unsigned char
 * Job      :   optimized search of the median of 9 pixelvalues
 * Notice   :   in theory, cannot go faster without assumptions on the
 *              signal.
 *              Formula from:
 *              XILINX XCELL magazine, vol. 23 by John L. Smith
 *
 *              The input array is modified in the process
 *              The result array is guaranteed to contain the median
 *              value
 *              in middle position, but other elements are NOT sorted.
 *--------------------------------------------------------------------------*/

unsigned char
opt_med9_uint8(
    unsigned char  *p, int n
);

unsigned char
opt_med9_uint8(
    unsigned char  *p, int n
)
{
    ELEM_SORT_U8(p[1], p[2]) ; ELEM_SORT_U8(p[4], p[5]) ; ELEM_SORT_U8(p[7], p[8]) ;
    ELEM_SORT_U8(p[0], p[1]) ; ELEM_SORT_U8(p[3], p[4]) ; ELEM_SORT_U8(p[6], p[7]) ;
    ELEM_SORT_U8(p[1], p[2]) ; ELEM_SORT_U8(p[4], p[5]) ; ELEM_SORT_U8(p[7], p[8]) ;
    ELEM_SORT_U8(p[0], p[3]) ; ELEM_SORT_U8(p[5], p[8]) ; ELEM_SORT_U8(p[4], p[7]) ;
    ELEM_SORT_U8(p[3], p[6]) ; ELEM_SORT_U8(p[1], p[4]) ; ELEM_SORT_U8(p[2], p[5]) ;
    ELEM_SORT_U8(p[4], p[7]) ; ELEM_SORT_U8(p[4], p[2]) ; ELEM_SORT_U8(p[6], p[4]) ;
    ELEM_SORT_U8(p[4], p[2]) ; return(p[4]) ;
}


/*
 *  This Quickselect routine is based on the algorithm described in
 *  "Numerical recipies in C", Second Edition,
 *  Cambridge University Press, 1992, Section 8.5, ISBN 0-521-43108-5
 */

unsigned char quick_select_uint8 (unsigned char arr[], int n);

unsigned char quick_select_uint8 (unsigned char arr[], int n) 
{
    int low, high ;
    int median;
    int middle, ll, hh;

    low = 0 ; high = n-1 ; median = (low + high) / 2;
    for (;;) {
        if (high <= low) /* One element only */
            return arr[median] ;

        if (high == low + 1) {  /* Two elements only */
            if (arr[low] > arr[high])
                ELEM_SWAP_U8(arr[low], arr[high]) ;
            return arr[median] ;
        }

    /* Find median of low, middle and high items; swap into position low */
    middle = (low + high) / 2;
    if (arr[middle] > arr[high])    ELEM_SWAP_U8(arr[middle], arr[high]) ;
    if (arr[low] > arr[high])       ELEM_SWAP_U8(arr[low], arr[high]) ;
    if (arr[middle] > arr[low])     ELEM_SWAP_U8(arr[middle], arr[low]) ;

    /* Swap low item (now in position middle) into position (low+1) */
    ELEM_SWAP_U8(arr[middle], arr[low+1]) ;

    /* Nibble from each end towards middle, swapping items when stuck */
    ll = low + 1;
    hh = high;
    for (;;) {
        do ll++; while (arr[low] > arr[ll]) ;
        do hh--; while (arr[hh]  > arr[low]) ;

        if (hh < ll)
        break;

        ELEM_SWAP_U8(arr[ll], arr[hh]) ;
    }

    /* Swap middle item (in position low) back into correct position */
    ELEM_SWAP_U8(arr[low], arr[hh]) ;

    /* Re-set active partition */
    if (hh <= median)
        low = ll;
        if (hh >= median)
        high = hh - 1;
    }
}

#undef ELEM_SORT_U8
#undef ELEM_SWAP_U8


