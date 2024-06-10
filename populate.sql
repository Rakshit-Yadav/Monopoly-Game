-- RAKSHIT YADAV 
-- 11356880

INSERT INTO Location VALUES 
('Corner'),
('Chance'),
('Community-Chest'),
('Property')
;


INSERT INTO Bonuses VALUES
(1, 'Chance 1','Chance','Pay each of the other player £50'),
(2, 'Chance 2','Chance','Move forward 3 spaces'),
(3, 'Community Chest 1','Community-Chest','For winning a beauty Contest, you win £100'),
(4, 'Community Chest 2','Community-Chest','Your library books are overdue. Pay a fine of £30'),
(5, 'Free Parking', 'Corner','No action'),
(6, 'Go to Jail', 'Corner', 'Go to Jail, do not pass GO, do not collect £200'),
(7, 'GO', 'Corner', 'Collect £200')
;


INSERT INTO Tokens VALUES
('Dog'),
('Car'),
('Battleship'),
('Top-Hat'),
('Thimble'),
('Boot')
;


INSERT INTO Properties VALUES
('Oak House',100,'Orange','Property'),
('Owens Park',30,'Orange','Property'),
('AMBS',400,'Blue','Property'),
('Co-Op',30,'Blue','Property'),
('Kilburn',120,'Yellow','Property'),
('Uni Place',100,'Yellow','Property'),
('Victoria',75,'Green','Property'),
('Piccadilly',35,'Green','Property')
;


INSERT INTO Monopoly_Board VALUES 
('GO', 1, 'Corner'),
('Kilburn',2, 'Property'),
('Chance 1',3, 'Chance'),
('Uni Place',4, 'Property'),
('In Jail', 5, 'Corner'),
('Victoria', 6, 'Property'),
('Community Chest 1', 7, 'Community-Chest'),
('Picadilly', 8, 'Property'),
('Free Parking', 9, 'Corner'),
('Oak House', 10, 'Property'),
('Chance 2', 11, 'Chance'),
('Owens Park', 12, 'Property'),
('Go To Jail', 13, 'Corner'),
('AMBS', 14, 'Property'),
('Community Chest 2', 15, 'Community-Chest'),
('Co-Op', 16, 'Property')
;


INSERT INTO Players VALUES
(1, 'Mary', 'Battleship', 190, 'Free Parking', 5),
(2, 'Bill', 'Dog', 500, 'Owens Park', NULL),
(3, 'Jane', 'Car', 150, 'AMBS', NULL),
(4, 'Norman', 'Thimble', 250, 'Kilburn', NULL)
;


INSERT INTO Owned_Properties VALUES
('Uni Place', 1),
('Victoria', 2),
('Co-Op', 3),
('Oak House', 4),
('Owens Park', 4)
;