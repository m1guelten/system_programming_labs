#include <iostream>
#include <string>
#include "Employee.h"

using namespace std;
namespace Records {
	Employee::Employee()
	{
		mFirstName = "";
		mLastName = "";
		fathersName = "";
		mEmployeeNumber = -1;
		mSalary = kDefaultStartingSalary;
		fHired = false;
	}

	Employee::Employee(string mFirstName,
	string mLastName,
	string fathersName,
	int mEmployeeCode,
	int age,
	Sex sex,
	string address,
	int passportNumber,
	PositionCode positionCode)
	{
		this->mFirstName = mFirstName;
		this->mLastName = mLastName;
		this->fathersName = fathersName;
		this->mEmployeeCode = mEmployeeCode;
		this->age = age;
		this->sex = sex;
		this->address = address;
		this->passportNumber = passportNumber;
		this->positionCode = positionCode;
	}

	void Employee::promote(int inRaiseAmount)
	{
		setSalary(getSalary() + inRaiseAmount);
	}
	void Employee::demote(int inDemeritAmount)
	{
		setSalary(getSalary() - inDemeritAmount);
	}
	void Employee::hire()
	{
		fHired = true;
	}
	void Employee::fire()
	{
		fHired = false;
	}
	void Employee::display()
	{
		cout << "Employee Information" << endl;
		cout << "-------------------" << endl;
		cout << "First Name: " << mFirstName << endl;
		cout << "Last Name: " << mLastName << endl;
		cout << "Father's Name: " << fathersName << endl;
		cout << "Age: " << age << endl;
		cout << "Sex: " << (sex == Sex::Male ? "Male" : "Female") << endl;
		cout << "Address: " << address << endl;
		cout << "Passport Number: " << passportNumber << endl;
		cout << "Position: ";

		switch (positionCode) {
		case PositionCode::Librarian:
			cout << "Position code - Librarian" << endl;
			break;
		case PositionCode::Cataloger:
			cout << "Position code - Cataloger" << endl;
			break;
		case PositionCode::Archivist:
			cout << "Position code - Archivist" << endl;
			break;
		default:
			cout << "Position code - Unknown" << endl;
			break;
		}
	}
	// Accessors and setters
	void Employee::setFirstName(string inFirstName)
	{
		mFirstName = inFirstName;
	}
	string Employee::getFirstName()
	{
		return mFirstName;
	}
	void Employee::setLastName(string inLastName)

	{
		mLastName = inLastName;
	}
	string Employee::getLastName()
	{
		return mLastName;
	}
	void Employee::setEmployeeNumber(int inEmployeeNumber)
	{
		mEmployeeNumber = inEmployeeNumber;
	}
	int Employee::getEmployeeNumber()
	{
		return mEmployeeNumber;
	}
	void Employee::setSalary(int inSalary)
	{
		mSalary = inSalary;
	}
	int Employee::getSalary()
	{
		return mSalary;
	}
	bool Employee::getIsHired()
	{
		return fHired;
	}

	std::string Employee::getFathersName()  {
		return fathersName;
	}

	void Employee::setFathersName( std::string& name) {
		fathersName = name;
	}

	int Employee::getEmployeeCode()  {
		return mEmployeeCode;
	}

	void Employee::setEmployeeCode(int code) {
		mEmployeeCode = code;
	}

	int Employee::getAge()  {
		return age;
	}

	void Employee::setAge(int employeeAge) {
		age = employeeAge;
	}

	Sex Employee::getSex()  {
		return sex;
	}

	void Employee::setSex(Sex employeeSex) {
		sex = employeeSex;
	}

	std::string Employee::getAddress()  {
		return address;
	}

	void Employee::setAddress( std::string& employeeAddress) {
		address = employeeAddress;
	}

	int Employee::getPassportNumber()  {
		return passportNumber;
	}

	void Employee::setPassportNumber(int number) {
		passportNumber = number;
	}

	PositionCode Employee::getPositionCode()  {
		return positionCode;
	}

	void Employee::setPositionCode(PositionCode code) {
		positionCode = code;
	}

	bool Employee::isAdult() {
		return age >= 18;
	}
}