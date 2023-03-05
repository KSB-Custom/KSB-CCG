--Relic Dagger
local s,id=GetID()
function s.initial_effect(c)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCondition(s.condition)
	e5:SetCost(s.cost)
	e5:SetTarget(s.target)
	e5:SetOperation(s.operation)
	c:RegisterEffect(e5)
	--Activate hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	--If leave field by opponent; take no damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.ndcon)
	e3:SetOperation(s.ndop)
	c:RegisterEffect(e3)
	--Special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	e4:SetOperation(s.activate)
	c:RegisterEffect(e4)
end
--take no damage
function s.ndcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_EFFECT)
		and c:IsPreviousControler(tp) and not c:IsLocation(LOCATION_DECK)
end
function s.ndop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
--condition only control non-effect monsters
function s.handcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.cfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_EFFECT)
end
function s.dfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function s.tfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
--to hand
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,1,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local g=Duel.SelectTarget(tp,s.athfilter,tp,LOCATION_REMOVED,0,1,3,nil)
			if #g>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
	end
end
function s.athfilter(c)
	return c:IsSetCard(0x2329) and c:IsAbleToDeck()
end
function s.ttfilter(c)
	return c:IsAbleToGrave()
end
--Special summon fusion
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
		local tg=Duel.GetMatchingGroup(s.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		for tc in aux.Next(tg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-1000)
		tc:RegisterEffect(e1)
		end
	end
end
--Cost, No summon effect monsters
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(s.ttfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 
		and Duel.CheckReleaseGroupCost(tp,s.cfilter,1,1,false,aux.ReleaseCheckTarget,nil,dg) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(id,2),nil)
	local g=Duel.SelectReleaseGroupCost(tp,s.tfilter,1,1,false,aux.ReleaseCheckTarget,nil,dg)
	Duel.Release(g,REASON_COST)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_EFFECT)
end