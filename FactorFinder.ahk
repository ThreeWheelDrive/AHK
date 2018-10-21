#SingleInstance force
start:
; 
; 
; ===== Variables =====
; 
; 
; (Input)
input := ""
; 
; (Internal)
dividend := ""
numerator := ""
denominator := ""
input_sqrt := ""
text := ""
; 
; 
; ===== Main =====
; 
; 
while(true)
{
	InputBox, input, Input, Input an integer (non-decimal number) to factor.`n(Or the word exit to exit)
	if (input=="exit")
	ExitApp
	else if (Round(input)==input)
	break
	MsgBox, Incorrect Response
	continue
}
numerator := input
denominator := "2"
input_sqrt := Sqrt(numerator)
while(true)
{
	if ((dividend=="")||(dividend<=-2)||(dividend>=2))
	{
		if (denominator<=input_sqrt)
		{
			while(true)
			{
				dividend := numerator / denominator
				if (Round(dividend)==dividend)
				break
				denominator++
				continue
			}
			if (text=="")
			text := denominator
			else
			text := text ", " denominator
			numerator := dividend
			denominator := "2"
			input_sqrt := Sqrt(numerator)
		}
		else
		break
	}
	else
	break
	continue
}
MsgBox, % "Factors of " input " : " text
goto start
