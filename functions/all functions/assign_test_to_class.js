const functions = require("firebase-functions");
const admin = require("firebase-admin");
const db = admin.firestore();
const cors = require("cors")({origin: true, allowedHeaders: "*"});

exports.assignTestToClass = functions.https.onRequest((req, res) => {
  cors(req, res, () => {
    const testData = req.body.data;
    console.log("test data:-", testData);

    const semester = parseInt(testData.semester);
    const department = testData.department;
    console.log(testData.testDateTime.seconds);

    db.collection("students")
        .where("department", "==", department)
        .where("semester", "==", semester)
        .get()
        .then((snapshot) => {
          if (snapshot.empty) {
            res.send({
              data: {message: "No students found", success: false},
            });
          } else {
            console.log("is snapshot empty", snapshot.empty);
            snapshot.forEach((doc) => {
              console.log(doc.id);
              doc.ref
                  .update({
                    assignedTest: admin.firestore.FieldValue.arrayUnion({
                      testID: testData.testID,
                      testName: testData.testName,
                      testDateTime: admin.firestore.Timestamp.fromMillis(
                          testData.testDateTime.seconds * 1000,
                      ),
                    }),
                  })
                  .then(() => {
                    res.send({
                      data: {
                        message: "Test assigned successfully",
                        success: true,
                      },
                    });
                  });
            });
          }
        })
        .catch((err) => {
          console.log("Error getting documents", err.message);
          res.send({
            data: {
              message: `Error assigning test! ${err.message}`,
              success: false,
            },
          });
        });
  });
});
