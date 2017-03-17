#define ARG1      8(%ebp)
#define ARG2      12(%ebp)
#define ARG3      16(%ebp)
#define ARG4      20(%ebp)
#define ARG5      24(%ebp)
#define ARG6      28(%ebp)
#define ARG7      32(%ebp)
#define ARG8      36(%ebp)
#define ARG9      40(%ebp)
#define ARG10     44(%ebp)
/*
.data
   msg   db   'Hello World!', 10, 13, '$'
*/

.text

/* void _greeting(int n);                                                  */
/* prints "Hello World!\n" n times                                         */

.globl __greeting
   .align 4
   pushl %ebp
   movl %esp, %ebp
   pushl %ebx
   pushw %es

   /*movl ARG1, %cx
   movl %ah, $0x9
   movl %dx, msg
greeting_loop:
   int $0x21

   loop greeting_loop*/
   /*
   decl %ecx
   jg greeting_loop
   */

   popw %es
   popl %ebx
   movl %ebp, %esp
   popl %ebp
   ret
