/SetOp
	var/Opcode = "="

	proc/Operation(var/Operand1, var/Operand2)
		. = Operand2

	Add
		Opcode = "+="

		Operation(var/Operand1, var/Operand2)
			if (isnum(Operand1) && isnum(Operand2)) // Specialized support for string concat
				. = Operand1 + Operand2
			else
				. = "[Operand1][Operand2]"

	Subtract
		Opcode = "-="

		Operation(var/Operand1, var/Operand2)
			. = Operand1 - Operand2

	Multiply
		Opcode = "*="

		Operation(var/Operand1, var/Operand2)
			. = Operand1 * Operand2

	Divide
		Opcode = "/="

		Operation(var/Operand1, var/Operand2)
			. = Operand1 / Operand2