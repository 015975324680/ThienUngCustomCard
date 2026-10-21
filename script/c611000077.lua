-- add OCG card name
--Arresterdramon Superior Mode
local s,id,o=GetID()
function s.initial_effect(c)
    --battle Indestructable
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --Unaffected by Opponent Card Effects
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetValue(s.unval)
    c:RegisterEffect(e2)
    --If this card is in your Hand or GY and you have “Digimon Arresterderdramon” on your Field or in your GY: You can Special Summon this card.
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND|LOCATION_GRAVE)
    e3:SetCountLimit(1,{id,1})
    e3:SetCondition(s.spcon)
    e3:SetTarget(s.sptg)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
    --If this card is Summoned: You can take 1 Equip Spell from your Deck, and either add it to your Hand or equip it to 1 Monster you control
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_SET)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetCountLimit(1,{id,2})
    e4:SetTarget(s.equiptg)
    e4:SetOperation(s.equipop)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e5)
end

s.listed_names={611000062,id}

--Unaffected by Opponent Card Effects
function s.unval(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--If this card is in your Hand or GY and you have “Digimon Arresterderdramon” on your Field or in your GY: You can Special Summon this card.
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,611000062),tp,LOCATION_ONFIELD|LOCATION_GRAVE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
end

--If this card is Summoned: You can take 1 Equip Spell from your Deck, and either add it to your Hand or equip it to 1 Monster you control
function s.monsterfilter(c,ec)
    return c:IsFaceup() and ec:CheckEquipTarget(c)
end
function s.eqfilter(c,tp)
    return c:CheckUniqueOnField(tp) and not c:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(s.monsterfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function s.sthfilter(c,tp)
    return c:IsEquipSpell() and (c:IsAbleToHand() or s.eqfilter(c,tp))
end
function s.equiptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.sthfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function s.equipop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local eqc=Duel.SelectMatchingCard(tp,s.sthfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
    if not eqc then return end
    aux.ToHandOrElse(eqc,tp,
        function(eqc) return s.eqfilter(eqc,tp) end,
        function(eqc)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
            local g=Duel.SelectMatchingCard(tp,s.monsterfilter,tp,LOCATION_MZONE,0,1,1,nil,eqc)
            Duel.HintSelection(g,true)
            local tc=g:GetFirst()
            if tc then Duel.Equip(tp,eqc,tc) end
        end,
        aux.Stringid(id,2)
    )
end
