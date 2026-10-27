-- add OCG card name
--Arrester Digital Cosmo
--Scripted by Trí Dũng Song Toàn
local s,id,o=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --While you control a “Arresterderdramon” or “Arresterdramon” monster, the effects of all face-up cards your opponent controls are negated
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DISABLE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(0,LOCATION_ONFIELD)
    e2:SetCondition(s.econ)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CHAIN_SOLVING)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(s.econ)
    e3:SetOperation(s.disop)
    c:RegisterEffect(e3)
    --Once per turn, during your opponent End Phase: Inflict 300 damage to your opponent for each monster you control
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetCountLimit(1)
    e4:SetCondition(s.dmgcon)
    e4:SetTarget(s.dmgtg)
    e4:SetOperation(s.dmgop)
    c:RegisterEffect(e4)
    --Once per turn, during your End Phase: Banish 1 “Seven Knight” or “Digimon” Monster you control or in your GY or send this card to the GY
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,2))
    e5:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetRange(LOCATION_FZONE)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetCountLimit(1)
    e5:SetCondition(s.bancon)
    e5:SetOperation(s.banop)
    c:RegisterEffect(e5)
end

--While you control a “Arresterderdramon” or “Arresterdramon” monster, the effects of all face-up cards your opponent controls are negated
function s.disfilter(c)
    return c:IsSetCard({0x825,0x826}) and c:IsFaceup()
end
function s.econ(e,tp,eg,ep,ev,re,r,rp)
    local tp = e:GetHandlerPlayer()
    return Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if rp~=tp and (tl==LOCATION_MZONE or tl==LOCATION_SZONE) then
        Duel.NegateEffect(ev)
    end
end
--Once per turn, during your opponent End Phase: Inflict 300 damage to your opponent for each monster you control
function s.dmgcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsTurnPlayer(1-tp)
end
function s.dmgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
    Duel.SetTargetPlayer(1-tp)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
end
function s.dmgop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
    Duel.Damage(p,ct*300,REASON_EFFECT)
end

--Once per turn, during your End Phase: Banish 1 “Seven Knight” or “Digimon” Monster you control or in your GY or send this card to the GY
function s.bancon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsTurnPlayer(tp)
end
function s.banfilter(c)
    return c:IsMonster() and (c:IsSetCard(0x821) or c:IsSetCard(0x823)) and c:IsAbleToRemove()
end
function s.bangroup(e,tp)
    return Duel.GetMatchingGroup(s.banfilter, tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
end
function s.banselect(tp)
    return Duel.SelectEffect(tp,{true,aux.Stringid(id,3)},{true,aux.Stringid(id,4)}) or 2
end
function s.banremove(e,tp,g)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local sg=g:Select(tp,1,1,nil)
    Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function s.banself(e)
    Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function s.banop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,id)
    
    local g=s.bangroup(e,tp)
    if #g==0 then
        s.banself(e)
        return
    end
    
    local op=s.banselect(tp)
    if op==1 then
        s.banremove(e,tp,g)
    else
        s.banself(e)
    end
end

