-- add OCG card name
--Ultimate Arresterdramon
local s,id,o=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --Fusion Procedure: “Arresterderdramon Superior Mode” + 1 "Digimon" or "Seven Knight" Monster
    Fusion.AddProcMix(c,true,true,611000077,s.ffilter)
    --Contact Fusion
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(s.hspcon)
    e1:SetTarget(s.hsptg)
    e1:SetOperation(s.hspop)
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
    --Your opponent cannot Tribute Monsters you controls
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_UNRELEASABLE_SUM)
    e4:SetTarget(function(_,tc)return tc:IsMonster()end)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e5)
end
s.listed_series={0x821,0x823}
s.listed_names={id,611000077,611000078}

--Fusion Materials
function s.ffilter(c,fc,sumtype,tp)
    return c:IsSetCard(0x821,fc,sumtype,tp) or c:IsSetCard(0x823,fc,sumtype,tp)
end

--Contact Fusion
function s.hspfilter(c,tp,sc)
    return c:IsCode(611000077) and c:IsFaceup() and c:GetEquipGroup():IsExists(Card.IsOriginalCode,1,nil,611000078)
        and c:IsAbleToRemoveAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function s.hspcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(s.hspfilter,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
    local g=Duel.GetMatchingGroup(s.hspfilter,tp,LOCATION_MZONE,0,nil,tp,c)
    if #g==0 then return false end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local sg=g:Select(tp,1,1,nil)
    if #sg==0 then return false end
    sg:KeepAlive()
    e:SetLabelObject(sg)
    return true
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    c:SetMaterial(g)
    if not g then return end
    Duel.Remove(g,POS_FACEUP,REASON_COST|REASON_MATERIAL)
    g:DeleteGroup()
    e:SetLabelObject(nil)
end

--Unaffected by Opponent Card Effects
function s.unval(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end