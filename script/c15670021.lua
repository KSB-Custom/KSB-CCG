--Alebrije Mystic Dragacci
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,s.ffilter1,1,s.ffilter2,1)
	end
	s.listed_series={0xf16}
function s.ffilter1(c,fc,sumtype,tp)
	return c:IsSetCard(0xf16,fc,sumtype,tp) or (c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_EFFECT) and c:IsStatus(STATUS_SPSUMMON_TURN))
end
function s.ffilter2(c,fc,sumtype,tp)
	return c:IsType(TYPE_EFFECT,fc,sumtype,tp) and c:IsType(TYPE_MONSTER,fc,sumtype,tp)
end