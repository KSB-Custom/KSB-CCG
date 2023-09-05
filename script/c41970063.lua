--FNO Party
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,nil,8,2,nil,nil,99)
	--Prevent effect and activation from being negated
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.effectfilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.effectfilter)
	c:RegisterEffect(e2)
	--PZone fusion material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_PZONE,0)
	e3:SetTarget(s.mttg2)
	e3:SetValue(s.mtval)
	c:RegisterEffect(e3)
	--Opponent's monsters cannot activate their effects during battle phase
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(s.condition)
	e4:SetValue(s.aclimit)
	c:RegisterEffect(e4)
	end
--Ritual
function s.effectfilter(e,c)
	local e=Duel.GetChainInfo(c,CHAININFO_TRIGGERING_EFFECT)
	return e:GetHandler():IsRitualSpell() and e:GetHandler():IsSetCard(0x1065)
end
--fusion
function s.mttg2(e,c)
	return e:GetHandler()
end
function s.mtval(e,c)
	if not c then return false end
	return c:IsSetCard(0x1065) and c:IsControler(e:GetHandlerPlayer())
end
--Sychro
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1065)
end
function s.condition(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler()) 
	and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end