--AZTECA Quetzalcoatl
local s,id=GetID()
function s.initial_effect(c)
--Synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x5F1),1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
end