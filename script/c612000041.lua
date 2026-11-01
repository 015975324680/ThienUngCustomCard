-- add OCG card name
--Digimon Arcturusmon
--Scripted by Trí Dũng Song Toàn
local s,id,o=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --Fusion Procedure: “Seven Knight Regulusmon” + 1 “Seven Knight" or "Digimon” monster
    Fusion.AddProcMix(c,true,true,612000035,s.ffilter)
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
    --When your opponent activates a card or effect (Quick Effect): You can make your opponent choose 1 of the following effects for you to apply
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,{id,1})
    e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return rp==1-tp end)
    e4:SetTarget(s.choosetg)
    e4:SetOperation(s.chooseop)
    c:RegisterEffect(e4)
end
s.listed_series={0x821,0x823}
--                 Seven Knight Regulusmon
s.listed_names={id,612000035}

--Fusion Materials
function s.ffilter(c,fc,sumtype,tp)
    return c:IsSetCard(0x821,fc,sumtype,tp) or c:IsSetCard(0x823,fc,sumtype,tp)
end

--Unaffected by Opponent Card Effects
function s.unval(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--When your opponent activates a card or effect (Quick Effect): You can make your opponent choose 1 of the following effects for you to apply
function s.choosetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.damfilter(c)
    return c:IsSetCard(0x823)
end
function s.chooseop(e,tp,eg,ep,ev,re,r,rp)
     local c=e:GetHandler()
     if not c:IsRelateToEffect(e) then return end
     
     local op=Duel.SelectEffect(1-tp,
        {true,aux.Stringid(id,2)},
        {true,aux.Stringid(id,3)})
    
    if op==1 then
        --Skip your opponent's next Battle Phase
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(0,1)
        e1:SetCode(EFFECT_SKIP_BP)
        e1:SetReset(RESET_PHASE|PHASE_END|RESET_OPPO_TURN)
        Duel.RegisterEffect(e1,tp)
    elseif op==2 then
        --Inflict 1000 damage to your opponent for each “Seven Knight” card on your Field and in your GY
        local val=Duel.GetMatchingGroupCount(s.damfilter,tp,LOCATION_ONFIELD|LOCATION_GRAVE,0,nil)*1000
        Duel.Damage(1-tp,val,REASON_EFFECT)
    end
end
