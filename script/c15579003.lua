--Wild Ruin Aruka
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,{id,2})
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
--special summon from deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCost(s.spcost2)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
end
s.listed_series={0x759}
--Shuffle
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsAbleToDeck() and (chkc:IsLocation(LOCATION_REMOVED) or chkc:IsLocation(LOCATION_GRAVE))  end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE,1,1,nil):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
	end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
--sp from deck
function s.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() and Duel.CheckLPCost(tp,400) end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
	Duel.PayLPCost(tp,400)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x759) and c:IsAttributeExcept(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.filter2(c)
	return c:IsFaceup() and not c:IsSetCard(0x759)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tg=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,0,nil)
		for sc in tg:Iter() do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-400)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
		end
	end
end