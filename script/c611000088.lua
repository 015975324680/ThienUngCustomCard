-- add OCG card name
--Seven Knight Gaiamon
--Scripted by Trí Dũng Song Toàn
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
    --Battle damage of other “Digimon” or “Seven Knight” monsters is doubled
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(function(e,c) return (c:IsSetCard(0x821) or c:IsSetCard(0x823)) and not c:IsCode(id) end)
    e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
    c:RegisterEffect(e3)
end
s.listed_series={0x821,0x823}
s.listed_names={id}

--Unaffected by Opponent Card Effects
function s.unval(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end


