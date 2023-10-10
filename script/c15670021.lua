--Alebrije Mystic Dragacci
local s,id=GetID()
function s.initial_effect(c)
	function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,s.ffilter,2)
	end
function s.ffilter(c,fc,sumtype,sp,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0 or not (sg:IsExists(Card.IsAttribute,1,c,c:GetAttribute(),fc,sumtype,sp)
end