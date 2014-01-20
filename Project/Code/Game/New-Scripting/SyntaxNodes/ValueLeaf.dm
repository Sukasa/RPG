/ASTNode/ValueLeaf
	var/Value

	New(var/NewValue)
		Value = NewValue
		Value = text2num(Value) || Value

	Execute()
		return Value