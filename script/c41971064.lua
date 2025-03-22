--JellyBeans Aviator
local s,id=GetID()
function s.initial_effect(c)
c:EnableReviveLimit()
	Link.AddProcedure(c,nil,3,4,lcheck)
	--You take no battle damage from battles involving this cards
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--damage conversion
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetValue(s.rev)
	c:RegisterEffect(e1)
end
function s.rev(e,re,r,rp,rc)
	return r&REASON_BATTLE~=0 and (Duel.GetAttacker()==e:GetHandler() or (Duel.GetAttackTarget() and Duel.GetAttackTarget()==e:GetHandler()))
end
--
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0xf25,lc,sumtype,tp)
end
