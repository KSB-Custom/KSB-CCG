--Relic Shield
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCost(s.cost)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.PersistentTargetFilter)
	c:RegisterEffect(e1)
	--Opponent can only target this card for attacks
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(s.atlimit)
	c:RegisterEffect(e2)
	--Take control
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_SET_CONTROL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(s.tcon)
	e3:SetValue(s.cval)
	c:RegisterEffect(e3)
	--Equipped monster is treated as a non-effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_REMOVE_TYPE)
	e4:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e4)
	--Destroy 1 spell/trap
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCondition(s.reccon)
	e5:SetTarget(s.target)
	e5:SetOperation(s.operation)
	c:RegisterEffect(e5)
	--equip
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_EQUIP)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E+TIMING_MAIN_END)
	e6:SetCondition(s.conopp)
	e6:SetCost(s.eqcost)
	e6:SetTarget(s.eqtg)
	e6:SetOperation(s.eqop)
	c:RegisterEffect(e6)
	--Effect cannot be activate
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_EQUIP)
	e7:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e7)
	--fusion substitute
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_EQUIP)
	e8:SetCode(EFFECT_FUSION_SUBSTITUTE)
	c:RegisterEffect(e8)
	--Cannot atack
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_EQUIP)
	e9:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e9)
end
--Destroy spell/trap
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and not c:IsLocation(LOCATION_DECK)
end
function s.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--condiciones y filtros
function s.tcon(e,tp,eg,ep,ev,re,r,rp,tc)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function s.eqlimit(e,c)
	return e:GetHandlerPlayer()~=c:GetControler() or e:GetHandler():GetEquipTarget()==c
end
function s.cval(e,c)
	return e:GetHandlerPlayer()
end
function s.atlimit(e,c)
	return c~=e:GetHandler():GetEquipTarget()
end
function s.efftg(e,c)
	return c~=e:GetHandler():GetEquipTarget() and c:IsType(TYPE_MONSTER)
end
function s.rfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT) and c:IsAbleToRemoveAsCost()
end
--
function s.conopp(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function s.eqfilter2(c)
	return c:IsFaceup() 
end
function s.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.eqfilter2(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
	function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc,true)
		--Add Equip limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		c:RegisterEffect(e1)
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(id,2),nil)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_EFFECT)
end