const functions = require("firebase-functions");
const admin = require("firebase-admin");
const db = admin.firestore();
const cors = require("cors")({origin: true});

exports.getTestResults = functions.https.onRequest((request, response) => {
  cors(request, response, () => {
    console.log("request body", request.body.data);
    const {semester, department} = request.body.data;

    console.log("semester", semester);
    console.log("department", department);
    const testResults = [];
    db.collection("students")
        .where("department", "==", department)
        .where("semester", "==", parseInt(semester))
        .get()
        .then((snapshot) => {
          if (snapshot.empty) {
            console.log("No matching documents.");
            response.send({
              data: {message: "No students found", success: false},
            });
          } else {
            console.log(snapshot.docs.length);
            snapshot.forEach((doc) => {
              const data = doc.data();
              testResults.push(data);
            });
            response.send({
              data: {
                success: true,
                students: testResults,
              },
            });
          }
        })
        .catch((err) => {
          response.send({
            data: {
              success: false,
              errorMessage: err,
            },
          });
        });
  });
});
