-- RAKSHIT YADAV 
-- 11356880

-- Now for updating the tables according to the turn

-- G5 (Jane Rolls a 5)
--adding this turn into Audit_Trail TABLE
INSERT INTO Audit_Trail(G_Round, G_Turn, G_Die_Roll, G_Player_ID)
VALUES (2,5,5,3);