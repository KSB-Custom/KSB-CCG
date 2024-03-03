--Gran Anciano Diablillo
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xf19),1,1,aux.FilterSummonCode(16233034),1,1)
	--to defense
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.poscon)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)
	--atk change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.adchange)
	c:RegisterEffect(e2)
end
s.listed_names={231034}
--position
function s.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
--switch atk
function s.adchange(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SWAP_BASE_AD)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	-- Gain LP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCountLimit(1)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(s.lptg)
	e2:SetOperation(s.lpop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetBattleTarget():GetBaseAttack()
	local def=e:GetHandler():GetBattleTarget():GetBaseDefense()
	--checks if the value of either stat isnt 0
	local atkt=e:GetHandler():GetBattleTarget():GetBaseAttack()>0
	local deft=e:GetHandler():GetBattleTarget():GetBaseDefense()>0
	if chk==0 then return atkt or deft end
	
	if atkt and deft then --if the monster has positive atk and def
		local op=Duel.SelectEffect(tp,
			{atk,aux.Stringid(id,0)},
			{def,aux.Stringid(id,1)})
		e:SetLabel(op)
		if op==1 then 
			Duel.SetTargetPlayer(tp)
			Duel.SetTargetParam(atk)
			Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
		elseif op==2 then 
			Duel.SetTargetPlayer(tp)
			Duel.SetTargetParam(def)
			Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,def)
		end
	elseif atkt then --if the monster has 0 def or is a Link
		e:SetLabel(1)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(atk)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
	elseif deft then --if the monster has 0 atk
		e:SetLabel(2)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(def)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,def)
	end
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	if op==1 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	elseif op==2 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end
end