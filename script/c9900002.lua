--Relic Katana
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Banish to special
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetHintTiming(0,TIMING_END_PHASE)
	e7:SetCost(aux.bfgcost)
	e7:SetTarget(s.sptg)
	e7:SetOperation(s.spop)
	c:RegisterEffect(e7)
end
function s.counterfilter(c)
	return not c:IsType(TYPE_EFFECT)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.PayLPCost(tp,1000)
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
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_EFFECT)
end
function s.filter1(c)
	return c:IsSetCard(0x2329) and c:IsAbleToRemove() 
end
function s.filter2(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT) and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil) 
	and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg2=g2:Select(tp,1,2,nil)
	sg1:Merge(sg2)
	Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
	sg1:KeepAlive()
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	local fid=Duel.GetTurnCount()	
	for tc in aux.Next(sg1) do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(sg1)
	e1:SetCondition(s.thcon)
	e1:SetOperation(s.thop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
	Duel.RegisterEffect(e1,tp)
	end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.thfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if ct+2==Duel.GetTurnCount() then
		local sg1=e:GetLabelObject():Filter(s.thfilter,nil,e:GetLabel())
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
	end
end
function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)	and c:IsLevelBelow(7)  and not c:IsType(TYPE_EFFECT)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
		and tc:IsType(TYPE_FUSION) and tc:IsLevelBelow(5) then
		local c=e:GetHandler()
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local d=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
		local g=Duel.GetMatchingGroup(aux.disfilter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
	end
end