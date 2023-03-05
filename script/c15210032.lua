--AZTECA Mictlantecutli
local s,id=GetID()
function s.initial_effect(c)
--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.ffilter2,s.ffilter)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,0xff)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetTarget(s.rmtg)
	c:RegisterEffect(e1)
	--Special summon from the Graveyard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	end
function s.ffilter(c,fc,sumtype,tp)
	return c:IsType(TYPE_MONSTER,fc,sumtype,tp) and not c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp) and not c:IsType(TYPE_TOKEN,fc,sumtype,tp)
end
function s.ffilter2(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp) and c:IsSetCard(0x5F1,fc,sumtype,tp) and not c:IsType(TYPE_TOKEN,fc,sumtype,tp)
end
function s.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer() and Duel.IsPlayerCanRemove(e:GetHandlerPlayer(),c)
end
--special summon
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():GetSummonType()&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x5F1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil,e,tp)
	if #g>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end