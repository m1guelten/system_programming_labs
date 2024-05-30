#include <iostream>
#include <stdexcept>
#include <string>
#include "Database.h"
using namespace std;
using namespace Records;
int displayMenu();
void doHire(Database& inDB);
void doFire(Database& inDB);
void doPromote(Database& inDB);
void doDemote(Database& inDB);

int main(int argc, char** argv)
{
	Database employeeDB;

	Employee employeeOnStack("FFF", "ddd", "rrr", 123, 20, Sex::Male, "New York", 123, PositionCode::Librarian);

	employeeOnStack.display();

	Employee* employeeOnHeap = new Employee("aaa", "bbb", "ccc", 321, 21, Sex::Male, "LA", 321, PositionCode::Cataloger);

	employeeOnHeap->display();

	delete employeeOnHeap;

	bool done = false;
	while (!done) {
		int selection = displayMenu();
		switch (selection) {
		case 1:
			doHire(employeeDB);
			break;
		case 2:
			doFire(employeeDB);
			break;
		case 3:
			doPromote(employeeDB);
			break;
		case 4:
			employeeDB.displayAll();
			break;
		case 5:
			employeeDB.displayCurrent();
			break;
		case 6:
			employeeDB.displayFormer();
			break;
		case 7:
			employeeDB.displayAdult();
			break;
		case 0:
			done = true;
			break;
		default:
			cerr << "Unknown command." << endl;
		}
	}
}
int displayMenu()
{
	int selection;
	cout << endl;
	cout << "Employee Database" << endl;
	cout << "-----------------" << endl;
	cout << "1) Hire a new employee" << endl;
	cout << "2) Fire an employee" << endl;
	cout << "3) Promote an employee" << endl;
	cout << "4) List all employees" << endl;
	cout << "5) List all current employees" << endl;
	cout << "6) List all previous employees" << endl;
	cout << "7) List all adult employees" << endl;
	cout << "0) Quit" << endl;
	cout << endl;

	cout << "---> ";
	cin >> selection;
	return selection;
}
void doHire(Database& inDB) {
	string firstName;
	string lastName;
	string fathersName;
	int age;
	int sexInt;
	Sex sex;
	string address;
	int passportNumber;
	int positionCodeInt;
	PositionCode positionCode;

	cout << "First name? ";
	cin >> firstName;
	cout << "Last name? ";
	cin >> lastName;
	cout << "Father's name? ";
	cin >> fathersName;
	cout << "Age? ";
	cin >> age;
	cout << "Sex (0 for Male, 1 for Female)? ";
	cin >> sexInt;
	sex = (sexInt == 0) ? Sex::Male : Sex::Female;
	cout << "Address? ";
	cin >> address;
	cout << "Passport number? ";
	cin >> passportNumber;
	cout << "Position code (0 for Librarian, 1 for Cataloger, 2 for Archivist)? ";
	cin >> positionCodeInt;
	positionCode = static_cast<PositionCode>(positionCodeInt);

	try {
		inDB.addEmployee(firstName, lastName, fathersName, age, sex, address, passportNumber, positionCode);
	}
	catch (exception& ex) {
		cerr << "Unable to add new employee!" << endl;
	}
}

void doFire(Database& inDB)
{
	int employeeNumber;
	cout << "Employee number? ";
	cin >> employeeNumber;
	try {
		Employee& emp = inDB.getEmployee(employeeNumber);
		emp.fire();
		cout << "Employee " << employeeNumber << " has been terminated." << endl;
	}
	catch (std::exception ex) {
		cerr << "Unable to terminate employee!" << endl;
	}
}
void doPromote(Database& inDB)
{
	int employeeNumber;
	int raiseAmount;
	cout << "Employee number? ";
	cin >> employeeNumber;
	cout << "How much of a raise? ";
	cin >> raiseAmount;
	try {

		Employee& emp = inDB.getEmployee(employeeNumber);
		emp.promote(raiseAmount);
	}
	catch (...) {
		cerr << "Unable to promote employee!" << endl;
	}
}