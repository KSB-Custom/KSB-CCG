--Majespecter Baby Unicorn 
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_PZONE,LOCATION_PZONE)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)