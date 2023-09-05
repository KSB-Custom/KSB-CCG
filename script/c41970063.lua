--FNO Party
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,nil,8,2,nil,nil,99)
	--ritual material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
	e1:SetTarget(s.mttg1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--PZone fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_PZONE,0)
	e3:SetTarget(s.mttg2)
	e3:SetValue(s.mtval)
	c:RegisterEffect(e3)
	end
--Ritual
function s.mttg1(e,c)
	return e:GetHandler():GetOverlayGroup():IsContains(c)
end
--fusion
function s.mttg2(e,c)
	return e:GetHandler()
end
function s.mtval(e,c)
	if not c then return false end
	return c:IsSetCard(0x1065) and c:IsControler(e:GetHandlerPlayer())
end