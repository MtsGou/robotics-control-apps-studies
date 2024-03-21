function ang = AjustaAngulo(ang)

ang = mod(ang, 2*pi);

if (ang > pi)
    ang = ang - 2*pi;
end

if (ang < - pi)
    ang = ang + 2*pi;
end

end


