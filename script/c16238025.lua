--Locuras Diablillo
--scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCountLimit(1,id)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(s.cost)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--heal
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.hcondition)
	e3:SetOperation(s.hoperation)
	e3:SetValue(aux.FilterBoolFunction(Card.IsSetCard,0xf19))
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e4:SetCondition(s.hcondition2)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
s.listed_series={0x231,0x232}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ch=Duel.GetCurrentChain(true)-1
	return ep==1-tp and ch>0 and Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_CONTROLER)==tp
		and Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_EFFECT):GetHandler():IsSetCard(0xf19|0x232)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT,LOCATION_REMOVED)
	end
end
--heal
function s.desfilter(c)
	return c:IsSetCard(0xf19) and c:IsLevelBelow(3)
end
function s.hcondition(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(Card.IsSummonPlayer,1,nil,tp) and eg:IsExists(s.desfilter,1,nil)
end
function s.hcondition2(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(Card.IsControler,1,nil,tp) and eg:IsExists(s.desfilter,1,nil)
end
function s.hoperation(e,tp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Recover(tp,300,REASON_EFFECT)
end