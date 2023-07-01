--RPG Tank X Berseker
local s,id=GetID()
function s.initial_effect(c)
	--cannot select battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(function(e,c) return c~=e:GetHandler() end)
	c:RegisterEffect(e1)
	--cannot be targeted
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--immune during Battle Phase
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.immcon)
	e3:SetValue(s.immval)
	c:RegisterEffect(e3)
	end
function s.immcon(e)
	return Duel.IsBattlePhase()
end
function s.immval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end