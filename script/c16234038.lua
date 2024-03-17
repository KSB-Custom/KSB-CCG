--Narco Diablillo
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	--Xyz summon procedure
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_FIEND),4,2,nil,nil,99)
	--Take control of a level 4 or lower
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Take control of a level 8 or lower
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCost(s.cost)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2,false,REGISTER_FLAG_DETACH_XMAT)
end
--lv4 or lower
function s.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelBelow(4) and c:IsControlerCanBeChanged()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	e:SetCategory(CATEGORY_CONTROL)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.GetControl(tc,tp)
	end
end
--lv8 or lower
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function s.filter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelBelow(8) and c:IsControlerCanBeChanged()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_MZONE,1,nil) end
	e:SetCategory(CATEGORY_CONTROL)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.GetControl(tc,tp)
	end
end
