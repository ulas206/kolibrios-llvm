/* Copyright (C) 1994 DJ Delorie, see COPYING.DJ for details */
/* @(#)s_nextafter.c 5.1 93/09/24 */
/*
 * ====================================================
 * Copyright (C) 1993 by Sun Microsystems, Inc. All rights reserved.
 *
 * Developed at SunPro, a Sun Microsystems, Inc. business.
 * Permission to use, copy, modify, and distribute this
 * software is freely granted, provided that this notice 
 * is preserved.
 * ====================================================
 */

#if defined(LIBM_SCCS) && !defined(lint)
static char rcsid[] = "$Id: s_nextafter.c,v 1.6 1994/08/18 23:07:13 jtc Exp $";
#endif

/* IEEE functions
 *	nextafter(x,y)
 *	return the next machine floating-point number of x in the
 *	direction toward y.
 *   Special cases:
 */

#include "math.h"
#include "math_private.h"

#ifdef __STDC__
	double nextafter(double x, double y)
#else
	double nextafter(x,y)
	double x,y;
#endif
{
	int32_t hx,hy,ix,iy;
	u_int32_t lx,ly;

	EXTRACT_WORDS(hx,lx,x);
	EXTRACT_WORDS(hy,ly,y);
	ix = hx&0x7fffffff;		/* |x| */
	iy = hy&0x7fffffff;		/* |y| */

	if(((ix>=0x7ff00000)&&((ix-0x7ff00000)|lx)!=0) ||   /* x is nan */ 
	   ((iy>=0x7ff00000)&&((iy-0x7ff00000)|ly)!=0))     /* y is nan */ 
	   return x+y;				
	if(x==y) return x;		/* x=y, return x */
	if((ix|lx)==0) {			/* x == 0 */
	    INSERT_WORDS(x,hy&0x80000000,1);	/* return +-minsubnormal */
	    y = x*x;
	    if(y==x) return y; else return x;	/* raise underflow flag */
	} 
	if(hx>=0) {				/* x > 0 */
	    if(hx>hy||((hx==hy)&&(lx>ly))) {	/* x > y, x -= ulp */
		if(lx==0) hx -= 1;
		lx -= 1;
	    } else {				/* x < y, x += ulp */
		lx += 1;
		if(lx==0) hx += 1;
	    }
	} else {				/* x < 0 */
	    if(hy>=0||hx>hy||((hx==hy)&&(lx>ly))){/* x < y, x -= ulp */
		if(lx==0) hx -= 1;
		lx -= 1;
	    } else {				/* x > y, x += ulp */
		lx += 1;
		if(lx==0) hx += 1;
	    }
	}
	hy = hx&0x7ff00000;
	if(hy>=0x7ff00000) return x+x;	/* overflow  */
	if(hy<0x00100000) {		/* underflow */
	    y = x*x;
	    if(y!=x) {		/* raise underflow flag */
	        INSERT_WORDS(y,hx,lx);
		return y;
	    }
	}
	INSERT_WORDS(x,hx,lx);
	return x;
}