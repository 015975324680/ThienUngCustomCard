-- add OCG card name
--Seven Knight Agumon
--Scripted by Trí Dũng Song Toàn
local s,id,o=GetID()
function s.initial_effect(c)
    --If this card is Normal or Special Summoned: You can add 1 “Digimon” or “Seven Knight” card from your Deck to your Hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,{id,1})
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --If this card is sent to the GY: You can Special Summon any number of “Digimon” or “Seven Knight” Monsters with a level between 5 and 12 and different level from each other, from your Deck to your Field
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1,{id,2})
    e3:SetTarget(s.tgsptg)
    e3:SetOperation(s.tgspop)
    c:RegisterEffect(e3)
    
end
s.listed_series={0x821,0x823}
s.listed_names={id}

--If this card is Normal or Special Summoned: You can add 1 “Digimon” or “Seven Knight” card from your Deck to your Hand
function s.thfilter(c,tp)
    return c:IsSetCard({0x821,0x823}) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,tp,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

--If this card is sent to the GY: You can Special Summon any number of “Digimon” or “Seven Knight” Monsters with a level between 5 and 12 and different level from each other, from your Deck to your Field
function s.spfilter(c,e,tp)
    return c:IsSetCard({0x821,0x823}) and c:IsLevelBetween(5,12)
        and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.tgsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.tgspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    
    local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
    if #g==0 then return end
    
    ft=math.min(ft,#g)
    if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
    
    local sg=aux.SelectUnselectGroup(g,e,tp,1,ft,
        function(sg,e,tp,mg) return sg:GetClassCount(Card.GetLevel)==#sg end,
        1,tp,HINTMSG_SPSUMMON)
        
    if #sg>0 then
        Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)
        
        -- Monsters you control cannot declare an attack
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        e1:SetTargetRange(LOCATION_MZONE,0)
        e1:SetReset(RESET_PHASE|PHASE_END,3)
        Duel.RegisterEffect(e1,tp)
    end
end
