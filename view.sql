-- RAKSHIT YADAV 
-- 11356880

-- now to create a view named 'gameView'
-- i am displaying the player information with their current location, currnet balance,
-- and properties they owned
CREATE VIEW gameView AS
SELECT P.Player_ID AS ID, P.Player_Name AS Player, P.Player_Token as Token, 
P.Player_C_Location AS "Current Location", P.Bank_Balance AS "Current Balance (in £)",
(SELECT GROUP_CONCAT(Prop_Name) FROM Owned_Properties WHERE Owner_ID = P. Player_ID)
AS "Property(s) Owned" -- GROUP_CONCAT was used to merge names from Prop_Name based
                       -- on Owner_id so as to display multiple properties together,
                       -- owned by one player in the resulting view 
FROM Players AS P
ORDER BY P.Bank_Balance DESC; -- descending order by balance to see in view
                              -- who is ahead in the game.

SELECT * FROM gameView;