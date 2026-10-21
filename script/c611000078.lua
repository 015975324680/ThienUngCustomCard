-- add OCG card name
--Brave Snatcher
local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddEquipProcedure(c)
    --if you have exactly 6 “Seven Knight” Monster in your GY: You can Destroy all face-up Monsters your opponent controls, and if you do, inflict damage to your opponent equal to the combined ATK of those destroyed monster(s)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_STZONE)
    e1:SetCountLimit(1,{id,1})
    e1:SetCondition(s.descon)
    e1:SetTarget(s.destg)
    e1:SetOperation(s.desop)
    c:RegisterEffect(e1)
    --Your opponent cannot Tribute Monster equipped with this card
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UNRELEASABLE_SUM)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetValue(s.sumlimit)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e3)
    local e4=e2:Clone()
    e4:SetCode(EFFECT_CANNOT_RELEASE)
    c:RegisterEffect(e4)
    --or target it with card effects
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e5:SetValue(aux.tgoval)
    c:RegisterEffect(e5)
end
s.listed_series={0x823}
s.listed_names={id}

--Your opponent cannot Tribute Monster equipped with this card
function s.sumlimit(e,c)
    if not c then return false end
    local tp=e:GetHandler():GetControler()
    return c:IsControler(1-tp)
end

--if you have exactly 6 “Seven Knight” Monster in your GY: You can Destroy all face-up Monsters your opponent controls, and if you do, inflict damage to your opponent equal to the combined ATK of those destroyed monster(s)
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x823)==6
end
function s.desfilter(c)
    return c:IsFaceup()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
    if chk==0 then return #g>0 end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not (c:IsRelateToEffect(e) and c:IsFaceup()) then return end
    local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
    if #g==0 then return end
    Duel.Destroy(g,REASON_EFFECT)
    
    local dg=Duel.GetOperatedGroup()
    local tc=dg:GetFirst()
    local dam=0
    for tc in aux.Next(dg) do
        local atk=tc:GetTextAttack()
        if atk<0 then atk=0 end
        dam=dam+atk
    end
    Duel.Damage(1-tp,dam,REASON_EFFECT)
end
