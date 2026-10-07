-- add OCG card name
--Digimon Shoutmon
local s,id,o=GetID()
function s.initial_effect(c)
    --If this card is Normal or Special Summoned: You can destroy up to 2 face-up monster your opponent control, and if you do, takes damage equal to the total ATK the destroyed monster has on the field.
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,{id,1})
    e1:SetTarget(s.destg)
    e1:SetOperation(s.desop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --If this card is sent to the GY: You can Special Summon 1 "Digimon Omega Shotmon" from your Hand, Deck, or GY.
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1,{id,2})
    e3:SetTarget(s.tgsptg)
    e3:SetOperation(s.tgspop)
    c:RegisterEffect(e3)
end
--If this card is Normal or Special Summoned: You can destroy up to 2 face-up monster your opponent control, and if you do, takes damage equal to the total ATK the destroyed monster has on the field.
function s.desfilter(c)
    return c:IsMonster() and c:IsFaceup()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local dg=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
    if #dg>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg=dg:Select(tp,1,2,nil)
        Duel.HintSelection(sg,true)
        Duel.Destroy(sg,REASON_EFFECT)
        local dg=Duel.GetOperatedGroup()
        local tc=dg:GetFirst()
        local dam=0
        for tc in aux.Next(dg) do
            local atk=tc:GetPreviousAttackOnField()
            if atk<0 then atk=0 end
            dam=dam+atk
        end
        Duel.Damage(tp,dam,REASON_EFFECT)
    end
end

--If this card is sent to the GY: You can Special Summon 1 "Digimon Omega Shotmon" from your Hand, Deck, or GY.
function s.tgspfilter(c,e,tp)
    return c:IsCode(611000064) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
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
