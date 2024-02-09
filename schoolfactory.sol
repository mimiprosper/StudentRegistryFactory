// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* 
This factory contract deploys instances of the StudentRegistry contract. 
1. Each time you call createStudentRegistry(), a new instance of StudentRegistry is deployed.
2. Also its address is stored in the deployedRegistries array. 
3. You can also retrieve the count of deployed registries using the getDeployedRegistriesCount() function.
*/

// Factory contarct for School Registration, a CRUD operation
contract StudentRegistryFactory {
    address public owner;

    //stores the address of the deployed registries
    address[] public deployedRegistries;

    // Event to log address of newly deployed contracts
    event StudentRegistryDeployed(
        address indexed registryAddress,
        address indexed owner
    );

    constructor() {
        owner = msg.sender;
    }

    // Create a new StudentRegistry contract and store its address in deployRegistries
    function createStudentRegistry() public returns (address) {
        // Create a new instance of StudentRegistry and add it to the deployedRegistries array
        StudentRegistry newRegistry = new StudentRegistry();
        deployedRegistries.push(address(newRegistry));

        // Event to log address of newly deployed contracts
        emit StudentRegistryDeployed(address(newRegistry), msg.sender);
        return address(newRegistry);
    }

    // Get the count of deployed registries
    function getDeployedRegistriesCount() public view returns (uint) {
        return deployedRegistries.length;
    }
}

// Student Registration, a CRUD operation
contract StudentRegistry {
    address public owner;

    // Student Structure
    struct Student {
        string name;
        uint age;
        string rollNumber;
        bool exists;
    }

    // Teacher Structure
    struct Teacher {
        string name;
        uint age;
        string subject;
        bool exists;
    }

    // teacher mapping
    mapping(address => Teacher) public teachers;

    // student mapping
    mapping(address => Student) public students;

    // only priciple can perform this action
    modifier principle() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Teacher Registration Records
    function registerTeacher(
        address _teacherAddress,
        string memory _name,
        uint _age,
        string memory _subject
    ) public principle {
        require(
            !teachers[_teacherAddress].exists,
            "Teacher already registered"
        );

        Teacher memory newTeacher = Teacher({
            name: _name,
            age: _age,
            subject: _subject,
            exists: true
        });

        teachers[_teacherAddress] = newTeacher;
    }

    // Student Registration Records
    function registerStudent(
        address _studentAddress,
        string memory _name,
        uint _age,
        string memory _rollNumber
    ) public principle {
        require(
            !students[_studentAddress].exists,
            "Student already registered"
        );

        Student memory newStudent = Student({
            name: _name,
            age: _age,
            rollNumber: _rollNumber,
            exists: true
        });

        students[_studentAddress] = newStudent;
    }

    // Teacher Update Records
    function updateTeacher(
        address _teacherAddress,
        string memory _name,
        uint _age,
        string memory _subject
    ) public principle {
        require(teachers[_teacherAddress].exists, "Teacher not registered");
        teachers[_teacherAddress].name = _name;
        teachers[_teacherAddress].age = _age;
        teachers[_teacherAddress].subject = _subject;
    }

    // Teacher Deletion Records
    function deleteTeacher(address _teacherAddress) public principle {
        require(teachers[_teacherAddress].exists, "Teacher not registered");
        delete teachers[_teacherAddress];
    }

    // Get Teacher Details
    function getTeacher(
        address _teacherAddress
    ) public view returns (string memory, uint, string memory) {
        require(teachers[_teacherAddress].exists, "Teacher not registered");
        return (
            teachers[_teacherAddress].name,
            teachers[_teacherAddress].age,
            teachers[_teacherAddress].subject
        );
    }

    // Student Update Records
    function updateStudent(
        address _studentAddress,
        string memory _name,
        uint _age,
        string memory _rollNumber
    ) public principle {
        require(students[_studentAddress].exists, "Student not registered");
        students[_studentAddress].name = _name;
        students[_studentAddress].age = _age;
        students[_studentAddress].rollNumber = _rollNumber;
    }

    // Student Deletion Records
    function deleteStudent(address _studentAddress) public principle {
        require(students[_studentAddress].exists, "Student not registered");
        delete students[_studentAddress];
    }

    // Get Student Details
    function getStudent(
        address _studentAddress
    ) public view returns (string memory, uint, string memory) {
        require(students[_studentAddress].exists, "Student not registered");
        return (
            students[_studentAddress].name,
            students[_studentAddress].age,
            students[_studentAddress].rollNumber
        );
    }
}
