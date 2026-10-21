-- add OCG card name
--Seven Knight Guilimon
local s,id,o=GetID()
function s.initial_effect(c)
    --If this card is Normal Summoned: You can Special Summon 1 "Digimon" or "Seven Knight" from your Hand or Deck to your Field in Defense Position, also until the end of this turn, you cannot Normal or Special Summon Monster, except "Digimon" and "Seven Knight" Monster
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,{id,1})
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --If this card is sent to the GY: You can Special Summon 1 “Seven Knight Dukumon” from your Hand, Deck, GY
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,2))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,{id,2})
    e2:SetTarget(s.tgsptg)
    e2:SetOperation(s.tgspop)
    c:RegisterEffect(e2)
end
s.listed_series={0x821,0x823}
s.listed_names={id,611000074}

--If this card is Normal Summoned: You can Special Summon 1 "Digimon" or "Seven Knight" from your Hand or Deck to your Field in Defense Position, also until the end of this turn, you cannot Normal or Special Summon Monster, except "Digimon" and "Seven Knight" Monster
function s.spfilter(c,e,tp)
    return (c:IsSetCard(0x821) or c:IsSetCard(0x823)) 
        and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil,e,tp)
        if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
        end
    end
    --You cannot Special Summon for the rest of this turn, except "Digimon" and "Seven Knight" Monster
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetTargetRange(1,0)
    e1:SetTarget(s.splimit)
    e1:SetReset(RESET_PHASE|PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
    if c:IsMonster() then
        return not (c:IsSetCard(0x821) or c:IsSetCard(0x823))
    elseif c:IsMonsterCard() then
        return not (c:IsOriginalSetCard(0x821) or c:IsOriginalSetCard(0x823))
    end
end

--If this card is sent to the GY: You can Special Summon 1 “Seven Knight Dukumon” from your Hand, Deck, GY
function s.tgspfilter(c,e,tp)
    return c:IsCode(611000074) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.tgsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.tgspfilter,tp,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.tgspop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tgspfilter),tp,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    end
end
