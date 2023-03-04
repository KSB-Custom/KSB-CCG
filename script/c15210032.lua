--AZTECA Mictlantecutli
local s,id=GetID()
function s.initial_effect(c)
--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.ffilter2,s.ffilter)
	end
function s.ffilter(c,fc,sumtype,tp)
	return c:IsType(TYPE_MONSTER,fc,sumtype,tp) and not c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp) and not c:IsType(TYPE_TOKEN,fc,sumtype,tp)
end
function s.ffilter2(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp) and c:IsSetCard(0x5F1,fc,sumtype,tp) and not c:IsType(TYPE_TOKEN,fc,sumtype,tp)
end