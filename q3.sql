-- RAKSHIT YADAV 
-- 11356880

-- Now for updating the tables according to the turn

-- G3 (Mary Rolls a 4)
--adding this turn into Audit_Trail TABLE
INSERT INTO Audit_Trail(G_Round, G_Turn, G_Die_Roll, G_Player_ID)
VALUES (1,3,4,1);