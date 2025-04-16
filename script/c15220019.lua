--Orochi Team
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon procedure
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xf17),3,3,s.lcheck)
end
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSummonCode,1,nil,lc,sumtype,tp,15220015) or g:IsExists(Card.IsSummonCode,1,nil,lc,sumtype,tp,15220011)
	or g:IsExists(Card.IsSummonCode,1,nil,lc,sumtype,tp,15220012) or g:IsExists(Card.IsSummonCode,1,nil,lc,sumtype,tp,15220013)
end