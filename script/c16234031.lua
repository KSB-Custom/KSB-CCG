--Impish Makeshift Act
local s,id=GetID()
function s.initial_effect(c)
c:SetSPSummonOnce(id)
	--xyz summon
	Xyz.AddProcedure(c,nil,1,2,s.ovfilter,aux.Stringid(id,0),2,s.xyzop)
	--Disable attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCost(aux.dxmcostgen(1,1,nil))
	e1:SetOperation(function() Duel.NegateAttack() end)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
end
s.xyz_number=0
--
function s.cfilter(c)
	return c:IsMonster()
end
function s.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsSetCard(0xf19,xyzc,SUMMON_TYPE_XYZ,tp) and c:IsType(TYPE_XYZ,xyzc,SUMMON_TYPE_XYZ,tp)
end
function s.xyzop(e,tp,chk,mc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.GetMatchingGroup(s.cfilter,tp,0,LOCATION_MZONE,nil):SelectUnselect(Group.CreateGroup(),tp,false,Xyz.ProcCancellable)
	if tc then
		Duel.Release(tc,REASON_COST)
		return true
	else return false end
end
--
