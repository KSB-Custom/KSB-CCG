--Alebrije Mystic Azteca
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro procedure
	Synchro.AddProcedure(c,{aux.FilterBoolFunctionEx(Card.IsSetCard,0xf16),aux.FilterBoolFunctionEx(Card.IsSetCard,0xf15)},1,99,Synchro.NonTuner(nil),1,99)
	end
	