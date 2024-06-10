-- RAKSHIT YADAV 
-- 11356880

-- the creation command in the order in which they should be created to 
-- make sure no foreign key constraint errors are faced

CREATE TABLE Location(
    Location_Type VARCHAR(50) PRIMARY KEY
);


CREATE TABLE Bonuses (
    Bonus_ID INT PRIMARY KEY ,
    Bonus_Name VARCHAR(50) NOT NULL UNIQUE,
    Bonus_Type VARCHAR(100) NOT NULL,
    Bonus_Description VARCHAR(1000) NOT NULL,
    FOREIGN KEY (Bonus_Type) REFERENCES Location(Location_Type)
);


CREATE TABLE Tokens (
    Token_Name VARCHAR(50) PRIMARY KEY
);


CREATE TABLE Properties (
    Property_Name VARCHAR(100) PRIMARY KEY ,
    Property_Cost INT NOT NULL,
    Property_Colour VARCHAR(20) NOT NULL,
    Property_Location_Type VARCHAR(50) NOT NULL,
    FOREIGN KEY (Property_Location_Type) REFERENCES Location(Location_Type)
);


CREATE TABLE Monopoly_Board (
    Board_Location_Name VARCHAR(100) PRIMARY KEY,
    Board_Location_Number INT NOT NULL,
    Board_Location_Type VARCHAR(50) NOT NULL,
    FOREIGN KEY (Board_Location_Type) REFERENCES Location(Location_Type)
);

CREATE TABLE Players (
    Player_ID INT PRIMARY KEY,
    Player_Name VARCHAR(50) NOT NULL,
    Player_Token INT NOT NULL,
    Bank_Balance INT NOT NULL DEFAULT 0,
    Player_C_Location VARCHAR(100) NOT NULL,
    Any_Bonuses INT,-- this can be null as not everyone has a bonus
    FOREIGN KEY (Player_C_Location) REFERENCES Monopoly_Board(Board_Location_Name),
    FOREIGN KEY (Any_Bonuses) REFERENCES Bonuses(Bonus_ID),
    FOREIGN KEY (Player_Token) REFERENCES Tokens(Token_Name)
);


CREATE TABLE Owned_Properties (
    Prop_Name VARCHAR(100),
    Owner_ID INT,
    PRIMARY KEY(Prop_Name,Owner_ID),
    FOREIGN KEY (Prop_Name) REFERENCES Properties(Property_Name),
    FOREIGN KEY (Owner_ID) REFERENCES Players(Player_ID)
);


CREATE TABLE Audit_Trail (
    G_Round INT NOT NULL DEFAULT 0,
	G_Turn INT NOT NULL DEFAULT 1,
	G_Die_Roll INT NOT NULL,
    G_Player_ID INT NOT NULL,
    G_Player_Name VARCHAR(50) ,
    G_Player_Location VARCHAR(100) ,
    G_Bank_Balance INT DEFAULT 0,
    PRIMARY KEY (G_Round, G_Player_ID),
    FOREIGN KEY (G_Player_Location) REFERENCES Monopoly_Board(Board_Location_Name),
    FOREIGN KEY (G_Player_ID) REFERENCES Players(Player_ID)
);


-- this is the trigger which will be triggered when insert command for Jane turn 1 is applied on Audit_Trail table 
CREATE TRIGGER Turn_Updater_Trigger_1
AFTER INSERT ON Audit_Trail
FOR EACH ROW -- this will be done for every row
-- Determine the specific turn based on G_Turn
WHEN NEW.G_Turn = 1
BEGIN
      -- Update the Player's location and balance based on their roll
      UPDATE Players
      SET Player_C_Location = (
        SELECT Monopoly_Board.Board_Location_Name -- selecting Location name base on the location number
        FROM Monopoly_Board
        WHERE Monopoly_Board.Board_Location_Number = (
          SELECT (Monopoly_Board.Board_Location_Number + 3) % 16 -- by using location number i can use 
          FROM Monopoly_Board                               -- this code for all of the players by using the die number rolled
          WHERE Monopoly_Board.Board_Location_Name = (
			SELECT Player_C_Location                    -- extracting the player location name by it's ID and Player's table
			FROM Players                                -- also to just generalise the query for all players
			WHERE Player_ID = NEW.G_Player_ID
            )
        )
      ),
      Bank_Balance = Bank_Balance + 200  -- because she landed on "GO" (Rule R4)	
      WHERE Player_ID = NEW.G_Player_ID;

      -- Update the other values in the Audit_Trail table
      UPDATE Audit_Trail
      SET G_Player_Name = (
        SELECT Players.Player_Name
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
      ),
      G_Player_Location = (
        SELECT Players.Player_C_Location
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
      ),
      G_Bank_Balance = (
        SELECT Players.Bank_Balance
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
      )
      WHERE G_Player_ID = NEW.G_Player_ID AND G_Turn = NEW.G_Turn;
END;

-- this is the trigger which will be triggered when insert command for Norman turn 1 is applied on Audit_Trail table 
CREATE TRIGGER Turn_Updater_Trigger_2
AFTER INSERT ON Audit_Trail
FOR EACH ROW -- this will be done for every row
-- Determine the specific turn based on G_Turn
WHEN NEW.G_Turn = 2 --this command will make sure in every trigger that not all triggers are activated when Insert comannd on Audit_Trail table is executed
BEGIN
      -- Update the Player's location and balance based on their roll
      UPDATE Players
      SET Player_C_Location = (
        SELECT Monopoly_Board.Board_Location_Name
        FROM Monopoly_Board
        WHERE Monopoly_Board.Board_Location_Number = (
          SELECT (Monopoly_Board.Board_Location_Number + 1) % 16
          FROM Monopoly_Board
          WHERE Monopoly_Board.Board_Location_Name = (
			SELECT Player_C_Location 
			FROM Players
			WHERE Player_ID = NEW.G_Player_ID
			)
		)
	),
      Bank_Balance = Bank_Balance -150  -- because he landed on "Chance 1" (Referring to Bonuses Table)	
      WHERE Player_ID = NEW.G_Player_ID;

      --Update the bank balance of other players (excludint Norman)
      UPDATE Players
      SET Bank_Balance = Bank_Balance + 50
      WHERE Player_ID != NEW.G_Player_ID;
	  
      -- Update the other values in the Audit_Trail table
      UPDATE Audit_Trail
      SET G_Player_Name = (
        SELECT Players.Player_Name
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
      ),
      G_Player_Location = (
        SELECT Players.Player_C_Location
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
      ),
      G_Bank_Balance = (
        SELECT Players.Bank_Balance
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
      )
      WHERE G_Player_ID = NEW.G_Player_ID AND G_Turn = NEW.G_Turn;
END;

-- this is the trigger which will be triggered when insert command for Mary turn 1 is applied on Audit_Trail table 
CREATE TRIGGER Turn_Updater_Trigger_3
AFTER INSERT ON Audit_Trail
FOR EACH ROW -- this will be done for every row
-- Determine the specific turn based on G_Turn
WHEN NEW.G_Turn = 3 --this command will make sure in every trigger that not all triggers are activated when Insert comannd on Audit_Trail table is executed
BEGIN
    -- Update the Player's location and balance based on their roll
    UPDATE Players
        SET Player_C_Location = (
        SELECT Monopoly_Board.Board_Location_Name
        FROM Monopoly_Board
        WHERE Monopoly_Board.Board_Location_Number = (
            SELECT (Monopoly_Board.Board_Location_Number + 4 + 8) % 16 -- +8 because she goes to "IN JAIL" (Rule R6)
            FROM Monopoly_Board
            WHERE Monopoly_Board.Board_Location_Name = (
			    SELECT Player_C_Location 
			    FROM Players
			    WHERE Player_ID = NEW.G_Player_ID
			    )
		    )
    	),
    Bank_Balance = Bank_Balance,-- because she landed on "GO TO JAIL" (Rule R6)	
	Any_Bonuses = NULL
    WHERE Player_ID = NEW.G_Player_ID;

    -- Update the other values in the Audit_Trail table
    UPDATE Audit_Trail
    SET G_Player_Name = (
        SELECT Players.Player_Name
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
        ),
    G_Player_Location = (
        SELECT Players.Player_C_Location
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
        ),
    G_Bank_Balance = (
        SELECT Players.Bank_Balance
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
        )
    WHERE G_Player_ID = NEW.G_Player_ID AND G_Turn = NEW.G_Turn;
END;

-- this is the trigger which will be triggered when insert command for Bill turn 1 is applied on Audit_Trail table 
CREATE TRIGGER Turn_Updater_Trigger_4
AFTER INSERT ON Audit_Trail
FOR EACH ROW -- this will be done for every row
-- Determine the specific turn based on G_Turn
WHEN NEW.G_Turn = 4 --this command will make sure in every trigger that not all triggers are activated when Insert comannd on Audit_Trail table is executed
BEGIN
      -- Update the Player's location and balance based on their roll
    UPDATE Players
    SET Player_C_Location = (
        SELECT Monopoly_Board.Board_Location_Name
        FROM Monopoly_Board
        WHERE Monopoly_Board.Board_Location_Number = (
            SELECT (Monopoly_Board.Board_Location_Number + 2) % 16
            FROM Monopoly_Board
            WHERE Monopoly_Board.Board_Location_Name = (
			    SELECT Player_C_Location 
			    FROM Players
			    WHERE Player_ID = NEW.G_Player_ID
			)
		)
	),
    Bank_Balance = Bank_Balance -400  -- because he landed on "AMBS" and has to buy it (Rule R1)	
    WHERE Player_ID = NEW.G_Player_ID;

    -- Updating the Owned_Properties Table with the new purchased property
    INSERT INTO Owned_Properties
    VALUES ('AMBS', NEW.G_Player_ID);
	  
    -- Update the other values in the Audit_Trail table
    UPDATE Audit_Trail
    SET G_Player_Name = (
        SELECT Players.Player_Name
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
    ),
    G_Player_Location = (
        SELECT Players.Player_C_Location
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
    ),
    G_Bank_Balance = (
        SELECT Players.Bank_Balance
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
      )
    WHERE G_Player_ID = NEW.G_Player_ID AND G_Turn = NEW.G_Turn;
END;

-- this is the trigger which will be triggered when insert command for Jane round 2 turn is applied on Audit_Trail table 
CREATE TRIGGER Turn_Updater_Trigger_5
AFTER INSERT ON Audit_Trail
FOR EACH ROW -- this will be done for every row
-- Determine the specific turn based on G_Turn
WHEN NEW.G_Turn = 5 --this command will make sure in every trigger that not all triggers are activated when Insert comannd on Audit_Trail table is executed
BEGIN
      -- Update the Player's location and balance based on their roll
    UPDATE Players
    SET Player_C_Location = (
        SELECT Monopoly_Board.Board_Location_Name
        FROM Monopoly_Board
        WHERE Monopoly_Board.Board_Location_Number = (
            SELECT (Monopoly_Board.Board_Location_Number + 5) % 16
            FROM Monopoly_Board
            WHERE Monopoly_Board.Board_Location_Name = (
			    SELECT Player_C_Location 
			    FROM Players
			    WHERE Player_ID = NEW.G_Player_ID
			)
		)
	),
    Bank_Balance = Bank_Balance -75  --because She landed on "Victoria" and has to pay rent (Rule R2)	
    WHERE Player_ID = NEW.G_Player_ID;

    -- Updating Bill Balance (he owns Victoria) with the new rent from Jane
    UPDATE Players
    SET Bank_Balance = Bank_Balance + 75
		WHERE Player_Name = (
			SELECT P.Player_Name
			FROM Players AS P
			WHERE P.Player_ID = (SELECT O.Owner_ID FROM Owned_Properties AS O WHERE O.Prop_Name = 'Victoria'
			)
		);
	
    -- Update the other values in the Audit_Trail table
    UPDATE Audit_Trail
    SET G_Player_Name = (
        SELECT Players.Player_Name
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
    ),
    G_Player_Location = (
        SELECT Players.Player_C_Location
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
    ),
    G_Bank_Balance = (
        SELECT Players.Bank_Balance
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
      )
    WHERE G_Player_ID = NEW.G_Player_ID AND G_Turn = NEW.G_Turn;
END;

-- this is the trigger which will be triggered when insert command for Norman round 2 turn is applied on Audit_Trail table 
CREATE TRIGGER Turn_Updater_Trigger_6
AFTER INSERT ON Audit_Trail
FOR EACH ROW -- this will be done for every row
-- Determine the specific turn based on G_Turn
WHEN NEW.G_Turn = 6 --this command will make sure in every trigger that not all triggers are activated when Insert comannd on Audit_Trail table is executed
BEGIN
      -- Update the Player's location and balance based on their roll
    UPDATE Players
    SET Player_C_Location = (
        SELECT Monopoly_Board.Board_Location_Name
        FROM Monopoly_Board
        WHERE Monopoly_Board.Board_Location_Number = (
            SELECT (Monopoly_Board.Board_Location_Number + 4) % 16
            FROM Monopoly_Board
            WHERE Monopoly_Board.Board_Location_Name = (
			    SELECT Player_C_Location 
			    FROM Players
			    WHERE Player_ID = NEW.G_Player_ID
			)
		)
	),
    Bank_Balance = Bank_Balance + 100   --because He landed on "Community Chest 1" and wins a beauty contest and wins £100 (Rule R2)	
    WHERE Player_ID = NEW.G_Player_ID;

    -- Update the other values in the Audit_Trail table
    UPDATE Audit_Trail
    SET G_Player_Name = (
        SELECT Players.Player_Name
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
    ),
    G_Player_Location = (
        SELECT Players.Player_C_Location
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
    ),
    G_Bank_Balance = (
        SELECT Players.Bank_Balance
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
      )
    WHERE G_Player_ID = NEW.G_Player_ID AND G_Turn = NEW.G_Turn;
END;

-- this is the trigger which will be triggered when insert command for Mary round 2 turn is applied on Audit_Trail table 
CREATE TRIGGER Turn_Updater_Trigger_7
AFTER INSERT ON Audit_Trail
FOR EACH ROW -- this will be done for every row
-- Determine the specific turn based on G_Turn
WHEN NEW.G_Turn = 7 --this command will make sure in every trigger that not all triggers are activated when Insert comannd on Audit_Trail table is executed
BEGIN
      -- Update the Player's location and balance based on their roll
      -- Mary rolls 6, she is free from jail (Rule R3), then rolls a 5 and go to "Oak House"
    UPDATE Players
    SET Player_C_Location = (
        SELECT Monopoly_Board.Board_Location_Name
        FROM Monopoly_Board
        WHERE Monopoly_Board.Board_Location_Number = (
            SELECT (Monopoly_Board.Board_Location_Number + 5) % 16 --she also rolled a 6, but that was used to free her from jail
            FROM Monopoly_Board
            WHERE Monopoly_Board.Board_Location_Name = (
			    SELECT Player_C_Location 
			    FROM Players
			    WHERE Player_ID = NEW.G_Player_ID
			)
		)
	),
    -- "Oak House" owned by Norman and he also owns both yellow properties, so rent is £100 x 2
    -- Rule R2
    Bank_Balance = Bank_Balance - 200 
    WHERE Player_ID = NEW.G_Player_ID;

    -- Updating Norman's Balance 
    UPDATE Players
    SET Bank_Balance = Bank_Balance + 200
		WHERE Player_Name = (
			SELECT P.Player_Name
			FROM Players AS P
			WHERE P.Player_ID = (SELECT O.Owner_ID FROM Owned_Properties AS O WHERE O.Prop_Name = 'Oak House'
			)
		);

    -- Update the other values in the Audit_Trail table
    UPDATE Audit_Trail
    SET G_Player_Name = (
        SELECT Players.Player_Name
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
    ),
    G_Player_Location = (
        SELECT Players.Player_C_Location
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
    ),
    G_Bank_Balance = (
        SELECT Players.Bank_Balance
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
      )
    WHERE G_Player_ID = NEW.G_Player_ID AND G_Turn = NEW.G_Turn;
END;

-- this is the trigger which will be triggered when insert command for Bill round 2 turn is applied on Audit_Trail table 
CREATE TRIGGER Turn_Updater_Trigger_8
AFTER INSERT ON Audit_Trail
FOR EACH ROW -- this will be done for every row
-- Determine the specific turn based on G_Turn
WHEN NEW.G_Turn = 8 --this command will make sure in every trigger that not all triggers are activated when Insert comannd on Audit_Trail table is executed
BEGIN
      -- Update the Player's location and balance based on their roll
      -- Bill rolls 6, he lands on "Uni Place" but doesn't have to pay any rent (Rule R4)
      -- Then he rolls again immediately and rolls 5
    UPDATE Players
    SET Player_C_Location = (
        SELECT Monopoly_Board.Board_Location_Name
        FROM Monopoly_Board
        WHERE Monopoly_Board.Board_Location_Number = (
            SELECT (Monopoly_Board.Board_Location_Number + 6 + 3) % 16 -- representing he rolled a 6, and then a 3
            FROM Monopoly_Board
            WHERE Monopoly_Board.Board_Location_Name = (
			    SELECT Player_C_Location 
			    FROM Players
			    WHERE Player_ID = NEW.G_Player_ID
			)
		)
	),
    -- Bill passed "GO", so he gets +£200 (Rule R4), and he landed on "Community Chest 1" and won a beauty contest and won +£100
    Bank_Balance = Bank_Balance + 200 + 100 
    WHERE Player_ID = NEW.G_Player_ID;


    -- Update the other values in the Audit_Trail table
    UPDATE Audit_Trail
    SET G_Player_Name = (
        SELECT Players.Player_Name
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
    ),
    G_Player_Location = (
        SELECT Players.Player_C_Location
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
    ),
    G_Bank_Balance = (
        SELECT Players.Bank_Balance
        FROM Players
        WHERE Players.Player_ID = NEW.G_Player_ID
      )
    WHERE G_Player_ID = NEW.G_Player_ID AND G_Turn = NEW.G_Turn;
END;
