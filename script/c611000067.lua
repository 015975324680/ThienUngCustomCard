-- add OCG card name
--Seven Knight Agumon Spirits
local s,id,o=GetID()
function s.initial_effect(c)
    --All face-up Monsters on the Field and in the GY(s) become FIRE
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE|LOCATION_GRAVE,LOCATION_MZONE|LOCATION_GRAVE)
    e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e1:SetValue(ATTRIBUTE_FIRE)
    c:RegisterEffect(e1)
    --Gains 200 ATK for each FIRE Monster on the Field and in the GY(s)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(function(e,c) return Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_MZONE|LOCATION_GRAVE,LOCATION_MZONE|LOCATION_GRAVE,nil,ATTRIBUTE_FIRE)*200 end)
    c:RegisterEffect(e2)
    --If this card is sent to the GY: You can Special Summon 1 “Seven Knight Shinegreymon” from your Deck
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1,{id,1})
    e3:SetTarget(s.tgsptg)
    e3:SetOperation(s.tgspop)
    c:RegisterEffect(e3)
end
s.listed_series={0x821,0x823}
s.listed_names={611000068,id}

--If this card is sent to the GY: You can Special Summon 1 “Seven Knight Shinegreymon” from your Deck
function s.tgspfilter(c,e,tp)
    return c:IsCode(611000068) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.tgsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.tgspfilter,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE)
end
function s.tgspop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tgspfilter),tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    end
end
