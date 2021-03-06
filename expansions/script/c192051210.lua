--coded by Lyris
--Steelus Revolutionatem
function c192051210.initial_effect(c)
	--Cannot be Normal Summoned/Set.
	c:EnableUnsummonable()
	--When you activate the effect of a Level 3 "Steelus" monster on the field that would Special Summon a monster: You can negate that effect, and if you do, Special Summon this card from your hand, then destroy as many other monsters you control as possible. This card gains effects for each card destroyed with its effect. (below)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c192051210.discon)
	e1:SetTarget(c192051210.distg)
	e1:SetOperation(c192051210.disop)
	c:RegisterEffect(e1)
	--1 or more: "Steelus" monsters you control cannot be targeted for attacks, except "Steelus Revolutionatem".
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetLabel(1)
	e2:SetCondition(c192051210.condition)
	e2:SetTarget(c192051210.imtg)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	--2 or more: Cannot be targeted or destroyed by your opponent's card effects.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetLabel(2)
	e3:SetCondition(c192051210.condition)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--3 or more: Once per turn: You can draw 1 card.
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(192051210,0))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetLabel(3)
	e5:SetCondition(c192051210.condition)
	e5:SetTarget(c192051210.drtg)
	e5:SetOperation(c192051210.drop)
	c:RegisterEffect(e5)
	--4 or more: Once per turn: You can Special Summon 1 Level 3 "Steelus" monster from your Graveyard, but it has its effects negated.
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(192051210,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetLabel(4)
	e6:SetCondition(c192051210.condition)
	e6:SetTarget(c192051210.sptg)
	e6:SetOperation(c192051210.spop)
	c:RegisterEffect(e6)
end
function c192051210.discon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	local rc=re:GetHandler()
	return rp==tp and re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and rc:IsSetCard(0x617) and rc:GetLevel()==3
end
function c192051210.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(0)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c192051210.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)==0 then return end
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,e:GetHandler())
		local ct=Duel.Destroy(g,REASON_EFFECT)
		e:GetHandler():RegisterFlagEffect(192051210,RESET_EVENT+0x1ff0000,0,1,ct)
	end
end
function c192051210.condition(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(192051210)>0 and c:GetFlagEffectLabel(192051210)>=e:GetLabel()
end
function c192051210.imtg(e,c)
	return c:IsSetCard(0x617) and not c:IsCode(192051210)
end
function c192051210.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c192051210.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c192051210.spfilter(c,e,tp)
	return c:IsSetCard(0x617) and c:GetLevel()==3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c192051210.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c192051210.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c192051210.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c192051210.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
