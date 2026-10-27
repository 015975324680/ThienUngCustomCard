-- add OCG card name
--Seven Knight Gammamon
--Scripted by Trí Dũng Song Toàn
local s,id,o=GetID()
function s.initial_effect(c)
    --If you control no Monster: You can Special Summon this card from your Hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,{id,1})
    e1:SetCondition(s.selfspcon)
    e1:SetTarget(s.selfsptg)
    e1:SetOperation(s.selfspop)
    c:RegisterEffect(e1)
    --If this card is Banished: You can target 1 “Seven Knight” or “Digimon” Monster in your GY; shuffle that target into your Deck, and if you do, add this card to your Hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_REMOVE)
    e2:SetCountLimit(1,{id,2})
    e2:SetTarget(s.tdthtg)
    e2:SetOperation(s.tdthop)
    c:RegisterEffect(e2)
    --If this card is sent to the GY: You can Special Summon 1 “Seven Knight Siriusmon” or 1 “Seven Knight Regulusmon” from your Hand, Deck, or GY
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1,{id,3})
    e3:SetTarget(s.tgsptg)
    e3:SetOperation(s.tgspop)
    c:RegisterEffect(e3)
end
s.listed_series={0x821,0x823}
s.listed_names={611000094,id}

--If you control no Monster: You can Special Summon this card from your Hand
function s.selfspcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandlerPlayer()
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.selfsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.selfspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end

--If this card is Banished: You can target 1 “Seven Knight” or “Digimon” Monster in your GY; shuffle that target into your Deck, and if you do, add this card to your Hand
function s.tdfilter(c)
    return c:IsSetCard({0x821,0x823}) and c:IsFaceup() and c:IsAbleToDeck()
end
function s.tdthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc) end
    if chk==0 then return e:GetHandler():IsAbleToHand()
        and Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,0)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,0)
end
function s.tdthop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    
    if tc:IsRelateToEffect(e) then
        if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK) then
            if c:IsRelateToEffect(e) then
                Duel.SendtoHand(c,nil,REASON_EFFECT)
            end
        end
    end
end

--If this card is sent to the GY: You can Special Summon 1 “Seven Knight Siriusmon” or 1 “Seven Knight Regulusmon” from your Hand, Deck, or GY
function s.tgspfilter(c,e,tp)
    return (c:IsCode(611000094) or c:IsCode(611000095)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
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