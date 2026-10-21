-- add OCG card name
--Seven God Shoutmon X7
local s,id,o=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --Fusion Procedure: 1 “Omegashoutmon” Monster + 1 "Seven Knight” Monster
    Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0X824),aux.FilterBoolFunctionEx(Card.IsSetCard,0x823))
    Fusion.AddContactProc(c,function(tp) return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil) end,function(g) Duel.SendtoGrave(g,REASON_COST|REASON_MATERIAL) end,nil,nil,nil,nil,false)
    --Any card sent to your opponent's GY is banished instead
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_ALL,LOCATION_ALL)
    e1:SetTarget(function(e,c) local tp=e:GetHandlerPlayer() return not c:IsOwner(tp) and Duel.IsPlayerCanRemove(tp,c) end)
    e1:SetValue(LOCATION_REMOVED)
    c:RegisterEffect(e1)
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
    
end
s.listed_series={0x823,0X824}
s.listed_names={id}

--Unaffected by Opponent Card Effects
function s.unval(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
