--Yagami Team
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon procedure
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xf17),3,nil,s.lcheck)
end
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSummonCode,1,nil,lc,sumtype,tp,15220041) or g:IsExists(Card.IsSummonCode,1,nil,lc,sumtype,tp,15220045)
	or g:IsExists(Card.IsSummonCode,1,nil,lc,sumtype,tp,15220046) or g:IsExists(Card.IsSummonCode,1,nil,lc,sumtype,tp,15220047)
end