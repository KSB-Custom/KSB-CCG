--WildRuin Steve
local s,id=GetID()
function s.initial_effect(c)
	-- Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
s.listed_series={0x759}
function s.desfilter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and (c:IsControler(1-tp) or (c:IsFaceup() and c:IsMonster() and c:IsSetCard(0x759)))
end
function s.desrescon(sg,e,tp,mg)
    local own=sg:FilterCount(Card.IsControler,nil,tp)
    return own==1,own>1
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e,tp)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,3,3,s.desrescon,0) end
	local dg=aux.SelectUnselectGroup(g,e,tp,3,3,s.desrescon,1,tp,HINTMSG_DESTROY)
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end