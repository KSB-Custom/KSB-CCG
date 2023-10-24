--Alebrije Mystic Trageleo
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--Synchro procedure
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xf16),1,99,Synchro.NonTuner(nil),1,1)
	end