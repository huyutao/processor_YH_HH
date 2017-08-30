
# set the address where you want this
# code segment

  org 0x0000
  ori  $29, $0, 0xFFFC
  lw   $11, 0x8000($0)
  lw   $12, 0x8004($0)
  lw   $13, 0x8008($0)
  addi $11, $11, -2000
  addi $12, $12, -1

  #multi_year
  push   $11
  addi   $14, $0, 365
  push   $14
  jal mult
  pop $15
  add $13, $13, $15
  #multi_month
  push   $12
  addi   $14, $0, 30
  push   $14
  jal mult
  pop $15
  add $13, $13, $15
  halt

  mult:
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
  jr $31


  year:
  org 0x8000
  cfw  2017

  month:
  org 0x8004
  cfw 8

  days:
  org 0x8008
  cfw 20
  
