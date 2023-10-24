--Alebrije Mystic Azteca
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro procedure
	Synchro.AddProcedure(c,s.sfilter,1,99,Synchro.NonTuner(nil),1,99)
	end
	s.material_setcode={0xf16,0xf15}
function s.sfilter(c)
	return c:IsSetCard(0xf15) or c:IsSetCard(0xf16)
end