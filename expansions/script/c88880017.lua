--Rank-Up-Magic Creation Hyper-Drive
function c8.initial_effect(c)
	--(1)Xyz Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c8.target)
	e1:SetOperation(c8.activate)
	c:RegisterEffect(e1)
	--(2)Return to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c8.rettg)
	e2:SetOperation(c8.retop)
	c:RegisterEffect(e2)
	--(3)Return 2 add 1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c8.efcon)
	e3:SetTarget(c8.eftarg)
	e3:SetOperation(c8.efop)
	e3:SetCountLimit(1,8+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e3)
end
--(1)Xyz Summon
function c8.filter1(c,e,tp)
	local rk=c:GetRank()
	return rk>0 and c:IsFaceup() and c:IsSetCard(0x107b) and (rk>0 or c:IsStatus(STATUS_NO_LEVEL)) and Duel.GetLocationCountFromEx(tp,tp,c)>0 
		and (Duel.IsExistingMatchingCard(c8.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1) or
		Duel.IsExistingMatchingCard(c8.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+2) or
		Duel.IsExistingMatchingCard(c8.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+3) or
		Duel.IsExistingMatchingCard(c8.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+4) or
		Duel.IsExistingMatchingCard(c8.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+5))
end
function c8.filter2(c,e,tp,mc,rk)
	if c.rum_limit and not c.rum_limit(mc,e) then return false end
	return mc:IsType(TYPE_XYZ,c,SUMMON_TYPE_XYZ,tp) and c:IsRank(rk) and (c:IsSetCard(0x107b) or c:IsSetCard(0x893)) and mc:IsCanBeXyzMaterial(c,tp)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c8.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c8.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c8.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c8.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c8.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	local lv=Duel.AnnounceLevel(tp,1,5)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c8.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+lv)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
--(2)Return to hand
function c8.filter3(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c8.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(c8.filter3,0,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c8.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
--(3)Return 2 add 1
function c8.filter5(c)
	return c:IsCode(8) and c:IsAbleToHand()
end
function c8.filter6(c)
	return c:IsCode(8) and c:IsAbleToHand()
end
function c8.efcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c8.filter5,tp,LOCATION_GRAVE,0,2,nil)
end
function c8.eftarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8.filter6,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c8.filter5,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(1,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c8.efop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local h=Duel.SelectMatchingCard(tp,c8.filter5,tp,LOCATION_GRAVE,0,2,2,nil)
	if h:GetCount()>0 then
		Duel.SendtoHand(h,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,h)
	end
	local g=Duel.SelectMatchingCard(tp,c8.filter6,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end