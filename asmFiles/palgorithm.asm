#----------------------------------------------------------
# First Processor
#----------------------------------------------------------
  org   0x0000              # first processor p0
  ori   $sp, $zero, 0x3ffc  # stack
  ori   $v0, $zero, 0xabcd  # initial the seed
  ori   $st, $zero, 0xff00  # initial the comstack
  ori   $st_num, $zero, 0   # initial the stack number
  ori   $tt_num, $zero, 0   # initial the total number
  ori   $ttaddr, $zero, 0xe000   #initial the tt_num recording addr
  ori   $four, $zero, 0x0004 #4 
  ori   $stck, $zero, 0x000a #10
  ori   $ttck, $zero, 0x0100 #256
  jal   mainp0              # go to program
  halt

# pass in an address to lock function in argument register 0
# returns when lock is available
lock:
aquire:
  ll    $t0, 0($a0)         # load lock location
  bne   $t0, $0, aquire     # wait on lock to be open
  addiu $t0, $t0, 1
  sc    $t0, 0($a0)
  beq   $t0, $0, lock       # if sc failed retry
  jr    $ra


# pass in an address to unlock function in argument register 0
# returns when lock is free
unlock:
  sw    $0, 0($a0)
  jr    $ra

mainp0:
  push  $ra                 # save return address
main01:
  ori   $a0, $zero, $v0     # initial the seed
  jal   crc32               # do the random
  ori   $a0, $zero, lr      # move lock to arguement register
  jal   lock                # try to aquire the lock
  # critical code segment
  ori   $a0, $zero, $v0     #initial the seed
push10:
  jal   comstack            #push upon the shared stack
  beq   $tt_num, $ttck, push10finish    #check the end
  beq   $st_num, $stck, push10finish    #check 10 entries
  ori   $a0, $zero, $v0     # initial the seed
  jal   crc32               # do the random
  j     push10
push10finish:
  sw    $tt_num, 0($ttaddr) #store tt_num   
  # critical code segment  
  ori   $a0, $zero, lr      # move lock to arguement register
  jal   unlock              # release the lock
  bne   $tt_num, $ttck, main01   #check the end       
  pop   $ra                 # get return address
  jr    $ra                 # return to caller

comstack:
  sw    $v0, 0($st)         # push the new random number
  add   $st,$st,$four       # add the stack
  addi  $st_num, $st_num, 0x0001
  addi  $tt_num, $tt_num, 0x0001
  jr    $ra                 # return to caller


crc32:
  lui $t1, 0x04C1
  ori $t1, $t1, 0x1DB7
  or $t2, $0, $0
  ori $t3, $0, 32

l1:
  slt $t4, $t2, $t3
  beq $t4, $zero, l2

  srl $t4, $a0, 31
  sll $a0, $a0, 1
  beq $t4, $0, l3
  xor $a0, $a0, $t1
l3:
  addiu $t2, $t2, 1
  j l1
l2:
  or $v0, $a0, $0
  jr $ra

lr:
  cfw 0x0

#----------------------------------------------------------
# Second Processor
#----------------------------------------------------------
  org   0x200               # second processor p1
  ori   $sp, $zero, 0x7ffc  # stack
  ori   $st, $zero, 0xff28  # initial the comstack address  ff00+4*a
  ori   $st_end, $zero, 0xfefc   #ff00-4
  ori   $st_end_6, $zero, 0xff10 #ff28-18
  ori   $four, $zero, 0x0004#4 
  ori   $ttaddr, $zero, 0xe000   #initial the tt_num recording addr
  ori   $ttck, $zero, 0x0100 #256
  jal   mainp1              # go to program
  halt

# main function does something ugly but demonstrates beautifully
mainp1:
  push  $ra                 # save return address
main02:
  ori   $sum, $zero, 0      # initial the sum
  ori   $a0, $zero, lr      # move lock to arguement register
  jal   lock                # try to aquire the lock
  # critical code segment
  jal   popst_a0            # pop the ist a0
  or    $t1, $zero, $a0     # the first value for max
  or    $t2, $zero, $a0     # the first value for min
  jal   popst_a1			# pop the 1st a1	
  add   $sum, $sum, $a0     # add a0 to sum
  lw    $tt_num, 0($ttaddr) #load the total number
calculate:
  or    $a0, $zero, $t1     #a0 = t1
  jal   max                 
  or    $t1, $zero, $v0     #t1 = v0 
  or    $a0, $zero, $t2		#a0 = t2 	
  jal   min
  or    $t2, $zero, $v0     #t2 = v0
  add   $sum, $sum, $a1     #add a1 to sum
  jal   popst_a1            #pop a1 
  beq   $tt_num, $ttck, cal_6            #compare with 256
  bne   $st, $st_end, calculate          #end when address reach
  ori   $a1, $zero, 0x000a  #a1 = 10
  or    $a0, $zero, $sum    #a0 = sum
  j     cal_end
cal_6:
  bne   $st, $st_end_6, calculate          #end when address reach
  ori   $a1, $zero, 0x000a  #a1 = 6
  or    $a0, $zero, $sum    #a0 = sum
cal_end:
  jal   divide 
  # critical code segment
  ori   $a0, $zero, lr      # move lock to arguement register
  jal   unlock              # release the lock
  bne   $tt_num, $ttck, main02 #compare with 256
  or    $max_val, $zero, $t1  #store max
  or    $min_val, $zero, $t2  #store min
  or    $average, $zero, $v0  #store average
  pop   $ra                 # get return address
  jr    $ra                 # return to caller

popst_a0:
  lw    $a0, 0($st)
  sub   $st, $st, $four
  jr    $ra
popst_a1:
  lw    $a1, 0($st)
  sub   $st, $st, $four
  jr    $ra

# registers a0-1,v0,t0
# a0 = a
# a1 = b
# v0 = result

#-max (a0=a,a1=b) returns v0=max(a,b)--------------
max:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a0, $a1
  beq   $t0, $0, maxrtn
  or    $v0, $0, $a1
maxrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------

#-min (a0=a,a1=b) returns v0=min(a,b)--------------
min:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a1, $a0
  beq   $t0, $0, minrtn
  or    $v0, $0, $a1
minrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------


# registers a0-1,v0-1,t0
# a0 = Numerator
# a1 = Denominator
# v0 = Quotient
# v1 = Remainder

#-divide(N=$a0,D=$a1) returns (Q=$v0,R=$v1)--------
divide:               # setup frame
  push  $ra           # saved return address
  push  $a0           # saved register
  push  $a1           # saved register
  or    $v0, $0, $0   # Quotient v0=0
  or    $v1, $0, $a0  # Remainder t2=N=a0
  beq   $0, $a1, divrtn # test zero D
  slt   $t0, $a1, $0  # test neg D
  bne   $t0, $0, divdneg
  slt   $t0, $a0, $0  # test neg N
  bne   $t0, $0, divnneg
divloop:
  slt   $t0, $v1, $a1 # while R >= D
  bne   $t0, $0, divrtn
  addiu $v0, $v0, 1   # Q = Q + 1
  subu  $v1, $v1, $a1 # R = R - D
  j     divloop
divnneg:
  subu  $a0, $0, $a0  # negate N
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
  beq   $v1, $0, divrtn
  addiu $v0, $v0, -1  # return -Q-1
  j     divrtn
divdneg:
  subu  $a0, $0, $a1  # negate D
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
divrtn:
  pop $a1
  pop $a0
  pop $ra
  jr  $ra
#-divide--------------------------------------------