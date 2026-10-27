-- add OCG card name
--Seven Knight Atratusmon
--Scripted by Trí Dũng Song Toàn
local s,id,o=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --Summon Condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(0)
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
    --Special Summoned by Tributing 1 “Seven Knight Gammamon” you control
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SPSUMMON_PROC)
    e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e4:SetRange(LOCATION_HAND)
    e4:SetValue(1)
    e4:SetCondition(s.spcon)
    e4:SetTarget(s.sptg)
    e4:SetOperation(s.spop)
    c:RegisterEffect(e4)
    --When an attack is declared involving your “Seven Knight” or “Digimon” monster: You can Banish 1 Card in your GY; negate that attack
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(s.negattackcost)
    e3:SetCondition(s.negattackcon)
    e3:SetOperation(s.negattackop)
    c:RegisterEffect(e3)

end
s.listed_series={0x821,0x822,0x823}
s.listed_names={611000096,id}

--Unaffected by Opponent Card Effects
function s.unval(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--Special Summoned by Tributing 1 “Seven Knight Gekkomon” you control
function s.spfilter(c,ft,tp)
    return c:IsCode(611000096)
end
function s.spcon(e,c)
    if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),s.spfilter,1,false,1,true,c,c:GetControler(),nil,false,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,s.spfilter,1,1,false,true,true,c,nil,nil,false,nil)
    if g then
        g:KeepAlive()
        e:SetLabelObject(g)
    return true
    end
    return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    if not g then return end
    Duel.Release(g,REASON_COST)
    g:DeleteGroup()
end

--When an attack is declared involving your “Seven Knight” or “Digimon” monster: You can Banish 1 Card in your GY; negate that attack
function s.negattackcostfilter(c,tp)
    return c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function s.negattackcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.negattackcostfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,s.negattackcostfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.negattackcon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local at=Duel.GetAttackTarget()
    return a:IsControler(tp) and a:IsSetCard({0x821,0x822,0x823}) or at and at:IsControler(tp) and at:IsFaceup() and at:IsSetCard({0x821,0x822,0x823})
end
function s.negattackop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateAttack()
end
