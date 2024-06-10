-- RAKSHIT YADAV 
-- 11356880

-- Now for updating the tables according to the turn

-- G1 (Jane Rolls a 3)
--adding this turn into Audit_Trail TABLE
INSERT INTO Audit_Trail(G_Round, G_Turn, G_Die_Roll, G_Player_ID)
VALUES (1,1,3,3);