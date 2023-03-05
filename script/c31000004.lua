--Majespecter Triple
local s,id=GetID()
function s.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.actop)
	c:RegisterEffect(e1)
end
s.listed_series={0xd0}
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=s.thdtg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=s.thetg(e,tp,eg,ep,ev,re,r,rp,0)
	local b3=s.atktg(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return b1 or b2 or b3 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)},
		{b3,aux.Stringid(id,3)})
	if op==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		s.thdtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND)
		s.thetg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif op==3 then
		e:SetCategory(CATEGORY_DRAW)
		s.atktg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	Duel.SetTargetParam(op)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	local op=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if op==1 then s.thop(e,tp,eg,ep,ev,re,r,rp)
	elseif op==2 then s.theop(e,tp,eg,ep,ev,re,r,rp)
	elseif op==3 then s.atkop(e,tp,eg,ep,ev,re,r,rp) end
end
function s.thfilter(c)
	return c:IsSetCard(0xd0) and c:IsMonster() and c:IsAbleToHand()
end
function s.thdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--Add from extra deck
function s.th2filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function s.thetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_EXTRA,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_EXTRA)
end
function s.theop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.th2filter,tp,LOCATION_EXTRA,0,nil)
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=g:Select(tp,1,1,nil)
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
--Increase ATK/DEF
function s.th3filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsCode(0xd0) end
	if chk==0 then return Duel.IsExistingTarget(s.th3filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0xd0) and (sumtype&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end