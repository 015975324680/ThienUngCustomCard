-- add OCG card name
--Seven Knight Paladin Imperialdramon
local s,id,o=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --Fusion Procedure: “Seven Knight Magnamon” + 1 "Seven Knight" Monster
    Fusion.AddProcMix(c,true,true,611000072,s.ffilter)
    Fusion.AddContactProc(c,function(tp) return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,nil) end,function(g) Duel.SendtoGrave(g,REASON_COST|REASON_MATERIAL) end,nil,nil,nil,nil,false)
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e2)
    --void battle damage
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(function(e,c) return (c:IsSetCard(0x821) or c:IsSetCard(0x823)) end)
    e3:SetValue(1)
    c:RegisterEffect(e3)
end
s.listed_series={0x821,0x823}
s.listed_names={id,611000072}

--Fusion Materials
function s.ffilter(c,fc,sumtype,tp)
    return c:IsSetCard(0x823,fc,sumtype,tp)
end