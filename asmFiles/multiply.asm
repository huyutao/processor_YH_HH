
# set the address where you want this
# code segment

  org 0x0000
  ori    $29, $0, 0xFFFC
  addi   $1, $0, 3
  push   $1
  addi   $1, $0, 4
  push   $1
  # $1 first operand $2 second operand
  pop    $2            
  pop    $1
  #clear counter and result            
  add    $3, $0, $0
  add    $4, $0, $0

  loop:
  beq    $3, $2, exit
  addu   $4, $4, $1
  addi   $3, $3, 1
  j loop

  exit:
  push $4
  halt
