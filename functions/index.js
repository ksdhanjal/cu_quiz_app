const admin = require("firebase-admin");
admin.initializeApp();

const login = require("./all functions/student_login");
const teacherLogin = require("./all functions/teacher_login");
const createStudent = require("./all functions/create_student");
const createTest = require("./all functions/create_test");
const assignTestToClass = require("./all functions/assign_test_to_class");
const getTestResults = require("./all functions/get_test_results");

exports.login = login.login;
exports.createStudent = createStudent.createStudent;
exports.createTest = createTest.createTest;
exports.assignTestToClass = assignTestToClass.assignTestToClass;
exports.teacherLogin = teacherLogin.teacherLogin;
exports.getTestResults = getTestResults.getTestResults;
