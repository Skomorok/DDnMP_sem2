    AREA MAIN, CODE, READONLY
    
Search_Zero PROC
    EXPORT Search_Zero
	push {LR}
;R4-i R5-j 
    mov R4,#0; Запись числа в регистр
    mov R5,#0; Запись числа в регистр
    mov R3,#0; Запись числа в регистр
    
first

    ldr R7,[R0,R4]; Запись в регистр

    ldr R9,[R1,R5]; Запись в регистр

    cmp R7,R9; Сравнение региста R7 с R9
    BEQ loop; Переход к метке при условии равенства
    
    B no
    


loop
    add R3,#1; Операция сложения(прибавляем 1 к R3 и записываем)
    str R3, [R2]; Запись из регистра 
no
    
    add R4,#1; Операция сложения(прибавляем 1 к R4 и записываем)
    cmp R4,#10; Сравнение с числом
    BEQ endd; Переход к метке по условию равества
    B first
    
    
endd

    mov R4,#0; Запись числа в регистр
    add R5,#1; Операция сложения(прибавляем 1 к R5 и записываем)
    cmp R5,#10; Сравнение в числом
    BEQ endd2; Переход к метке по условию равенства

    B first
          
  

        
endd2 
    
;while11
    ;B while11
	pop {PC}
    ENDP
    END