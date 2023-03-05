--Relic Bow and Arrow
local s,id=GetID()
function s.initial_effect(c)
	--Set relic or poly
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setf)
	c:RegisterEffect(e2)
	--Leave field; suffle 1 card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.tdcon)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
	--set it self
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e5:SetCost(s.setcost)
	e5:SetTarget(s.stg)
	e5:SetOperation(s.setop)
	c:RegisterEffect(e5)
end
s.listed_names={CARD_POLYMERIZATION}
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT)
end
function s.setfilter(c)
	return c:IsSetCard(0x2329) or c:IsCode(CARD_POLYMERIZATION) and c:IsSSetable() and not c:IsForbidden()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setf(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
		if tc then
		Duel.SSet(tp,tc)
		if Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
			Duel.Destroy(g,REASON_EFFECT)
			end
		end
end
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT) and c:IsDiscardable()
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,s.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function s.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
	end
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_EFFECT)
		and c:IsPreviousControler(tp) and not c:IsLocation(LOCATION_DECK)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	end
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end