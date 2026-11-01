-- add OCG card name
--Digimon Proximamon
--Scripted by Trí Dũng Song Toàn
local s,id,o=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --Fusion Procedure: “Arresterderdramon Superior Mode” + 1 "Digimon" or "Seven Knight" Monster
    Fusion.AddProcMix(c,true,true,612000034,s.ffilter)
    Fusion.AddContactProc(c,function(tp) return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil) end,function(g) Duel.SendtoGrave(g,REASON_COST|REASON_MATERIAL) end,nil,nil,nil,nil,false)
    --battle Indestructable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Unaffected by Opponent Card Effects
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetValue(s.unval)
    c:RegisterEffect(e3)
    --During the Main Phase: You can Shuffle all cards from your hand in to the Deck then target 1 face-up monster you control; it attacks your opponent directly
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_TODECK)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,{id,1})
    e4:SetCost(s.attackcost)
    e4:SetTarget(s.attacktg)
    e4:SetOperation(s.attackop)
    c:RegisterEffect(e4)
    
end
s.listed_series={0x821,0x823}
--                 Seven Knight Siriusmon
s.listed_names={id,612000034}

--Fusion Materials
function s.ffilter(c,fc,sumtype,tp)
    return c:IsSetCard(0x821,fc,sumtype,tp) or c:IsSetCard(0x823,fc,sumtype,tp)
end

--Unaffected by Opponent Card Effects
function s.unval(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--During the Main Phase: You can Shuffle all cards from your hand in to the Deck then target 1 face-up monster you control; it attacks your opponent directly
function s.attackcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    g:RemoveCard(e:GetHandler())
    if chk==0 then
        return #g>0 and not g:IsExists(function(c)
            return not c:IsAbleToDeckAsCost()
        end,1,nil)
    end
    Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.attacktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.attackop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
        Duel.CalculateDamage(tc,nil)
    end
end
