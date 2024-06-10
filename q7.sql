-- RAKSHIT YADAV 
-- 11356880

-- Now for updating the tables according to the turn

-- G7 (Mary Rolls a 6, then a 5)
--adding this turn into Audit_Trail TABLE
INSERT INTO Audit_Trail(G_Round, G_Turn, G_Die_Roll, G_Player_ID)
VALUES (2,7,5,1);