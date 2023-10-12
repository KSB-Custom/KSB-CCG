--Alebrije King Chimera
local s,id=GetID()
function s.initial_effect(c)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	--Link summon procedure
	Link.AddProcedure(c,s.matfilter,3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_EXTRA_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(s.extracon)
	e1:SetValue(s.extraval)
	c:RegisterEffect(e1)
	-- Apply monster protection
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER|TIMING_MAIN_END)
	e2:SetCost(s.cost)
	e2:SetOperation(s.immop)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,{id,2})
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER|TIMING_END_PHASE)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	end
function s.matfilter(c,lc,st,tp)
	return c:IsSetCard(0xf16) 
end
	--opponent Link material
s.curgroup=nil
function s.extracon(c,e,tp,sg,mg,lc,og,chk)
	return not s.curgroup or #(sg&s.curgroup)<2
end
function s.extraval(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or sc~=e:GetHandler() then
			return Group.CreateGroup()
		else
			s.curgroup=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			s.curgroup:KeepAlive()
			return s.curgroup
		end
	elseif chk==2 then
		if s.curgroup then
			s.curgroup:DeleteGroup()
		end
		s.curgroup=nil
	end
end
--Monster Protection
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(s.reto)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.reto(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function s.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- Monsters cannot be banished opponent's effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(s.remtg)
	e2:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e2,tp)
	aux.RegisterClientHint(c,0,tp,1,0,aux.Stringid(id,2),RESET_PHASE|PHASE_END,1)
end
function s.remtg(e,c,rp,r,re)
	local tp=e:GetHandlerPlayer()
	return c:IsFaceup() and ((c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)) or c:IsLocation(LOCATION_GRAVE)) and rp==1-tp and r==REASON_EFFECT
end
--Negate
function s.negfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsNegatableMonster() or c:IsNegatableSpellTrap()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	if Duel.IsExistingTarget(aux.FaceupFilter(s.negfilter),tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(aux.FaceupFilter(s.negfilter),tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
		local g1=Duel.SelectTarget(tp,aux.FaceupFilter(s.negfilter),tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
		local g2=Duel.SelectTarget(tp,aux.FaceupFilter(s.negfilter),tp,0,LOCATION_ONFIELD,1,1,nil)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g1,2,0,0)
	end
end
function s.hfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	g=g:Filter(s.hfilter,nil,e)
	if #g>0 then
		Duel.NegateRelatedChain(g,RESET_TURN_SET)
		for tc in g:Iter() do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		end
	end
end