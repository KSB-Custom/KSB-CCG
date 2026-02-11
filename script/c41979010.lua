--Heraldic King the Heritor
local s,id=GetID()
--If this card is in your hand: You can Special Summon both it and 1 other "Heraldic Beast" monster from your hand or GY and xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
--(Quick if the opponent controls monsters)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCondition(s.spquickcon)
	c:RegisterEffect(e2)
end
s.listed_series={SET_HERALDIC_BEAST}
function s.handgyspfilter(c,e,tp,mc)
	if c:IsCode(id) then return false end
	if not (c:IsSetCard({SET_HERALDIC_BEAST}) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end
	local e1=samexyzlevel(c,c,mc:GetLevel())
	local e2=samexyzlevel(c,mc,c:GetLevel())
	local res=Duel.IsExistingMatchingCard(s.extraspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(mc,c))
	if e1 then e1:Reset() end
	if e2 then e2:Reset() end
	return res
end
function s.extraspfilter(c,e,tp,mg)
	return c:IsCode(47387961)
		and c:IsXyzMonster() and c:IsXyzSummonable(nil,mg,2,2)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>=2
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.handgyspfilter,tp,LOCATION_HAND|LOCATION_GRAVE,0,1,c,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_HAND|LOCATION_GRAVE|LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>=2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.handgyspfilter),tp,LOCATION_HAND|LOCATION_GRAVE,0,1,1,nil,e,tp,c):GetFirst()
	if not sc then return end
	local g=Group.FromCards(c,sc)
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==2 then
		local e1=samexyzlevel(c,c,sc:GetLevel())
		local e2=samexyzlevel(c,sc,c:GetLevel())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=Duel.SelectMatchingCard(tp,s.extraspfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g):GetFirst()
		if xyz then
			Duel.XyzSummon(tp,xyz,g,nil,2,2)
		else
			if e1 then e1:Reset() end
			if e2 then e2:Reset() end
		end
	end
end
--
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.spquickcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil)
end