	GET stm32_EQU.s 		
; Объявляем макроподстановку для максимального размера массива		
MAX_SIZE	EQU	0x32	
; Объявляем сегмент констант
	AREA CONSTANT_FLASH, DATA, READONLY

; Объявляем сегмент переменных
	AREA VERIABLE_RAM, DATA, READWRITE
; Здесь объявляются переменные

; Инициализация переменной в которой будет храниться результат 
mas DCD	1,2,3,4



; Объявляем сегмент кода     
		AREA MAIN, CODE, READONLY
		THUMB	


; подпрограмма
data proc
    BX LR                    ; переход по адресу в регистре(возврат из подпрограммы)
    ENDP


; Объявляем функцию main    
main	PROC
 
  mov R0, #1
  mov R1, #2
  mov R4, #4
  mov R2, #3
  mov R3, #0xffff
  mov R5, #0xffaa
  ldr R6,=mas
  
clp
;   Арифметические операции
    ADD R0, R1, R4          ; команда ADD выполняет сложение R0=R1+R4
    ADDW R0, R1, #3753      ; ADDW сложение с 12 битной константой
    SUB R0, R4, R2          ; SUB вычитание R0=R4-R2
    SUBW R0, R4, #2         ; вычитание с 12 битной константой
    RSB R0, R2, R4          ; вычитание с противоположным порядком аргументов R0=R4-R2
    
;   Умножение. Деление.
    MUL R0, R1, R4          ; умножение с 32 битным результатом R0=R1*R4
    MLA R0, R1, R4, R2      ; умножение и сложение R0=(R1*R4)+R2
    MLS R0, R1, R2, R4      ; умножение и вычитание R0=R4-(R1*R2)
    SMULL R0, R7, R5, R1    ; умножение со знаком R0=R5*R1 64 битный результат
    UDIV R0, R4, R2         ; деление без знака R0=R4/R2
    SDIV R0, R5, R1         ; деление со знаком R0=R5/R1
        
; доступ к памяти 
    ADR R0, clp             ; загрузка адреса метки в регистр в R0 запишется адрес по которому находится метка clp
    LDR R0, [R1, R2]        ; загрузка в регистр R0 значения по адресу R1 со смещением R2, добавление к команде символов B=байт, SB=байт со знаком, H=полуслово, SH=полуслово со знаком
    STR R0, [R6, R4]        ; запись из регистра R0 в память по адресу R6 со смещением R4, добавление к команде задает размер записи значений B, SB, H, SH
    PUSH {R0-R2, LR}        ; сохранение регистров R0-R2 и регистра LR в стек
    BL   data               ; переход в подпрограмму data
    POP {R0-R2, LR}         ; загрузска значений регистров R0-R2 и регистра LR из стека
    
; работа с битовыми полями
    BFC R3, #0, #4          ; сброс битов в 0 с 0-4бит
    BFI R3, R2, #0, #4      ; копирует младшие биты R2 c 0-4бит в R3
    UBFX R3, R5, #0, #4     ; копирует младшие биты R5 с 0-4бит в R3 с заполением остальных 0
    SBFX R3, R5, #0, #16    ; копирует младшие биты R5 с 0-16бит в R3 с расширением знака(знаковый бит дублируется на все оставшиеся биты)
    UXTB R3, R5             ; копирует первый байт из R5 в R3 с заполением остальных битов 0, если надо копировать 2 байта то UXTH
    SXTB R5, R3             ; копирует первый байт из R5 в R3 с заполением остальных битов 1, если надо копировать 2 байта то SXTH

; перемещение и обработка данных
    MOV R0, R3              ; загрузка в регистр R0, заначения из R3
    CMP R0, R2              ; сравнение регистров, устанавливает флаги Z, C, N, V (Z=1 равенство, Z=0 неравенство, С=1 больше или равно, С=0 меньше, N=1 отрицательное, N=0 положительное значение, V=1 переполнение, V=0 нет переполнения
    ;CMN R0, R2  сравнение с противоположным знаком 
    TEQ R0, R1              ; проверка равенства двух величин устанавливает флаги N, Z
    
; суффиксы условного исполнения все что стоит после MOV и после B является суффиксами
    MOVEQ R0, #1            ; записать в R0 1, если Z=1
    MOVNE R0, #2            ; записать в R0 2, если Z=0
    BCS loop                ; перейти в loop, если С=1
    BCC loop                ; перейти в loop, если С=0
    BMI loop                ; перейти в loop, если N=1
    BPL loop                ; перейти в loop, если N=0
    BGE loop                ; перейти в loop, если N=V, больше или равно
    BGT loop                ; перейти в loop, если Z=0 и N=V, больше
    BLE loop                ; перейти в loop, если Z=1 и N!=V, меньше или равно
    
; логические команды
    AND R1,R2               ; логическое и, ставит в R1 0 в те биты, где в R2 0
    ORR R1,R5               ; логическое или, устанавливает 1 в R1 в те биты, где 1 стоит в R5
    EOR R1,R4               ; логическое исключающее или, инвертирует содержимое R1 в тех битах, где в R4 стоят 1
    BIC R1,R3               ; логическое и не, сбрасывает биты в R1, там где в R3 стоит 1
    ORN R1,R5               ; логическое или не, устанавливает бмты в R1, там где в R5 стоит 0
    
; операции сдвига
    ASR R1,#2                ; арифметический сдвиг вправо на 
    LSL R1, R2, #1           ; логический сдвиг влево значения из R2 на 1, с записью результата в R1
    LSR R1, #3               ; логический сдвиг вправо значения R1 на 3
loop
    B loop                  ; перейти в метку под названием loop
    END
