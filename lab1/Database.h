#include <iostream>
#include "Employee.h"
#include <string>

using namespace std;

namespace Records {
	const int kMaxEmployees = 100;
	const int kFirstEmployeeNumber = 1000;
	class Database
	{
	public:
		Database();
		~Database();
		Employee& addEmployee(
			string firstName,
			string lastName,
			string fathersName,
			int age,
			Sex sex,
			string address,
			int passportNumber,
			PositionCode positionCode);
		Employee& getEmployee(int inEmployeeNumber);
		Employee& getEmployee(std::string inFirstName, std::string inLastName);
		void displayAll();
		void displayCurrent();
		void displayFormer();
		void displayAdult();
	protected:
		Employee mEmployees[kMaxEmployees];
		int mNextSlot;
		int mNextEmployeeNumber;
	};
}
