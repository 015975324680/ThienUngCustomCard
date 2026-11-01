-- add OCG card name
--We Are Legend Hero
--Scripted by Trí Dũng Song Toàn
local s,id,o=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --Special Summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,{id,1})
    e2:SetCost(Cost.PayLP(2000))
    e2:SetTarget(s.target)
    e2:SetOperation(s.operation)
    c:RegisterEffect(e2)

end
s.listed_series={0x821,0x822,0x823}
s.listed_names={id,0x821,0x822,0x823}

--Special Summon
function s.ExtraFilter(c,e,tp)
    return (c:IsSetCard(0x821) or c:IsSetCard(0x823))
        and c:GetLevel()==12 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,true,true)
        and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.FieldFilterd(c,tp)
    return (c:IsSetCard(0x821) or c:IsSetCard(0x823))
        and c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.FieldFilterd,tp,LOCATION_ONFIELD,0,1,nil,tp)
            and Duel.IsExistingMatchingCard(s.ExtraFilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.FieldFilterd,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
    local tc=g:GetFirst()
    if not tc then return end
    
    if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
    if not tc:IsLocation(LOCATION_GRAVE) then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=Duel.SelectMatchingCard(tp,s.ExtraFilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local sc=sg:GetFirst()
    if not sc then return end
    
    Duel.SpecialSummon(sc,SUMMON_TYPE_SPECIAL,tp,tp,true,true,POS_FACEUP)
end
