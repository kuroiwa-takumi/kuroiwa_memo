--MySQL
-- DML: Data Insertion
START TRANSACTION;
INSERT INTO Shohin VALUES ('0001', 'T-shirt', 'Clothing', 1000, 500, '2009-09-20');
INSERT INTO Shohin VALUES ('0002', 'Hole Punch', 'Office Supplies', 500, 320, '2009-09-11');
INSERT INTO Shohin VALUES ('0003', 'Dress Shirt', 'Clothing', 4000, 2800, NULL);
INSERT INTO Shohin VALUES ('0004', 'Kitchen Knife', 'Kitchen Supplies', 3000, 2800, '2009-09-20');
INSERT INTO Shohin VALUES ('0005', 'Pressure Cooker', 'Kitchen Supplies', 6800, 5000, '2009-01-15');
INSERT INTO Shohin VALUES ('0006', 'Fork', 'Kitchen Supplies', 500, NULL, '2009-09-20');
INSERT INTO Shohin VALUES ('0007', 'Grater', 'Kitchen Supplies', 880, 790, '2008-04-28');
INSERT INTO Shohin VALUES ('0008', 'Ballpoint Pen', 'Office Supplies', 100, NULL, '2009-11-11');
COMMIT;
