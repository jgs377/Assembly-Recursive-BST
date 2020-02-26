	xdef BinarySearch

*BinarySearch(int[] A, int key, int low, int high)
*function looks for the key in the sorted array A by comparing
*the key to the middle element in A. If the key is equal to the
*middle element, the index of the middle element is returned. If
*the key is smaller, the element equal to the key, if it exists,
*must be between the low point and the mid point. If the key is
*greater, the element equal to the key, if it exists, must be
*between the mid point and the high point. Logically, every time
*the function calls itself, the size of the problem halves. This 
*function is using recursion, preserves the a6 register of the caller 
*and returns the index of the found element (or -1) in register D0.

BinarySearch:

	move.l a6,-(a7) *save caller's frame pointer
	move.l a7,a6	*setup my own frame pointer

	*set up mid point mid = (low + high) / 2
	move.l 12(a6),D1 		*move low to D1
	add.l 8(a6),D1			*add high to low in D1
	divs.w #2,D1			*divide by 2
	ext.l D1			*remove remainder

	*base (failure) case
if1:
	move.l 12(a6),D2 		*low to D2
	move.l 8(a6),D3 		*high to D3
	cmp.l D2,D3 			*if (high < low)
	BGE endif1

	move.l a6,a7			
	move.l (a7)+,a6			*restore caller's frame pointer
	move.l #-1,D0			*return -1 in D0 because key is not in A
	rts

endif1:

	movea.l 20(a6),a0		*move address of array to a0
	move.l D1,D6			*make a copy of mid in d6
	muls #4,D6			*multiply by 4 because of long type
	move.l 0(a0,D6.l),D4		*use d6.l as offset for middle element
	move.l 16(a6),D5		*move key to d5

	cmp.l D4,D5			*if(key == A[mid])
	BNE ne
	
	move.l a6,a7			*if this code is reached, then the key
	move.l (a7)+,a6			*has been found at the index mid so mid is
	move.l D1,D0			*put in d0 and caller's pointer is restored
	rts

ne:

	BGE ge				*(if key < A[mid]

	move.l 20(a6),-(a7)		*move #A onto stack
	move.l 16(a6),-(a7)		*move key onto stack
	move.l 12(a6),-(a7)		*move low onto stack
	sub.l #1,D1			*subtract 1 from midpoint 
	move.l D1,-(a7)			*move midpoint-1 onto stack
	jsr BinarySearch		*BinarySearch(#A,key,low,mid-1)
	adda.l #16,a7			*remove 4 parameters
	move.l a6,a7			
	move.l (a7)+,a6			*restore caller's pointer
	rts

ge:

	move.l 20(a6),-(a7)		*move #A onto stack
	move.l 16(a6),-(a7)		*move key onto stack
	add.l #1,D1			*add 1 to midpoint
	move.l D1,-(a7)			*move midpoint+1 onto stack
	move.l D3,-(a7)			*move high onto stack
	jsr BinarySearch		*BinarySearch(#A,key,mid+1,high)
	adda.l #16,a7			*remove 4 parameters
	move.l a6,a7			
	move.l (a7)+,a6			*restore caller's pointer

	rts

		end
