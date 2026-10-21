-- add OCG card name
--Seven Knight Dukumon
local s,id,o=GetID()
function s.initial_effect(c)
    --Unaffected by Opponent Card Effects
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetValue(s.unval)
    c:RegisterEffect(e1)
    --Monsters you control cannot be destroyed by battle
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(s.indtg)
    e2:SetValue(1)
    c:RegisterEffect(e2)
end
s.listed_series={0x821,0x823}
s.listed_names={id}

--Unaffected by Opponent Card Effects
function s.unval(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--Monsters you control cannot be destroyed by battle
function s.indtg(e,c)
    return c~=e:GetHandler()
end
