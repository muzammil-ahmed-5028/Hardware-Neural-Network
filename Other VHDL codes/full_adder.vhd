ENTITY fa IS
PORT ( 
	a,b,cin: IN BIT;
	sum,cout: OUT BIT);
END ENTITY fa;

ARCHITECTURE boolean_eq OF fa IS
BEGIN
	sum <= a XOR b XOR cin;
	cout <= (a AND b) OR (a AND cin) OR (b AND cin);
END ARCHITECTURE boolean_eq;
