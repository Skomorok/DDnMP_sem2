    AREA CONSTANT_FLASH, DATA, READONLY
mas DCB 0x32, 0x55, 0x84, 0x22, 0x00, 0x51, 0x23, 0x77, 0x16, 0x73
mas2 DCB 0x34, 0x10, 0x63, 0x19, 0x74, 0x48, 0x22, 0x58, 0x74, 0x32
    AREA VERIABLE_RAM, DATA, READWRITE
result SPACE 10
result2 SPACE 10
    AREA MAIN, CODE, READONLY
    
__main PROC
    EXPORT __main
	IMPORT Search_Zero
		
    
 
 
while11
    B while11
    ENDP
    END