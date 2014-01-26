/ASTNode/ValueLeaf
	var/Value

	New(var/NewValue)
		Value = NewValue
		Value = text2num(Value) || (Value == "0" ? 0 : text2path(Value) || Value)
		world.log << "Created value: [Value], nee '[NewValue]'"

	Execute()
		return Value

	Output()
		world.log << "Value node: [Value]"