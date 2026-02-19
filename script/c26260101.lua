--Sparkhearts Passion Girl
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
--Add 1 "Sparks" from your Deck to your hand, or, if you have "Sparks" in your GY...
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(Cost.SelfDiscard)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
s.listed_series={0xf27}
function s.thfilter(c,hasbox)
	return c:IsAbleToHand() and (c:IsCode(76103675) or (hasbox and c:IsSetCard(0xf27)))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local hasbox=Duel.IsExistingMatchingCard(Card.IsCode,76103675,tp,LOCATION_GRAVE,0,1,nil) 
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,hasbox) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
		local hasbox=Duel.IsExistingMatchingCard(Card.IsCode,76103675,tp,LOCATION_GRAVE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,hasbox)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end