#SingleInstance force
; 
; 
; ===== Variables =====
; 
; 
; (Numbers)
numerator := "1"
denominator := "1"
input := "1"
; 
; (Temporary)
temp_num1 := "0"
temp_num2 := "0"
; 
; 
; ===== Main =====
; 
; 
; (Run)
InputBox, input, Input, Enter a decimal number.
temp_num1 := input
temp_num2 := numerator / denominator
while(true)
{
temp_num2 := numerator / denominator
if (temp_num1!=temp_num2)
{
if (temp_num1<temp_num2)
{
denominator++
}
else
{
numerator++
}
continue
}
else
{
break
}
}
MsgBox, %numerator%/%denominator% = %input%
Sleep 10
ExitApp