.data
.globl	_ZNK6MatrixmlERKS_
.type	_ZNK6MatrixmlERKS_, @function

.text
_ZNK6MatrixmlERKS_:
pushl %ebp
movl  %esp, %ebp


                                                                        #subl $16, %esp                          /* on fait de la place pour les variables c,r,i et elem */
movl $0, -4(%ebp)                       /* c = 0 */
movl $0, -8(%ebp)                       /* r = 0 */
movl $0, -12(%ebp)                      /* i = 0 */
movl 20(%ebp), %ebx                     /* on met matorder dans le registre ebx */

loop:
cmp -8(%ebp), %ebx                      /* on compare r et matorder */
jbe end                                 /* on va à la fin si cest plus petit ou égale */

loop2:
cmp -4(%ebp), %ebx                      /* on compare c et matorder */
jbe end                                 /* on va à la fin si cest plus petit ou égale */
movl $0, -16(%ebp)                      /* elem = 0 */

loop3:
cmp -12(%ebp), %ebx                     /* on compare i et matorder */
jbe inc1                                /* si i < matorder on va a inc1 */

movl -12(%ebp), %edx                    /* edx = i */
movl -8(%ebp), %ecx                     /* ecx = r */
imul %ebx, %ecx                         /* ecx = r * matorder */
add %edx, %ecx                          /* ecx = i + r * matorder */
movl 8(%ebp), %eax                      /* eax = inmatdata1 */
movl (%eax, %ecx, 4), %eax              /* eax = inmatdata1[i + r * matorder] */

movl -4(%ebp), %ecx                     /* ecx = c */
imul %ebx, %edx                         /* edx = i * matorder */
add %edx, %ecx                          /* ecx = c + i * matorder */
movl 12(%ebp), %edx                     /* edx = inmatdata2 */
movl (%edx, %ecx, 4), %edx              /* edx = inmadata2[c + i * matorder] */

imul %eax, %edx                         /* edx = inmadata2[c + i * matorder * inmatdata1[i + r * matorder] */
add %edx, -16(%ebp)                     /* elem += edx */

movl -8(%ebp), %ecx                     /* ecx = r */
imul %ebx, %ecx                         /* ecx = r * matorder */
add -4(%ebp), %ecx                      /* ecx = c + r * matorder */
movl 16(%ebp), %eax                     /* eax = outmatdata */
movl -16(%ebp), %edx                    /* edx = elem */
movl %edx, (%eax, %ecx, 4)              /* outmatdata[c + r * matorder] = elem */

jmp inc3


inc1:
incl -8(%ebp)                            /* on incremente r */
movl $0, -4(%ebp)                        /* on reinitialise c */
jmp loop                                 /* on recommence la premiere boucle */

inc2:
incl -4(%ebp)                            /* on incremente c */
movl $0, -12(%ebp)                       /* on reinitialise i */
jmp loop2                                /* on recommence la deuxieme boucle */

inc3:
incl -12(%ebp)                           /* on incremente i */
jmp loop3                                /* on recommence la troisieme loop */


#not_multiplicable:
#movl -8(%ebp), %ecx
#pushl %ecx
#call notMultiplicableError

end:
        leave                            /* restore ebp and esp */
        ret                              /* return to the caller */